package  {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Level {
		public var lvl = 0;
		private var stage;
		
		public var timer=new Date().time;
		public var timerObj:Timer=new Timer(50);
		private var tm;
		private var tmpadding:Number = 1;
		public var timeMC;
		public var ttlTime:Number;		
		private var ttlGameTime:Number = 0;
		
		private var sc;
		public var scoreMC;
		public var ttlscore:Number = 0;
		var txtFormat:TextFormat = new TextFormat();
		
		private var dot;
		public var dotHolder:Sprite = new Sprite();
		public var dotSpawn:Number = 0.25; //seconds
		private var dotInc:Number = 1; //control size of bullet
		public var dotMaxNum:Number = 1;
		private var dotCoordinates;
		public var dTimer = new Timer(dotSpawn*1000);
	
		public function Level(args){
			stage = args["stage"];
			
			tm = new TimeMC();
			timeMC = tm.timeTxt;
			tm.x = stage.stageWidth - tm.width/2 - tmpadding;
			tm.y = stage.stageHeight - tm.height/2 - tmpadding;
			stage.addChild(tm);
			
			sc = new TimeMC();
			scoreMC = sc.timeTxt;
			scoreMC.text = ttlscore;
			txtFormat.align = TextFormatAlign.LEFT;
			scoreMC.setTextFormat(txtFormat);
			
			sc.x = sc.width/2 + tmpadding;
			sc.y = stage.stageHeight - sc.height/2 - tmpadding;
			
			stage.addChild(sc);
			
			time(1);
			
			for(var i=0;i<dotMaxNum;i++){
				var args2 = {
					"stage":stage,
					"dotHolder":dotHolder,
					"ttlScore":ttlscore,
					"scoreMC":scoreMC
				}
				dot = new Dot(args2);
				dotHolder.addChild(dot.mc);
			}
			stage.addChild(dotHolder);
		}
		
		//Level Clear
		public function clearLevel(){
			stage.removeChild(dotHolder);
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
