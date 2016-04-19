package strategy
{
	import flash.geom.Point;

	internal class StepHandler
	{
		
		/**The X and Y of the ground*/
		internal static var w:uint,h:uint;
		
		/**List of blocked tiles*/
		public static var blockedList:Vector.<Boolean> ;
		
		internal static var deltaPoint:Point;
		internal static var distance:Number ;
		
		/**The last item speed from isReachble function*/
		internal static var dx:Number,
							dy:Number ;
		
		/**The position of blocked tile in the path*/
		internal static var blockexX:int,blockedY:int;
		
		//Second while variables
		/**Controll how much Agent moved*/
		internal static var moved:Number ;
		
		internal static function isReachable(fromX:uint,fromY:uint,toX:uint,toY:uint,agentStep:Number):Boolean
		{
			deltaPoint = new Point(toX-fromX,toY-fromY);
			distance = deltaPoint.length;
			dx = (deltaPoint.x/distance)*agentStep;
			dy = (deltaPoint.y/distance)*agentStep;
			
			moved = 0;
			do{
				moved += agentStep ;
				fromX += dx ;
				fromY += dy ;
				if(!isPassable(fromX,fromY))
				{
					dx = 0 ;
					dy = 0 ;
					return false ;
				}
			}while(moved<distance);
			return true ;
		}
		
		
	////////////////////////////////////Roat blocker
		
		/**Returns the blucker tile if this tile is not passable*/
		internal static function isPassable(x:uint,y:uint):Boolean
		{
			return !blockedList[y*w+x];
		}
		
		internal static function makeItNotPassable(x:uint,y:uint):void
		{
			blockedList[y*w+x] = true ;
		}
		
		internal static function makeIfPassable(x:uint,y:uint):void
		{
			blockedList[y*w+x] = false ;
		}
	}
}