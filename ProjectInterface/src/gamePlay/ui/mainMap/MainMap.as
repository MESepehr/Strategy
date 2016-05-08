package gamePlay.ui.mainMap
	//gamePlay.ui.mainMap.MainMap
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.system.System;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import gamePlay.ui.players.MainPlayer;
	
	import strategy.AgentBase;
	import strategy.AgentCall;
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
		
		private var clickCatcher:MovieClip,
					clickCathcerBackMC:MovieClip;
		
		public function MainMap()
		{
			super();
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			
			mapMC = Obj.get("map_mc",this);
			players = new Vector.<MainPlayer>();
			
			houses = Obj.getAllChilds("knight_mc",this);
			mapElements = Obj.get("elem_mc",this);
			clickCatcher = Obj.get("click_catcher_mc",this);
			clickCatcher.visible = false ;
			clickCathcerBackMC = Obj.get("back_mc",clickCatcher);
			
			myStrategy = new StrategyFloor(floorX,floorX);
			myStrategy.addBuilding(30,10,10,10,0xffffff);
			myStrategy.addBuilding(30,20,10,10,0xffffff);
			myStrategy.addBuilding(40,40,10,10,0xffffff);
			myStrategy.addBuilding(20,40,10,10,0xffffff);
			
			
			stage.addChild(myStrategy.debugBitmap());
			
			
			
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
			var player:AgentBase = myStrategy.addAgent(0,0,0xff0000,true,true,0.2,0.3,5,Infinity,Infinity)
				//instead of
			var aSolder:MainPlayer = new MainPlayer(player);
			mapElements.addChild(aSolder);
			
			this.addEventListener(Event.ENTER_FRAME,anim);
			
			players.push(aSolder);
			
			//add fake enemy
			//myStrategy.addAgent(60,60,0x00ff00,true,false,0,1,0,100,20);
			//myStrategy.addAgent(60,60,0xffff00,true,false,1,2,1,200,30)
			
			
			setRotation(perespectiveRotation);
			ZSorter.autoSort(mapElements);
			
			this.addEventListener(MouseEvent.CLICK,addEnemy);
			this.addEventListener(AgentCall.FORGET_MY_BODY,removeHimFromStage);
			this.addEventListener(TransformGestureEvent.GESTURE_ZOOM,zoomInZoomOut);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,startDraging);
			
		}
		
		protected function removeHimFromStage(event:Event):void
		{
			var playerIndex:int = players.indexOf(event.target as MainPlayer);
			if(playerIndex!=-1)
			{
				Obj.remove(players.splice(playerIndex,1)[0]);
				System.gc();
			}
		}
		
		protected function addEnemy(event:MouseEvent):void
		{
			if(clickCathcerBackMC.hitTestPoint(stage.mouseX,stage.mouseY,true))
			{
				var clickCathcerX:Number = Math.min(Math.max(0,Math.min(floorX,clickCathcerBackMC.mouseX/clickCathcerBackMC.width*floorX))) ;
				var clickCathcerY:Number = Math.min(Math.max(0,Math.min(floorX,clickCathcerBackMC.mouseY/clickCathcerBackMC.height*floorX))) ;
				trace("clickCathcerX : "+clickCathcerX);
				trace("clickCathcerY : "+clickCathcerY);
				var player:AgentBase = myStrategy.addAgent(clickCathcerX,clickCathcerY,0x00ff00,true,true,0.1,0.1,5,50,10);
				if(player)
				{
					var aSolder:MainPlayer = new MainPlayer(player);
					mapElements.addChild(aSolder);
					players.push(aSolder);
					setRotation(perespectiveRotation);
				}
			}
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
			trace("Hi");
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