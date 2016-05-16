package gamePlay.ui.players
	//gamePlay.ui.players.MainPlayer
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	import strategy.AgentBase;
	import strategy.AgentCall;
	
	public class MainPlayer extends MovieClip
	{
		private var lastX:Number=0,
					lastY:Number=0;
		
		private var agent:AgentBase ;
		
		private static var lPoint:Point,
							uPoint:Point,
							dPoint:Point,
							rPoint:Point ;
							
		private static var floorW:Number,floorH:Number ;
		
		private static var matrixW:uint,matrixH:uint;
		
		private static const cos45:Number = Math.cos(45*Math.PI/180)
							,sin45:Number = Math.sin(45*Math.PI/180);
		
		/**1 to 8 like clock*/
		private var lastRot:uint ;
		
		private var currentAnimation:MovieClip ;
		
		public static function setUp(LeftPoint:Point,RightPoint:Point,UpPoint:Point,DownPoint:Point,floorPointsX:uint,floorPointsY:uint)
		{
			matrixW = floorPointsX ;
			matrixH = floorPointsY ;
			lPoint = LeftPoint;
			rPoint = RightPoint ;
			uPoint = UpPoint ;
			dPoint = DownPoint ;
			floorW = RightPoint.x-lPoint.x;
			floorH = DownPoint.y-UpPoint.y ;
		}
		
		private function setFrameAndRotation(frameNum:uint):void
		{
			this.gotoAndStop(frameNum);
			currentAnimation = Obj.findThisClass(MovieClip,this,false);
			setRotaion();
		}
		
		private function setRotaion():void
		{
			if(currentAnimation)
			{
				currentAnimation.gotoAndStop(lastRot);
			}
		}
		
		public function MainPlayer(myAgent:AgentBase)
		{
			super();
			if(lPoint==null)
			{
				throw "You have to setUp the MainPlayer class first";
			}
			agent = myAgent ;
			this.stop();
			this.addEventListener(Event.ENTER_FRAME,anim);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			lastX = agent.x;
			lastY = agent.y;
			
			setMyXY(agent.x,agent.y);
			
			agent.addEventListener(AgentCall.IM_DEAD,deathAnim);
			agent.addEventListener(AgentCall.START_TO_KILL,gotoKillAnim);
			this.addEventListener(AgentCall.KILL_SOME_ONE,killSelectedPerson);
			agent.addEventListener(AgentCall.GUIDE_ME,runningToKill);
			agent.addEventListener(AgentCall.I_AM_FREE,stopping);
			this.addEventListener(AgentCall.FORGET_MY_BODY,removeMeRealy);
		}
		
		protected function removeMeRealy(event:Event):void
		{
			event.stopImmediatePropagation();
			this.removeEventListener(AgentCall.FORGET_MY_BODY,removeMeRealy);
			this.dispatchEvent(new AgentCall(AgentCall.FORGET_MY_BODY));
			this.addEventListener(AgentCall.FORGET_MY_BODY,removeMeRealy);
		}
		
		protected function stopping(event:Event):void
		{
			setFrameAndRotation(1);
		}
		
		protected function runningToKill(event:Event):void
		{
			setFrameAndRotation(4);
		}
		
		/**This event calls on animated clip*/
		protected function killSelectedPerson(event:Event):void
		{
			agent.kilHimInstantly();
		}
		
		protected function gotoKillAnim(event:Event):void
		{
			event.stopImmediatePropagation();
			setFrameAndRotation(2);
		}
		
		protected function deathAnim(event:Event):void
		{
			setFrameAndRotation(3);
		}
		
		private function setMyXY(newX:Number,newY:Number):void
		{
			var rad:Number = Math.atan2(newX-lastX,newY-lastY);
			var xPrecent:Number = newX/matrixW;
			var yPrecent:Number = newY/matrixH;
			var X:Number = xPrecent*floorW;
			var Y:Number = yPrecent*floorH;
			/*trace("yPrecent: "+yPrecent);
			trace("floorH: "+floorH);
			trace("floorW: "+floorW);
			trace("X : "+X);
			trace("Y : "+Y);
			trace("newX : "+newX);
			trace("matrixW : "+matrixW);
			trace("lPoint.y : "+lPoint.y);
			trace("xPrecent : "+xPrecent);
			trace("Y/2-xPrecent*floorH : "+(Y/2-xPrecent*floorH));*/
			this.x = lPoint.x+X/2+(yPrecent*floorW)/2;//*cos45-sin45*Y;
			this.y = lPoint.y+Y/2-(xPrecent*floorH)/2;
			//trace(" floorH/2  : "+(floorH/2));
		}
		
		protected function unLoad(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME,anim);
		}
		
		protected function anim(event:Event):void
		{
			setMyXY(agent.x,agent.y);
			
			var deltaX:Number = this.x-lastX;
			var deltaY:Number = this.y-lastY;
			
			if(deltaX!=0 || deltaY!=0)
			{
				//lastRot = Math.round(Math.abs((Math.atan2(deltaX,deltaY)+Math.PI*-2)/Math.PI*4)%8)+1 ;
			}
			else
			{
				if(agent.targetAgent)
				{
					deltaX = agent.targetAgent.x-agent.x;
					deltaY = agent.targetAgent.y-agent.y;
				}
			}
			
			if(deltaX!=0 || deltaY!=0)
			{
				lastRot = Math.round(Math.abs((Math.atan2(deltaX,deltaY)+Math.PI*-2)/Math.PI*4)%8)+1 ;
			}
			//trace("Rad is : "+((Math.atan2(deltaX,deltaY)/Math.PI*180)));
			
			
			
			lastX = this.x;
			lastY = this.y;
			setRotaion();
		}
	}
}