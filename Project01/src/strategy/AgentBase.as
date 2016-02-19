package strategy
{
	import flash.events.EventDispatcher;

	[Event(name="REQUEST_OTHER_AGENTS", type="strategy.AgentCall")]
	public class AgentBase extends EventDispatcher
	{
		public var x:Number,y:Number;
		
		public var teamColor:uint ;
		
		private var otherAgents:Vector.<AgentBase> ;
		
		private var targetAgent:AgentBase ;
		
		public function AgentBase(x0:Number,y0:Number,TeamColor:uint)
		{
			x = x0 ;
			y = y0 ;
			teamColor = TeamColor ;
		}
		
		
		/**Move the agent one step forward*/
		public function step():void
		{
			if(targetAgent==null || targetAgent.isDead())
			{
				this.dispatchEvent(new AgentCall(AgentCall.REQUEST_OTHER_AGENTS));
			}
		}
		
		
		public function getOtherAgents(agents:Vector.<AgentBase>):void
		{
			
		}
		
		
		/**Returns true if the agent is dead*/
		public function isDead():Boolean
		{
			return false ;
		}
	}
}