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
		
		private static var controlRoat:Vector.<Vector.<uint>> ;
		
		private static var passControllLin:uint; 
		
		internal static function isReachable(fromX:Number,fromY:Number,toX:Number,toY:Number,agentStep:Number):Boolean
		{
			trace("fromX : "+fromX);
			trace("fromY : "+fromY);
			trace("toY : "+toY);
			trace("toX : "+toX);
			deltaPoint = new Point(toX-fromX,toY-fromY);
			distance = deltaPoint.length;
			if(distance==0)
			{
				dx = dy = 0 ;
				return false ;
			}
			dx = (deltaPoint.x/distance)*agentStep ;
			dy = (deltaPoint.y/distance)*agentStep ;
			
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
						trace("The blockec point is : "+fromX,fromY+'  Last pint was : '+(fromX-dx),(fromY-dy));
						startToGetAvailableRoat(fromX-dx,fromY-dy,toX,toY);
						trace("Now I have to move forward : "+finalRoat);
						if(finalRoat.length>0)
						{
							trace("finalRoat[0] : "+finalRoat[0]);
							toX = finalRoat[0]%w ;
							toY = (finalRoat[0]-toX)/w;
							trace("Next step is : "+toX,toY+" from "+fromX,fromY);
							deltaPoint = new Point(toX-fromX,toY-fromY);
							dx = (deltaPoint.x/distance)*agentStep;
							dy = (deltaPoint.y/distance)*agentStep;
							return true 
						}
						trace("c♠B♠♠ blockec");
						dx = dy = 0 ;
					}
					return false ;
				}
			}while(moved<distance);
			trace("The direction changed : ",dx,dy);
			return true ;
		}
		
	//////////////////////////Find the available roat 
		
		/**Catch the finded roat from the list finalRoat*/
		private static function startToGetAvailableRoat(fromX:uint,fromY:uint,toX:uint,toY:uint):void
		{
			controlledTiles = new Vector.<uint>();
			finalRoat = new Vector.<uint>();
			trace("Final road resets to get it from ",fromX,fromY+' - '+toX,toY);
			finalX = toX;
			finalY = toY;
			finalL = pointToLinier(toX,toY);
			controlRoat = new Vector.<Vector.<uint>>();
			controlRoat.push(new Vector.<uint>());
			controlledTiles.push(pointToLinier(fromX,fromY));
			controlRoat[0].push(controlledTiles[0]);
			trace("Start to control from : "+controlRoat[0]+" >> "+fromY,fromX);
			getAvailableRoat();
			finalRoat.reverse();
			trace("Road founds : "+finalRoat);
		}
		
		
		/**Create a path to the destination. the values are the linier values that have to change to the x and y again*/
		internal static function getAvailableRoat():Boolean
		{
			var myLin:int ;
			var roatIsOver:Boolean ;
			var currentL:int ;
			
			while(controlRoat.length>0)
			{
				trace("Its time to : "+controlRoat[0]+' from '+controlRoat.length);
				//trace("current roat : "+JSON.stringify(controlRoat,null,' '));
				if(controlRoat[0][0]==finalL)
				{
					finalRoat = controlRoat[0].concat();
					throw "Final road is "+finalRoat+'  vs  '+finalL+'  >>>  '+controlRoat[0][0]+'    >>>>>    '+controlRoat[0];
					controlRoat = null ;
					return true ;
				}
				//else
				roatIsOver = true ;
				currentL = controlRoat[0][0] ;
				for(i = -1 ; i<2 ; i++)
				{
					for(j = -1 ; j<2 ; j++)
					{
						if(i!=0 || j!=0)
						{
							myLin = currentL+i+j*w ;
							trace("controlRoat[0][0] : "+controlRoat[0][0]+' , '+myLin);
						//	trace("controlledTiles : "+myLin);
							if(uint((currentL+i)/w) && uint((currentL)/w) && myLin>=0 && myLin<totalPixels && controlledTiles.indexOf(myLin)==-1 && !blockedList[myLin])
							{
								//controlledTiles.push(myLin);
								var pose1:Point = linierToPoint(myLin);
								var pose2:Point = linierToPoint(currentL);
								
								controlRoat.push(controlRoat[0].concat());
								controlRoat[controlRoat.length-1].unshift(myLin);
								trace(">>> controlRoat[controlRoat.length-1] : "+controlRoat[controlRoat.length-1]);
								//roatIsOver = false ;
								
								if(Math.abs(pose1.x-pose2.x)>2 || Math.abs(pose1.y-pose2.y)>2)
								{
									throw "What is wrong??"+(pose1.toString())+' ... '+(pose2.toString())+ ' from '+myLin+' ... '+currentL;
								}
							}
						}
					}
				}
				if(roatIsOver)
				{
					controlRoat.shift();
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
			x = l%w ;
			y = (l-x)/w;
			trace(" changed l to point : ",l+' , '+x,y);
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
			passControllLin = y*w+x ;
			if(passControllLin<0 || passControllLin>=totalPixels)
			{
				return false ;
			}
			return !blockedList[passControllLin];
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