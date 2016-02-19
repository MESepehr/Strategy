package strategy
{
	import flash.events.Event;
	
	internal class AgentCall extends Event
	{
		/**Ask to get other agents*/
		public static const REQUEST_OTHER_AGENTS:String = "REQUEST_OTHER_AGENTS" ;
		
		/**The agent is dead.*/
		public static const IM_DEAD:String = "IM_DEAD" ;
		
		/**Request to quide to the next*/
		public static const GUIDE_ME:String = "GUIDE_ME" ;
		
		public var targetAgent:AgentBase,
					agentStep:Number;
					
		
		public function AgentCall(type:String,TargetAgent:AgentBase=null,AgentStep:Number=0)
		{
			super(type, false);
			
			targetAgent = TargetAgent;
			agentStep = AgentStep ;
		}
	}
}