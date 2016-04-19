package strategy
{
	import flash.geom.Point;

	internal class StepHandler
	{
		
		/**The X and Y of the ground*/
		internal static var w:uint,h:uint,totalPixels:uint;
		
		/**List of blocked tiles*/
		public static var blockedList:Vector.<Boolean> ;
		
		internal static var deltaPoint:Point;
		internal static var distance:Number ;
		
		/**The last item speed from isReachble function*/
		internal static var dx:Number,
							dy:Number ;
							
		private static var finalX:uint,finalY:uint,finalL:uint;
		
		/**The position of blocked tile in the path*/
		internal static var blockexX:int,blockedY:int;
		
		//Second while variables
		/**Controll how much Agent moved*/
		internal static var moved:Number ;
		
		private static var i:int,j:int,k:int;
		
		private static var controlledTiles:Vector.<uint> ;
		
		private static var finalRoat:Vector.<uint> ;
		
		private static var controlRoat:Vector.<uint> ;
		
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
					trace("Get the pose ...");
					if(moved==agentStep)
					{
						startToGetAvailableRoat(fromX-dx,fromY-dy,toX,toY);
						trace("Now I have to move forward : "+finalRoat);
						if(finalRoat.length>0)
						{
							toY = finalRoat[0]%w ;
							toX = finalRoat[0]-w*toY;
							trace("Next step is : "+toX,toY+" from "+fromX,fromY);
							deltaPoint = new Point(toX-fromX,toY-fromY);
							dx = (deltaPoint.x/distance)*agentStep;
							dy = (deltaPoint.y/distance)*agentStep;
							return true 
						}
						dx = dy = 0 ;
					}
					return false ;
				}
			}while(moved<distance);
			return true ;
		}
		
	//////////////////////////Find the available roat 
		
		/**Catch the finded roat from the list finalRoat*/
		private static function startToGetAvailableRoat(fromX:uint,fromY:uint,toX:uint,toY:uint):void
		{
			controlledTiles = new Vector.<uint>();
			controlRoat = new Vector.<uint>();
			finalRoat = new Vector.<uint>();
			trace("Final road resets");
			finalX = toX;
			finalY = toY;
			finalL = pointToLinier(toX,toY);
			controlRoat.push(pointToLinier(fromX,fromY));
			getAvailableRoat();
			finalRoat.reverse();
			trace("Road founds : "+finalRoat);
		}
		
		
		/**Create a path to the destination. the values are the linier values that have to change to the x and y again*/
		internal static function getAvailableRoat():Boolean
		{
			var myLin:uint ;
			
			for( k=0 ; k < controlRoat.length ; i++ )
			{
				if(controlRoat[i]==finalL)
				{
					finalRoat.push(myLin)
					return true ;
				}
				for(i = -1 ; i<2 ; i++)
				{
					for(j = -1;j<2;j++)
					{
						myLin = controlRoat[k]+i+j*w ;
						trace("controlledTiles : "+myLin);
						if(myLin>=0 && myLin<totalPixels && controlledTiles.indexOf(myLin)==-1 && !blockedList[myLin])
						{
							controlledTiles.push(myLin);
							if(myLin==finalL)
							{
								trace("Got it!!")
								finalRoat.push(myLin)
								return true
							}
						}
					}
				}
			}
			
			
			return false ;
		}
		
		
		private static function pointToLinier(x:uint,y:uint):uint
		{
			return y*w+x ;
		}
		
		private static function linierToPoint(l:uint):Point
		{
			var x:uint,y:uint;
			y = l%w ;
			x = l-w*y;
			return new Point(x,y);
		}
		
			/*private static function getAvailableRoatLinier(FromL:uint,ToL:uint):Vector.<uint>
			{
				for(i = 0 ; i<9 ; i++)
				{
					
				}
				return new Vector.<uint>();
			}*/
		
		
	////////////////////////////////////Roat blocker
		
		/**Returns the blucker tile if this tile is not passable*/
		internal static function isPassable(x:uint,y:uint):Boolean
		{
			trace("is passable? : "+x,y);
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