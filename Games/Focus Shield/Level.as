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
		public var coreShield;
		private var sizeInc:Number = 1;
		//public var gameOver:Boolean = false;
		private var stage;
		
		public var timer=new Date().time;
		public var timerObj:Timer=new Timer(50);
		public var timerCheck = false;
		public var timeMC;
		public var ttlTime;		
		
		private var bul;
		public var bulSpawn:Number = 0.25; //seconds
		public var bulProb:Number = 2; //Lower, the more likely to spawn
		private var bulletInc:Number = 1; //control size of bullet
		public var bulSpd:Number = 20;
		public var bulAcc:Number = 1;
		public var bulMaxNum:Number = 1;
		public var bTimer = new Timer(bulSpawn*1000);
	
		public function Level(args){
			stage = args["stage"];
			core = new Core();
			core.width *= sizeInc;
			core.height *= sizeInc;
			var args2 = {
				"rad":core.width/1.5,
				"angleStart":270,
				"size":22,
				"width":5
			}
			coreShield = new Shield(args2);
			
			timeMC = core.timeTxt;
			coreShield.x = core.x = stage.stageWidth/2;
			coreShield.y = core.y = stage.stageHeight/2;
			stage.addChild(core);
			stage.addChild(coreShield);
			
			time(1);
			bTimer.addEventListener(TimerEvent.TIMER, bulTimer);
			bTimer.start();
			
			stage.addChild(bulletHolder);
		}
		
		//Bullets
		function bulTimer(e){
			var args = {
				"bulletHolder":bulletHolder,
				"core":core,
				"shield":coreShield,
				"stage":stage
			};
			
			if(bulletHolder.numChildren < bulMaxNum && rand(1,bulProb) == 1){
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
				
				bul.spd = bulSpd;
				bul.acc = bulAcc;
			}
		}
		
		//Level Clear
		public function clearLevel(){
			stage.removeChild(core);
			stage.removeChild(coreShield);
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
