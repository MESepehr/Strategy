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
		public var 	buildings:Vector.<AgentBase> ;
		
		public var blockedList:Vector.<Boolean> ;
		
		public function StrategyFloor(W:uint,H:uint)
		{
			w = W ;
			h = H ;
			
			blockedList = new Vector.<Boolean>(w*h);
			
			agents = new Vector.<AgentBase>();
			buildings = new Vector.<AgentBase>();
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
				buildings.push(newAgent);
				makeItNotPassable(x0,y0);
				//No need to sort, I add an other list to manage blocked buildings. may be I remove the bulding list at all
				//buildings.sort(sortBuildingByY)
			}
		}
		
		private function makeItNotPassable(x:uint,y:uint):void
		{
			blockedList[y*w+x] = true ;
		}
		
		private function makeIfPassable(x:uint,y:uint):void
		{
			blockedList[y*w+x] = false ;
		}
		
		
			/**Sort building by Y
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
			}*/
			/**Sort building by X
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
			}*/
		
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
			var x0:Number = myAgent.x;
			var y0:Number = myAgent.y;
			var targetX:Number ;
			var targetY:Number ;
			
			
			targetX = event.targetAgent.x;
			targetY = event.targetAgent.y;
			
			var deltaPoint:Point;
			var distance:Number ;
			var dx:Number ;
			var dy:Number ;
			
			//Second while variables
			var currentX:Number ;
			var currentY:Number ;
			/**Controll how much Agent moved*/
			var moved:Number ;
			/**Controll if Agent should change its direction*/
			var isDirectionChanged:Boolean ;
			
			var hangController:uint = 0 ;
			
			do
			{
				hangController++;
				
				deltaPoint = new Point(targetX-x0,targetY-y0);
				distance = deltaPoint.length;
				dx = (deltaPoint.x/distance)*agentStep;
				dy = (deltaPoint.y/distance)*agentStep;
				
				currentX = x0;
				currentY = y0;
				
				moved = 0;
				isDirectionChanged = false;
				do{
					moved+=agentStep ;
					currentX+=dx;
					currentY+=dy;
					trace("Controll for me : "+myAgent.teamColor.toString(16));
					trace("Controll : "+currentX,currentY);
					if(!isPassable(currentX,currentY))
					{
						trace("I cannot pass : "+myAgent.teamColor.toString(16));
						trace("y0 : "+y0+" currentY : "+currentY+" targetY : "+targetY);
						var foundedPoint:Point;
						if((uint(y0)<=currentY && currentY<=uint(targetY)) || (uint(y0)>=currentY && currentY>=uint(targetY)))
						{
							foundedPoint = findClosestFreeTile(currentX,currentY,false,true);
						}
						else
						{
							foundedPoint = findClosestFreeTile(currentX,currentY,true,false);
						}
						targetX = foundedPoint.x;
						targetY = foundedPoint.y;
						trace("New direction is : "+foundedPoint);
						isDirectionChanged = true ;
						break;
					}
				}while(moved<distance);
				
				if(isDirectionChanged)
				{
					//Agent must select an other direction
					continue;
				}
				else
				{
					break;
				}
			}while(true && hangController<100);
			
			trace("hangController : "+hangController);
				
				
			
			myAgent.stepForwardBasedOnGUIDE_ME_request(dx,dy);
		}
		
		/**Find the closest wall by the entered direction<br>
		 * dx meanse Agent should find his path in the Y direction and dy means the y direction is fix and agent should find his path on the X direction*/
		private function findClosestFreeTile(blockedX:uint,blockedY:uint,dx:Boolean=false,dy:Boolean=false):Point
		{
			trace("Find base point instead of "+blockedX,blockedY+" by the direction x :"+dx+' or y :'+dy);
			var nextIndex:uint ;
			var prevIndex:uint ; 
			var exiter:Boolean ;
			if(dy)
			{
				nextIndex = prevIndex = blockedX;
				do
				{
					exiter = false ;
					nextIndex++;
					prevIndex--;
					if(nextIndex<w)
					{
						exiter = true ;
						if(isPassable(nextIndex,blockedY))
						{
							return new Point(nextIndex,blockedY);
						}
					}
					if(prevIndex>=0)
					{
						exiter = true ;
						if(isPassable(prevIndex,blockedY))
						{
							return new Point(prevIndex,blockedY);
						}
					}
				}while(exiter)
			}
			else if(dx)
			{
				nextIndex = prevIndex = blockedY;
				do
				{
					exiter = false ;
					nextIndex++;
					prevIndex--;
					if(nextIndex<h)
					{
						exiter = true ;
						if(isPassable(blockedX,nextIndex))
						{
							return new Point(blockedX,nextIndex);
						}
					}
					if(prevIndex>=0)
					{
						exiter = true ;
						if(isPassable(blockedX,prevIndex))
						{
							return new Point(blockedX,prevIndex);
						}
					}
				}while(exiter)
			}
			throw "No direction enterd here";
			/*var agentIndex:int = buildings_sortX.indexOf(currentAgent) ;
			var nextIndex:int = agentIndex ;
			var prevIndex:int = agentIndex ;
			var maxBuildings:uint = buildings_sortX.length ;
			var exiter:uint ;
			if(dy)
			{
				//buildings_sortX
				do
				{
					nextIndex++;
					prevIndex--;
					exiter = 0 ;
					if(nextIndex<maxBuildings)
					{
						if(buildings_sortX[nextIndex].
						exiter++;
					}
					if(prevIndex>=0)
					{
						exiter++;
					}
				}while(exiter!=0)
			}*/
			return new Point();
		}
		
		/**Returns the blucker tile if this tile is not passable*/
		private function isPassable(x:uint,y:uint):Boolean
		{
			return !blockedList[y*w+x];
			/*var l:uint = buildings.length ;
			for(var i = 0 ; i<l ; i++)
			{
				if(buildings[i].x == x && buildings[i].y == y)
				{
					return buildings[i] ;
				}
			}
			return null ;*/
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