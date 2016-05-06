package strategy
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;

	public class StrategyFloor
	{
		
		/**Full list of agents*/
		public var agents:Vector.<AgentBase> ;
		/**Only the building agents*/
		public var 	buildings:Vector.<AgentBase> ;
		
		private var _debugBitmap:Bitmap ;
		
		public function StrategyFloor(W:uint,H:uint)
		{
			StepHandler.w = W ;
			StepHandler.h = H ;
			StepHandler.totalPixels = W*H ;
			
			StepHandler.blockedList = new Vector.<Boolean>(StepHandler.w*StepHandler.h);
			
			agents = new Vector.<AgentBase>();
			buildings = new Vector.<AgentBase>();
		}
		
		/**x0: x position to start agent<br>
		 * y0: y position to start agent<br>
		 * teamColor: uses to define teams and their own color. the 0 is no team*/
		public function addAgent(x0:Number,y0:Number,teamColor:uint,isPassable:Boolean=true,canMove:Boolean=true,myMoveSteps:Number=0.5,myRunSteps:Number=1,myHitRange:Number=1,myLife:Number=100,myWeaponDamage:Number=20):AgentBase
		{
			//I need agent type to
			var newAgent:AgentBase = new AgentBase(x0,y0,teamColor,isPassable,canMove,myMoveSteps,myRunSteps,myHitRange,myLife,myWeaponDamage);
			addAllListenets(newAgent);
			agents.push(newAgent);
			if(!isPassable)
			{
				buildings.push(newAgent);
				StepHandler.makeItNotPassable(x0,y0);
				//No need to sort, I add an other list to manage blocked buildings. may be I remove the bulding list at all
				//buildings.sort(sortBuildingByY)
			}
			return newAgent ;
		}
		
		
		
		/**Add building to the stage.<br>
		 * the x and y values will pass as uint*/
		public function addBuilding(x0:uint,y0:uint,dxTiles:uint,dyTiles:uint,teamColor:uint):void
		{
			for(var i = 0 ; i<dxTiles ; i++)
			{
				for(var j = 0 ; j<dyTiles ; j++)
				{
					addAgent(x0+i,y0+j,teamColor,false,false);
				}
			}
		}
		
		/**Add all event listeners to this agent*/
		private function addAllListenets(newAgent:AgentBase):void
		{
			newAgent.addEventListener(AgentCall.REQUEST_OTHER_AGENTS,returnNearAgents);
			newAgent.addEventListener(AgentCall.IM_DEAD,agentIsDead);
			newAgent.addEventListener(AgentCall.GUIDE_ME,guiedHim);
		}		
		
		/**Guide this agent forward*/
		protected function guiedHim(event:AgentCall):void
		{
			var myAgent:AgentBase = event.target as AgentBase ;
			var agentStep:Number = event.agentStep ;
			
			StepHandler.guideMe(myAgent.x,myAgent.y,event.targetAgent.x,event.targetAgent.y,agentStep);
				
			myAgent.stepForwardBasedOnGUIDE_ME_request(StepHandler.dx,StepHandler.dy);
		}
		
		
		
		/**This agent is dead. remove all listeners*/
		private function removeAllListeners(removedAgent:AgentBase):void
		{
			removedAgent.removeEventListener(AgentCall.REQUEST_OTHER_AGENTS,returnNearAgents);
			removedAgent.removeEventListener(AgentCall.IM_DEAD,agentIsDead);
			removedAgent.removeEventListener(AgentCall.GUIDE_ME,guiedHim);
		}
		
		public function step():void
		{
			//var l:uint = agents.length; 
			for(var i = 0 ; i<agents.length ; i++)
			{
				agents[i].step();
			}
			
			if(_debugBitmap)
			{
				_debugBitmap.bitmapData.lock();
				_debugBitmap.bitmapData.fillRect(_debugBitmap.bitmapData.rect,0x000000);
				var l:uint = agents.length;
				for(var i = 0 ; i<l ; i++)
				{
					//	trace("Draw the unit : "+Math.floor(myStrategy.agents[i].x),Math.floor(myStrategy.agents[i].y));
					_debugBitmap.bitmapData.setPixel32(Math.floor(agents[i].x),Math.floor(agents[i].y),agents[i].teamColor)
				}
				_debugBitmap.bitmapData.unlock();
			}
		}
		
		/**This agent is dead*/
		protected function agentIsDead(event:AgentCall):void
		{
			var myAgent:AgentBase = event.target as AgentBase ;
			var agentIndex:int = agents.indexOf(myAgent);
			var removedAgent:AgentBase ;
			removedAgent = agents.splice(agentIndex,1)[0] ;
			removeAllListeners(removedAgent);
			removedAgent = null ;
		}
		
		
		/**The agent need to know who is near him*/
		protected function returnNearAgents(event:AgentCall):void
		{
			var myAgent:AgentBase = event.target as AgentBase ;
			var agentListForHim:Vector.<AgentBase> = agents.concat();
			agentListForHim.sort(nearAgents);
			
			function nearAgents(agent1:AgentBase,agent2:AgentBase):int
			{
				var dist1:Number = agent1.getDistanceFrom(myAgent);
				var dist2:Number = agent2.getDistanceFrom(myAgent);
				if(dist1<dist2)
				{
					return -1;
				}
				else if(dist1>dist2)
				{
					return 1;
				}
				else
				{
					return 0 ;
				}
			}
			
			myAgent.getOtherAgents(agentListForHim);
		}
		
		public function debugBitmap():Bitmap
		{
			// TODO Auto Generated method stub
			trace("StepHandler.w : "+StepHandler.w);
			return _debugBitmap = new Bitmap(new BitmapData(StepHandler.w,StepHandler.h,false,0x000000));
		}
	}
}