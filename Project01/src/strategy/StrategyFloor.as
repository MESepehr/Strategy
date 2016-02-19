package strategy
{
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
		
		private function addAllListenets(newAgent:AgentBase):void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function removeAllListeners(removedAgent:AgentBase):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function step():void
		{
			var l:uint = agents.length; 
			var removedAgent:AgentBase ;
			for(var i = 0 ; i<l ; i++)
			{
				agents[i].step();
				
				if(agents[i].isDead())
				{
					removedAgent = agents.splice(i,1)[0] ;
					removeAllListeners(removedAgent);
					removedAgent = null ;
					l--;
					i--;
				}
			}
		}
		
	}
}