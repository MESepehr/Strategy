package gamePlay.ui.players
	//gamePlay.ui.players.MainPlayer
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	import strategy.AgentBase;
	
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
		
		public static function setUp(LeftPoint:Point,RightPoint:Point,UpPoint:Point,DownPoint:Point,floorPointsX:uint,floorPointsY:uint)
		{
			matrixW = floorPointsX ;
			matrixH = floorPointsY ;
			lPoint = LeftPoint;
			rPoint = RightPoint ;
			uPoint = UpPoint ;
			dPoint = DownPoint ;
			floorW = RightPoint.x-lPoint.x;
			floorH = UpPoint.y-DownPoint.y ;
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
		}
		
		private function setMyXY(newX:Number,newY:Number):void
		{
			var rad:Number = Math.atan2(newX-lastX,newY-lastY);
			var xPrecent:Number = newX/matrixW;
			var yPrecent:Number = newY/matrixH;
			var X:Number = xPrecent*floorW;
			var Y:Number = yPrecent*floorH;
			trace("X : "+X);
			trace("Y : "+Y);
			trace("newX : "+newX);
			trace("matrixW : "+matrixW);
			trace("lPoint.y : "+lPoint.y);
			trace("xPrecent : "+xPrecent);
			trace("Y/2-xPrecent*floorH : "+(Y/2-xPrecent*floorH));
			//this.x = X/2+Y/2;//*cos45-sin45*Y;
			this.y = lPoint.y+Y/2-xPrecent*floorH;//Y/2-X/2+startPoint.y;//*cos45-sin45*X;
			//trace(" floorH/2  : "+(floorH/2));
		}
		
		protected function unLoad(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME,anim);
		}
		
		protected function anim(event:Event):void
		{
			setMyXY(agent.x,agent.y);
		}
	}
}