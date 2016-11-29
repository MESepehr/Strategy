package strategy
{
	import flash.geom.Point;
	import flash.utils.getTimer;

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
							
		private static var finalX:Number,finalY:Number,finalL:uint,firstX:Number,firstY:Number;
		
		/**The position of blocked tile in the path*/
		internal static var blockedX:Number,blockedY:Number;
		
		//Second while variables
		/**Controll how much Agent moved*/
		internal static var moved:Number ;
		
		private static var i:int,j:int,k:int;
		
		private static var controlledTiles:Vector.<uint> ;
		
		private static var finalRoat:Vector.<Point> ;
		
		private static var controlRoat:Vector.<Vector.<Point>> ;
		
		private static var passControllLin:uint; 
		
		/**This is the agent hit range*/
		private static var agentRange:Number ;
		private static var currentP:Point;
		
		/**This will change the dx and*/
		internal static function guideMe(fromX:Number,fromY:Number,toX:Number,toY:Number,agentStep:Number,theAgentHitRage:Number):void
		{
			var stetTimer:uint = getTimer();
			//trace("Start walking from : "+fromY,fromX);
			if(!isReachable(fromX,fromY,toX,toY,agentStep,theAgentHitRage))
			{
				//trace("*** Reset stepssssssssssssssss : "+blockedY,blockedX);
				startToGetAvailableRoat(blockedX,blockedY,toX,toY);
				//trace("Ifound this road : "+finalRoat+'  -  who is reachable from : '+fromY,fromX);
				var roadLength:uint = finalRoat.length ;
				var selectedStep:uint = 0 ;
				//trace("roadLength : "+roadLength+' vs selectedStep : '+selectedStep);
				while(roadLength>selectedStep && isReachable(fromX,fromY,0,0,agentStep,theAgentHitRage,finalRoat[selectedStep]))
				{
					//trace(finalRoat[selectedStep]+" is reachable");
					selectedStep++;
				}
				selectedStep--;
				while(true)
				{
					if(roadLength<=selectedStep)
					{
						dx = dy = 0 ;
						//trace("No way");
						return ;
					}
					//trace("The blockec point is : "+fromX,fromY+'  Last pint was : '+(fromX-dx),(fromY-dy));
					//trace("Now I have to move forward : "+finalRoat);
					//trace("finalRoat.length : "+JSON.stringify(finalRoat)+' -> '+selectedStep+' vs '+finalRoat.length);
					//trace("finalRoat[0] : "+JSON.stringify(finalRoat));
					toX = finalRoat[selectedStep].x;
					toY = finalRoat[selectedStep].y;
					//trace("Next step is : "+toY,toX+" from "+fromY,fromX);
					
					deltaPoint = new Point(toX-fromX,toY-fromY);
					distance = deltaPoint.length;
					if(distance!=0)
					{
						dx = (deltaPoint.x/distance)*agentStep;
						dy = (deltaPoint.y/distance)*agentStep;
					}
					else
					{
						//throw "** finalRoat : "+finalRoat+' step '+linierToPoint(finalRoat[selectedStep])+" Is not diffrent from "+firstY+','+firstX;
						selectedStep++;
						continue;
					}
					//trace("deltaPoint : "+deltaPoint);
					//trace("distance : "+distance);
					//trace("It takes : "+(getTimer()-stetTimer));
					//trace("Dx,Dy : "+dx,dy);
					break;
				}
				return ;
			}
			else
			{
				//trace("It takes : "+(getTimer()-stetTimer));
				//trace("The dx and dy are leading to the direct path");
			}
		}
		
		private static function isReachable(fromX:Number,fromY:Number,toX:Number,toY:Number,agentStep:Number,agentHitRange:Number,toPoint:Point=null,fromPoint:Point=null):Boolean
		{
			var tileCheckerRange:Number = agentStep ;
			if(toPoint)
			{
				toX = toPoint.x;
				toY = toPoint.y;
			}
			if(fromPoint)
			{
				fromX = fromPoint.x;
				fromY = fromPoint.y; 
			}
			blockedX = blockedY = -1 ;
			//trace("fromX : "+fromX);
			//trace("fromY : "+fromY);
			//trace("toY : "+toY);
			//trace("toX : "+toX);
			firstX = fromX;
			firstY = fromY;
			deltaPoint = new Point(toX-fromX,toY-fromY);
			distance = Math.max(1,deltaPoint.length);
			if(distance==0)
			{
				dx = dy = 0 ;
				//trace("** "+toY,toX+' is reachable from '+firstY,firstX);
				return true ;
			}
			dx = (deltaPoint.x/distance)*tileCheckerRange ;
			dy = (deltaPoint.y/distance)*tileCheckerRange ;
			//trace("To going "+toY,toX+" from "+fromY,fromX+" and the delta is "+deltaPoint+" > "+(toX-fromX),(toY-fromY)+" you have to go this direction : "+dy,dx);
			
			moved = 0;
			do{
				moved += tileCheckerRange ;
				fromX += dx ;
				fromY += dy ;
				if(!isPassable(fromX,fromY))
				{
					blockedX = (fromX-dx);
					blockedY = (fromY-dy);
					//trace("** ** "+toY,toX+' is NOT NOT NOT NOT NOT NOT reachable from '+firstY,firstX);
					return false ;
				}
			}while(moved<distance-agentHitRange);
			//trace("The direction changed : ",dx,dy);
			//trace("It takes : "+(getTimer()-stetTimer));
			//trace("** "+toY,toX+' is reachable from '+firstY,firstX);
			return true ;
		}
		
	//////////////////////////Find the available roat 
		
		/**Catch the finded roat from the list finalRoat*/
		private static function startToGetAvailableRoat(fromX:Number,fromY:Number,toX:Number,toY:Number):void
		{
			controlledTiles = new Vector.<uint>();
			finalRoat = new Vector.<Point>();
			//trace("Final road resets to get it from ",fromX,fromY+' - '+toX,toY);
			finalX = toX;
			finalY = toY;
			finalL = pointToLinier(toX,toY);
			controlRoat = new Vector.<Vector.<Point>>();
			controlRoat.push(new Vector.<Point>());
			//trace("Create road from : "+fromY+' '+fromX+' > '+pointToLinier(fromX,fromY)+' to : '+toY,toX);
			controlledTiles.push(pointToLinier(fromX,fromY));
			controlRoat[0].push(new Point(fromX,fromY));
			//trace("Start to control from : "+controlRoat[0]+" >> "+fromY,fromX);
			getAvailableRoat();
			finalRoat.reverse();
			//trace("Road founds : "+finalRoat);
		}
		
		
		/**Create a path to the destination. the values are the linier values that have to change to the x and y again*/
		internal static function getAvailableRoat():Boolean
		{
			var myLin:int ;
			var currentL:int ;

			var controllX:Number,controllY:Number;
			
			var controllFirstTile:Boolean = false ;

			var iFoundedMyWay:Boolean = false ;
			
			while(controlRoat.length>0)
			{
				//trace("Its time to : "+controlRoat[0]+' from '+controlRoat.length);
				//trace("current roat : "+JSON.stringify(controlRoat,null,' '));
				if(controllFirstTile && (pointToLinier(controlRoat[0][0].x,controlRoat[0][0].y)==finalL || isReachable(0,0,0,0,0.5,1,new Point(finalX,finalY),controlRoat[0][0])))
				{
					finalRoat = controlRoat[0].concat();
					//throw "Final road is "+finalRoat+'  vs  '+finalL+'  >>>  '+controlRoat[0][0]+'    >>>>>    '+controlRoat[0];
					controlRoat = null ;
					return true ;
				}
				controllFirstTile = true ;
				//else
				currentP = controlRoat[0][0] ;
				currentL = pointToLinier(currentP.x,currentP.y) ;
				for(i = -1 ; i<2 ; i++)
				{
					for(j = -1 ; j<2 ; j++)
					{
						if(i!=0 || j!=0)
						{
							myLin = currentL+i+j*w ;
							controllX = currentP.x+i;
							controllY = currentP.y+j;
						//	trace("controlRoat[0][0] : "+controlRoat[0][0]+' , '+myLin);
						//	trace("controlledTiles : "+myLin);
							if((controllX>=0 && controllX<w && controllY>=0 && controllY<h) && controlledTiles.indexOf(myLin)==-1 && !blockedList[myLin])
							{
								controlledTiles.push(myLin);
								//var pose1:Point = linierToPoint(myLin);
								//var pose2:Point = linierToPoint(currentL);
								
								controlRoat.push(controlRoat[0].concat());
								controlRoat[controlRoat.length-1].unshift(new Point(controllX,controllY));
							//	trace(">>> controlRoat[controlRoat.length-1] : "+controlRoat[controlRoat.length-1]);
								
								if(myLin == finalL)//I should controll the accesible points here to. it makes performance better
								{
									controlRoat.reverse();
									controlRoat.unshift(null);
									i=j=100;
									iFoundedMyWay = true ;
								}
								/*if(isReachable(0,0,0,0,1,linierToPoint(finalL),linierToPoint(myLin)))
								{
									controlRoat.reverse();
									controlRoat.unshift(null);
									i=j=100;
								}*/
								
								
								/*Debug codes
								if(Math.abs(pose1.x-pose2.x)>2 || Math.abs(pose1.y-pose2.y)>2)
								{
									throw "What is wrong??"+(pose1.toString())+' ... '+(pose2.toString())+' from '+myLin+' ... '+currentL+' i : '+i+' > uint('+(currentL+i)/w+') : '+uint((currentL+i)/w)+' uint('+(currentL)/w+'):'+uint((currentL)/w);
								}*/
							}
						}
					}
				}
				controlRoat.shift();
				if(iFoundedMyWay)
				{
					finalRoat = controlRoat[0].concat();
					break;
				}
			}
				
			
			return iFoundedMyWay ;
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
			//trace(" changed l to point : ",l+' , '+x,y);
			return new Point(x+.5,y+.5);
		}
		
		
		
	////////////////////////////////////Roat blocker
		
		/**Returns the blucker tile if this tile is not passable*/
		internal static function isPassable(x:uint,y:uint):Boolean
		{
			//trace("is passable? : "+x,y);
			passControllLin = y*w+x ;
			//trace("Controll passable : "+y,x+" = "+passControllLin);
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