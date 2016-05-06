package gamePlay.ui.mainMap
	//gamePlay.ui.mainMap.MainMap
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import gamePlay.ui.players.MainPlayer;
	
	import strategy.StrategyFloor;
	
	public class MainMap extends MovieClip
	{
		private var mapMC:MovieClip ;
		
		private var mapElements:MovieClip; 
		
		private var perespectiveRotation:Number = 45 ;

		private var houses:Array;
		
		private var myStrategy:StrategyFloor ;
		
		private var leftPoint:Point,rightPoint:Point,upPoint:Point,downPoint:Point;
		
		private var floorX:uint = 60;
		
		private var players:Vector.<MainPlayer> ;
		
		public function MainMap()
		{
			super();
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			mapMC = Obj.get("map_mc",this);
			players = new Vector.<MainPlayer>();
			
			houses = Obj.getAllChilds("knight_mc",this);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,startDraging);
			mapElements = Obj.get("elem_mc",this);
			ZSorter.autoSort(mapElements);
			this.addEventListener(TransformGestureEvent.GESTURE_ZOOM,zoomInZoomOut);
			
			myStrategy = new StrategyFloor(floorX,floorX);
			myStrategy.addBuilding(30,10,10,10,0);
			myStrategy.addBuilding(30,20,10,10,0);
			myStrategy.addBuilding(40,40,10,10,0);
			myStrategy.addBuilding(20,40,10,10,0);
			
			
			
			
			var leftMC:MovieClip = Obj.get('l_mc',mapElements);
			var rightMC:MovieClip = Obj.get('r_mc',mapElements);
			var upMC:MovieClip = Obj.get('u_mc',mapElements);
			var downMC:MovieClip = Obj.get('d_mc',mapElements);
			
			leftPoint = new Point(leftMC.x,leftMC.y);
			rightPoint = new Point(rightMC.x,rightMC.y);
			upPoint = new Point(upMC.x,upMC.y);
			downPoint = new Point(downMC.x,downMC.y);
			
			Obj.remove(leftMC);
			Obj.remove(rightMC);
			Obj.remove(upMC);
			Obj.remove(downMC);
			
			MainPlayer.setUp(leftPoint,rightPoint,upPoint,downPoint,floorX,floorX);
			
			var aSolder:MainPlayer = new MainPlayer(myStrategy.addAgent(0,0,0xff0000,true,true,0.5,1,1,100,20));
			mapElements.addChild(aSolder);
			
			this.addEventListener(Event.ENTER_FRAME,anim);
			
			players.push(aSolder);
			
			//add fake enemy
			myStrategy.addAgent(60,0,0x00ff00,true,true,0.5,1,1,100,20);
			
			
			setRotation(perespectiveRotation);
		}
		
		protected function anim(event:Event):void
		{
			myStrategy.step();
		}
		
		private function setRotation(deg:Number):void
		{
			for(var i = 0 ; i<houses.length ; i++)
			{
				(houses[i] as MovieClip).rotationX = deg ;
			}
			
			this.rotationX = -deg ;
			for(i = 0 ; i<players.length ; i++)
			{
				players[i].rotationX = deg ;
			}
		}
		
		protected function zoomInZoomOut(event:TransformGestureEvent):void
		{
			this.scaleX *= event.scaleX*event.scaleY ;
			this.scaleZ = this.scaleY = this.scaleX = Math.min(1,Math.max(this.scaleX,5));
			//setRotation(perespectiveRotation*this.scaleX);
		}		
		
		protected function startDraging(event:MouseEvent):void
		{
			this.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP,stopDragging);
		}
		
		protected function stopDragging(event:MouseEvent):void
		{
			this.stopDrag();
		}
		
	}
}