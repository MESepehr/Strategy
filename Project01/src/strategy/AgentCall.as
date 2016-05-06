package strategy
{
	import flash.events.Event;
	
	public class AgentCall extends Event
	{
		/**Ask to get other agents*/
		internal static const REQUEST_OTHER_AGENTS:String = "REQUEST_OTHER_AGENTS" ;
		
		/**The agent is dead.*/
		public static const IM_DEAD:String = "IM_DEAD" ;
		
		/**Request to quide to the next*/
		public static const GUIDE_ME:String = "GUIDE_ME" ;
		
		/**Whant to kill someone*/
		public static const START_TO_KILL:String = "START_TO_KILL" ;
		
		/**Kill someone imidiatly*/
		public static const KILL_SOME_ONE:String = "KILL_SOME_ONE" ;
		
		/**I killed my enemy*/
		public static const I_KILLED_HIEM:String = "I_KILLED_HIEM" ;
		
		/**I'm free and had no enemy*/
		public static const I_AM_FREE:String = "I_AM_FREE" ;
		
		/**Anim over and can be relax*/
		public static const ANIM_OVER:String = "ANIM_OVER" ;
		
		/**Request from the main clas to remove it from the stage*/
		public static const FORGET_MY_BODY:String = "FORGET_MY_BODY" ;
		
		public var targetAgent:AgentBase,
					agentStep:Number;
					
		
		public function AgentCall(type:String,TargetAgent:AgentBase=null,AgentStep:Number=0)
		{
			super(type, true);
			
			targetAgent = TargetAgent;
			agentStep = AgentStep ;
		}
	}
}