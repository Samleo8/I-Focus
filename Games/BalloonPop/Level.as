package  {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Level {
		public var lvl = 0;
		public var cursor:MovieClip;
		public var balHolder:Sprite = new Sprite();
		public var popHolder:Sprite = new Sprite();
		private var stage;
				
		public var timer=new Date().time;
		public var timerObj:Timer=new Timer(50);
		public var timerCheck = false;
		public var timeMC;
		public var ttlTime;		
		
		private var bal;
		public var balSpawn:Number = 0.5; //seconds
		public var balProb:Number = 2; //Lower, the more likely to spawn
		public var balSpd:Number = 20;
		public var balAcc:Number = 1;
		public var balMaxNum:Number = 1;
		private var balloonInc:Number = 1.1; //control size of balloon
		public var bTimer = new Timer(balSpawn*1000);
		
		public function Level(args) {
			stage = args["stage"];
			cursor = new Crosshair();			
			
			var timeMCz = new timerMC();
			timeMCz.x = 740;
			timeMCz.y = 575;
			stage.addChild(timeMCz);
			timeMC = timeMCz.timeTxt;
			time(1);
			
			bTimer.addEventListener(TimerEvent.TIMER, balTimer);
			bTimer.start();
			
			stage.addChild(balHolder);
			stage.addChild(popHolder);
			stage.addChild(cursor);
		}

		private function balTimer(e){
			var args = {
				"balHolder":balHolder,
				"popHolder":popHolder,
				"cursor":cursor,
				"stage":stage
			};
			
			if(rand(1,balProb) == 1){
				for(var i=0;i<rand(1,balProb);i++){
					var bal = new Balloon(args);
					bal.width *= balloonInc; 
					bal.height *= balloonInc;
					balHolder.addChild(bal);
	
					bal.x = rand(bal.width/2,stage.stageWidth-bal.width/2);
					bal.y = stage.stageHeight+bal.height;
					
					bal.spd = rand(4,8);
					bal.gotoAndStop(rand(1,bal.totalFrames));
				}
			}
		}

		public function clearLevel(){
			
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
