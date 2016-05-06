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
		
		private var startPoint:Point,endPoint:Point;
		
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
			
			
			
			var startMC:MovieClip = Obj.get('s_mc',mapElements);
			var endMC:MovieClip = Obj.get('e_mc',mapElements);
			
			startPoint = new Point(startMC.x,startMC.y);
			endPoint = new Point(endMC.x,endMC.y);
			
			Obj.remove(startMC);
			Obj.remove(endMC);
			
			MainPlayer.setUp(startPoint,endPoint,floorX,floorX);
			
			var aSolder:MainPlayer = new MainPlayer(myStrategy.addAgent(0,0,0xff0000,true,true,0.5,1,1,100,20));
			mapElements.addChild(aSolder);
			
			this.addEventListener(Event.ENTER_FRAME,anim);
			
			players.push(aSolder);
			
			//add fake enemy
			//myStrategy.addAgent(60,0,0x00ff00,true,true,0.5,1,1,100,20);
			
			
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