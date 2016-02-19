package strategy
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;

	[Event(name="REQUEST_OTHER_AGENTS", type="strategy.AgentCall")]
	public class AgentBase extends EventDispatcher
	{
		public var x:Number,y:Number;
		
		public var teamColor:uint ;
		
		private var otherAgents:Vector.<AgentBase> ;
		
		private var targetAgent:AgentBase ;
		
		/**This is the distance between each steps that user takes*/
		private var runSpeed:Number;
		
		/**Agent moving speed*/
		private var moveSpeed:Number ;
		
		/**0: sleep, 1:move, 2:Aware, 3:Kill , 4:run, 5:Attack*/
		private var mode:uint;
		
		/**This is the maximom range that user can hit his anamy from thaht distance*/
		private var hitRange:Number;
		
		/**Thsi is the user life*/
		private var life:Number ;
		
		private var weaponDamage:Number ;
		
		public function AgentBase(x0:Number,y0:Number,TeamColor:uint,myMoveSteps:Number=0.5,myRunSteps:Number=1,myHitRange:Number=2,myLife:Number=100,myWeaponDamage:Number=20)
		{
			x = x0 ;
			y = y0 ;
			moveSpeed = myMoveSteps ;
			runSpeed = myRunSteps ;
			teamColor = TeamColor ;
			hitRange = myHitRange ;
			life = myLife;
			mode = 1 ;
			weaponDamage = myWeaponDamage ;
		}
		
		public function hitMe(damage:Number):void
		{
			life -= damage ;
			if(isDead())
			{
				this.dispatchEvent(new AgentCall(AgentCall.IM_DEAD));
			}
		}
		
		/**Change the steps based on agent mode*/
		protected function getStep():Number
		{
			var currentStep:Number ;
			switch(mode)
			{
				case 1:
				case 2:
					return moveSpeed;
					break;
				case 3:
				case 4:
				case 5:
					return runSpeed
			}
			return 0 ;
		}
		
		/**Move the agent one step forward*/
		public function step():void
		{
			if(targetAgent==null || targetAgent.isDead())
			{
				mode = 2;
				this.dispatchEvent(new AgentCall(AgentCall.REQUEST_OTHER_AGENTS));
			}
			else if(isInMyHitRange(targetAgent))
			{
				mode = 3 ;
				targetAgent.hitMe(weaponDamage);
			}
			else
			{
				mode = 5 ;
				var currentStep:Number = getStep() ;
				if(targetAgent.x>x)
				{
					x+=currentStep;
				}
				else
				{
					x-=currentStep;
				}
				if(targetAgent.y>y)
				{
					y+=currentStep;
				}
				else
				{
					y-=currentStep;
				}
			}
		}
		
		/**Returns true if this agent is in my range*/
		private function isInMyHitRange(targetAgent:AgentBase):Boolean
		{
			if(targetAgent.getDistanceFrom(this)<hitRange)
			{
				return true ;
			}
			else
			{
				return false ;
			}
		}		
		
		public function getOtherAgents(agents:Vector.<AgentBase>):void
		{
			otherAgents = null;
			otherAgents = agents ;
			for(var i = 0 ; i<otherAgents.length ; i++)
			{
				if(otherAgents[i].teamColor!=teamColor)
				{
					targetAgent = otherAgents[i];
					break;
				}
			}
		}
		
		
		/**Returns true if the agent is dead*/
		public function isDead():Boolean
		{
			if(life<0)
			{
				return true ;
			}
			return false ;
		}
		
		
		/**Return the distance between me and otehr agent*/
		public function getDistanceFrom(otherAgent:AgentBase):Number
		{
			return new Point(otherAgent.x-x,otherAgent.y-y).length;
		}
	}
}