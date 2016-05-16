package
{
	import flash.display.Sprite;
	
	[SWF(width="1024",height="768",frameRate="60")]
	public class StrategyGame extends Sprite
	{
		public function StrategyGame()
		{
			super();
			this.graphics.beginFill(0xff00ff);
			this.graphics.drawCircle(0,0,100);
			trace("Hi");
		}
	}
}