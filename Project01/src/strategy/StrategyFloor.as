package strategy
{
	import flash.events.Event;
	import flash.geom.Point;

	public class StrategyFloor
	{
		private var w:uint,h:uint;
		
		/**Full list of agents*/
		public var agents:Vector.<AgentBase> ;
		/**Only the building agents*/
		public var 	buildings_sortY:Vector.<AgentBase> ,
					buildings_sortX:Vector.<AgentBase> ;
		
		public function StrategyFloor(W:uint,H:uint)
		{
			w = W ;
			h = H ;
			
			agents = new Vector.<AgentBase>();
			buildings_sortY = new Vector.<AgentBase>();
			buildings_sortX = new Vector.<AgentBase>();
		}
		
		/**x0: x position to start agent<br>
		 * y0: y position to start agent<br>
		 * teamColor: uses to define teams and their own color. the 0 is no team*/
		public function addAgent(x0:Number,y0:Number,teamColor:uint,isPassable:Boolean=true,canMove:Boolean=true):void
		{
			//I need agent type to
			var newAgent:AgentBase = new AgentBase(x0,y0,teamColor,isPassable,canMove);
			addAllListenets(newAgent);
			agents.push(newAgent);
			if(!isPassable)
			{
				buildings_sortY.push(newAgent);
				buildings_sortX.push(newAgent);
				
				buildings_sortY.sort(sortBuildingByY)
				buildings_sortX.sort(sortBuildingByX)
			}
		}
		
			/**Sort building by Y*/
			private function sortBuildingByY(agentA:AgentBase,agentB:AgentBase):int
			{
				if(agentA.y<agentB.y)
				{
					return -1;
				}
				else if(agentA.y>agentB.y)
				{
					return 1;
				}
				return 0;
			}
			/**Sort building by X*/
			private function sortBuildingByX(agentA:AgentBase,agentB:AgentBase):int
			{
				if(agentA.x<agentB.x)
				{
					return -1;
				}
				else if(agentA.x>agentB.x)
				{
					return 1;
				}
				return 0;
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
			var targetAgent:AgentBase = event.targetAgent ;
			var agentStep:Number = event.agentStep ;
			var x0:Number = myAgent.x;
			var y0:Number = myAgent.y;
			var targetX:Number = targetAgent.x ;
			var targetY:Number = targetAgent.y ;
			
			var deltaPoint:Point = new Point(targetX-x0,targetY-y0);
			var distance:Number = deltaPoint.length ;
			var dx:Number = (deltaPoint.x/distance)*agentStep ;
			var dy:Number = (deltaPoint.y/distance)*agentStep ;
			
			var currentX:uint = x0 ;
			var currentY:uint = y0 ;
			
			var moved:Number = 0 ;
			var hittedWall:AgentBase ;
			do{
				moved+=agentStep ;
				currentX+=dx;
				currentY+=dy;
				if((hittedWall = isPassable(currentX,currentY)) != null)
				{
					trace("The agent cannot pass this tile");
					/*if(hittedWall.x<x0)
					{
						findClosestFreeTile(currentX,currentY,);
					}*/
				}
			}while(moved<distance);
			
			myAgent.stepForwardBasedOnGUIDE_ME_request(dx,dy);
		}
		
		/**Find the closest wall by the entered direction*/
		private function findClosestFreeTile(blockedWallX:uint,blockedWallY:uint,dx:Boolean=false,dy:Boolean=false):Point
		{
			trace("search for the free tile based on dx or dy");
			return new Point();
		}
		
		/**Returns the blucker tile if this tile is not passable*/
		private function isPassable(x:uint,y:uint):AgentBase
		{
			var l:uint = buildings_sortY.length ;
			for(var i = 0 ; i<l ; i++)
			{
				if(buildings_sortY[i].x == x && buildings_sortY[i].y == y)
				{
					return buildings_sortY[i] ;
				}
			}
			return null ;
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
		
	}
}