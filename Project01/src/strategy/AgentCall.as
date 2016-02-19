package strategy
{
	import flash.events.Event;
	
	internal class AgentCall extends Event
	{
		/**Ask to get other agents*/
		public static const REQUEST_OTHER_AGENTS:String = "REQUEST_OTHER_AGENTS" ;
		
		/**The agent is dead.*/
		public static const IM_DEAD:String = "IM_DEAD" ;;
		
		public function AgentCall(type:String)
		{
			super(type, false);
		}
	}
}