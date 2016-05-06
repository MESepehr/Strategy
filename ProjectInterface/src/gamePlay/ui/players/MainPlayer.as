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
		
		private static var startPoint:Point,
							endPoint:Point ;
							
		private static var floorW:Number,floorH:Number ;
		
		private static var matrixW:uint,matrixH:uint;
		
		private static const cos45:Number = Math.cos(45*Math.PI/180)
							,sin45:Number = Math.sin(45*Math.PI/180);
		
		public static function setUp(StartPoint:Point,EndPoint:Point,floorPointsX:uint,floorPointsY:uint)
		{
			matrixW = floorPointsX ;
			matrixH = floorPointsY ;
			startPoint = StartPoint;
			endPoint = EndPoint ;
			floorW = endPoint.x-startPoint.x;
			floorH = endPoint.y-startPoint.y;
		}
		
		public function MainPlayer(myAgent:AgentBase)
		{
			super();
			if(endPoint==null)
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
			var X:Number = (newX/matrixW)*floorW;
			var Y:Number = (newY/matrixH)*floorH;
			this.x = X;//*cos45-sin45*Y;
			this.y = Y+(floorW/2);//*cos45-sin45*X;
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