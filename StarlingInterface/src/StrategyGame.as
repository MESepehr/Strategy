package
{
	import flash.display.Sprite;
	
	import starling.core.Starling;
	
	import stategyStarling.Game;
	
	[SWF(width="1024",height="768",frameRate="60",backgroundColor="#000000")]
	public class StrategyGame extends Sprite
	{
		private var _starling:Starling ;
		
		public function StrategyGame()
		{
			super();
			/*this.graphics.beginFill(0xff00ff);
			this.graphics.drawCircle(0,0,100);*/
			trace("Hi");
			
			_starling = new Starling(Game,stage);
			_starling.start();
		}
	}
}