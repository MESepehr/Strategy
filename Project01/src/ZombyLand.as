package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import strategy.StrategyFloor;
	
	public class ZombyLand extends Sprite
	{
		private var myStrategy:StrategyFloor ;
		
		private var strategyFloor:BitmapData,
					strategyBitmap:Bitmap;
		
		private const W:uint = 100,H:uint=100;
		
		public function ZombyLand()
		{
			super();
			
			myStrategy = new StrategyFloor(W,H);
			strategyFloor = new BitmapData(W,H,false,0x000000);
			strategyBitmap = new Bitmap(strategyFloor);
			
			strategyBitmap.width = stage.stageWidth;
			strategyBitmap.height = stage.stageHeight;
			
			
			this.addChild(strategyBitmap);
			this.addEventListener(Event.ENTER_FRAME,anim);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,addAgentTo);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,addAgent2To);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL,addBuilding,false,100);
		}
		
		protected function addBuilding(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			trace("Create building");
			event.stopImmediatePropagation();
			var mx:uint = strategyBitmap.mouseX ;
			var my:uint = strategyBitmap.mouseY ;
			myStrategy.addBuilding(mx-1,my-1,3,3,0xffffff);
		}
		
		protected function addAgent2To(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			event.preventDefault();
			event.stopImmediatePropagation();
			var X:Number = (strategyBitmap.mouseX);
			var Y:Number = (strategyBitmap.mouseY);
			myStrategy.addAgent(X,Y,0x0000ff)
		}
		
		protected function addAgentTo(event:MouseEvent):void
		{
			var X:Number = (strategyBitmap.mouseX);
			var Y:Number = (strategyBitmap.mouseY);
			myStrategy.addAgent(X,Y,0xff0000)
		}
		
		/**Step strategy floor forward and draw the debug bitmap fo it*/
		protected function anim(event:Event):void
		{
			myStrategy.step();
			strategyFloor.lock();
			strategyFloor.fillRect(strategyFloor.rect,0x000000);
			var l:uint = myStrategy.agents.length;
			for(var i = 0 ; i<l ; i++)
			{
			//	trace("Draw the unit : "+Math.floor(myStrategy.agents[i].x),Math.floor(myStrategy.agents[i].y));
				strategyFloor.setPixel32(Math.floor(myStrategy.agents[i].x),Math.floor(myStrategy.agents[i].y),myStrategy.agents[i].teamColor)
			}
			strategyFloor.unlock();
		}
	}
}