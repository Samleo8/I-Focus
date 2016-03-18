package  {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	public class Level {
		public var lvl = 0;
		public var bulletHolder:Sprite = new Sprite();
		public var core:MovieClip;
		public var cursor:MovieClip;
		public var radCur:MovieClip;
		public var cursorAcc:Boolean = true;
		public var cursorSpd:Number = 5; //lower the faster it gets to the mouse
		private var cursorInc:Number = 1.7; //control size of cursor
		//public var gameOver:Boolean = false;
		private var stage;
		
		public var timer=new Date().time;
		public var timerObj:Timer=new Timer(50);
		public var timerCheck = false;
		public var timeMC;
		public var ttlTime;		
		
		private var bul;
		public var bulSpawn:Number = 0.4; //seconds
		public var bulProb:Number = 2; //Higher, less likely to appear
		private var bulletInc:Number = 1.1; //control size of bullet
		public var bTimer = new Timer(bulSpawn*1000);
	
		public function Level(args){
			stage = args["stage"];
			core = new Core();
			cursor = new PlayerCursor();
			cursor.width *= cursorInc;
			cursor.height *= cursorInc;
			radCur = new RadiusCursor();
			radCur.width *= cursorInc;
			radCur.height *= cursorInc;
			
			timeMC = core.timeTxt;
			core.x = stage.stageWidth/2;
			core.y = stage.stageHeight/2;
			stage.addChild(cursor);
			stage.addChild(radCur);
			stage.addChild(core);
			
			time(1);
			bTimer.addEventListener(TimerEvent.TIMER, bulTimer);
			bTimer.start();
			
			stage.addChild(bulletHolder);
		}
		
		//Bullets
		function bulTimer(e){
			var args = {
				"bulletHolder":bulletHolder,
				"stage":stage
			};
			
			if(rand(1,bulProb) == 1){
				var bul = new Bullet(args);
				bul.width *= bulletInc;
				bul.height *= bulletInc;
				bulletHolder.addChild(bul);
				
				var r = rand(1,4);
				if(r == 1){ //top
					bul.x = rand(-5,stage.stageWidth+5);
					bul.y = -5;
				}
				else if(r == 2){ //bottom
					bul.x = rand(-5,stage.stageWidth+5);
					bul.y = stage.stageHeight+5;
				}
				else if(r == 3){
					bul.x = stage.stageWidth+5;
					bul.y = rand(-5,stage.stageHeight+5);
				}
				else{
					bul.x = -5;
					bul.y = rand(-5,stage.stageHeight+5);
				}
				
				bul.spd = rand(2,5);
			}
		}
		
		//Level Clear
		public function clearLevel(){
			stage.removeChild(cursor);
			stage.removeChild(radCur);
			stage.removeChild(core);
			stage.removeChild(bulletHolder);
			
			bTimer.removeEventListener(TimerEvent.TIMER, bulTimer);
			bTimer.stop();
		}
		//Timers
		public function time(e)
		{
			timerObj.reset();
			timerObj.start();
			timerObj.addEventListener(TimerEvent.TIMER, time);
			
			var dTime=(timer-new Date().time)/1000;
			ttlTime = formatTime(Math.abs(Math.round(dTime)));
			timeMC.text=ttlTime;
		}
		
		function formatTime(t)
		{
			var out="";
			var s=Math.round(t*100)/100;
			
			out=s;
			return out;
		}
		
		function rand(lw,hg){
			return Math.floor(Math.random()*(1+hg-lw))+lw;
		}
	}
}
