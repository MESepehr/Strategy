package strategy
{
	import flash.events.Event;
	import flash.geom.Point;

	public class StrategyFloor
	{
		private var w:uint,h:uint;
		
		public var agents:Vector.<AgentBase> ;
		
		public function StrategyFloor(W:uint,H:uint)
		{
			w = W ;
			h = H ;
			
			agents = new Vector.<AgentBase>();
		}
		
		/**x0: x position to start agent<br>
		 * y0: y position to start agent<br>
		 * teamColor: uses to define teams and their own color. the 0 is no team*/
		public function addAgent(x0:Number,y0:Number,teamColor:uint):void
		{
			//I need agent type to
			var newAgent:AgentBase = new AgentBase(x0,y0,teamColor);
			addAllListenets(newAgent);
			agents.push(newAgent);
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
			
			var deltaPoint:Point = new Point(targetAgent.x-myAgent.x,targetAgent.y-myAgent.y);
			var distance:Number = deltaPoint.length ;
			var dx:Number = (deltaPoint.x/distance)*agentStep ;
			var dy:Number = (deltaPoint.y/distance)*agentStep ;
			
			myAgent.stepForwardBasedOnGUIDE_ME_request(dx,dy);
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