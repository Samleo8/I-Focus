package  {
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Level {
		public var levelObj:Sprite = new Sprite();
		public var targetObj:Sprite;
		public var levelW:Number;
		public var levelH:Number;
		public var spd:Number = 15;
		public var lvlScale:Number = 1;
		//public var lvlPlayTime:Number = 60; //seconds
		
		public var timer=new Date().time;
		public var timerObj:Timer=new Timer(50);
		private var tm;
		private var tmpadding:Number = 10;
		public var timeMC;
		public var ttlTime:Number;		
		
		private var sc;
		public var scoreMCPass;
		public var scoreMCFail;
		public var ttlScore:Number = 0;
		public var ttlPassScore:Number = 0;
		public var ttlFailScore:Number = 0;
		private var menuClick = false;
		
		private var i,j;
		private var target;
		public var targetPadding:Number = 13;
		public var targetNo:Number = 20; //number of targets for the width
		private var targetHeightNo:Number;
		public var targetWidth:Number;
		public var ttlEnemies:Number = 20; //number of enemies on the stage at every instant
		public var enemyDisappearTime:Number = 15; //seconds before enemy disappears
		public var enemies = new Array();
		
		public var cueObj = new Sprite();
		private var cuesOn;
		public var ttlCues:Number = 3;
		
		private var stage;
		private var bg;
		public function Level(args) {
			stage = args["stage"];
			cuesOn = args["cuesOn"];
			if(!cuesOn) ttlCues = 0;
			
			enemyDisappearTime *= 1000;
			
			//Timers
			tm = new TimeMC();
			timeMC = tm.timeTxt;
			tm.x = stage.stageWidth - tm.width/2 - tmpadding;
			tm.y = stage.stageHeight - tm.height/2 - tmpadding;
			
			time(1);
			
			//Score
			sc = new ScoreMC();
			scoreMCPass = sc.scoreTxtPass;
			scoreMCFail = sc.scoreTxtFail;
			scoreMCPass.text = ttlPassScore;
			scoreMCFail.text = ttlFailScore;
			
			sc.x = stage.stageWidth/2;
			sc.y = sc.height/2;
			
			//Create Level Object
			bg = new LevelBg();
			targetObj = new Sprite();
			targetObj.addChild(new Sprite());
			
			targetObj.width = levelW;
			targetObj.height = levelH;
			
			levelObj.addChild(bg);
			levelObj.addChild(targetObj);
			
			var ratio = bg.width/bg.height;
			//bg.height = stage.stageHeight*lvlScale;
			//bg.width = bg.height*ratio;
			bg.x = 0;
			bg.y = 0;
			
			levelObj.x = stage.stageWidth/2;
			levelObj.y = stage.stageHeight/2;
			levelW = bg.width;
			levelH = bg.height;
			
			levelObj.width = levelW;
			levelObj.height = levelH;
			
			//Create Target Objects
			targetWidth = levelW/targetNo-2*targetPadding;
			targetHeightNo = Math.floor(levelH/(2*targetPadding+targetWidth));
			
			for(i=0;i<targetNo;i++){
				for(j=0;j<targetHeightNo;j++){
					args = {
						"lvlObj":this,
						"enemyDisappearTime":enemyDisappearTime
					}
					target = new Target(args);
					target.width = targetWidth;
					target.height = targetWidth;
					target.x = i*(2*targetPadding+targetWidth)+targetPadding+targetWidth/2-levelW/2;
					target.y = j*(2*targetPadding+targetWidth)+targetPadding+targetWidth/2-levelH/2;
					target.gotoAndStop(1);
					target.rotation = rand(0,360);
					target.addEventListener(MouseEvent.MOUSE_UP,checkTarget);
					targetObj.addChild(target);
				}
			}
			
			for(i=0;i<ttlEnemies;i++){
				newEnemy();
			}
			trace(ttlEnemies+" enemies created!");
			
			targetObj.x = 0;
			targetObj.y = 0;
			
			for(i=0;i<ttlCues;i++){
				var cue = new CueMC();
				cueObj.addChild(cue);
			}
			
			//Adding to stage
			stage.addChild(levelObj);
			stage.addChild(tm);
			stage.addChild(sc);
			stage.addChild(cueObj);
			
			trace("Level fully initialised.");
		}
		
		public function panLvl(dir){
			switch(dir){
				case "right":
					levelObj.x -= spd;
					break;
				case "left":
					levelObj.x += spd;
					break;
				case "up":
					levelObj.y += spd;
					break;
				case "down":
					levelObj.y -= spd;
					break;
				default:
					break;
			}
			
			levelObj.x = Math.max(Math.min(levelObj.x,levelObj.width/2+stage.stageWidth/2),stage.stageWidth/2-levelObj.width/2);
			levelObj.y = Math.max(Math.min(levelObj.y,levelObj.height/2+stage.stageHeight/2),stage.stageHeight/2-levelObj.height/2);
		}
		//Target Check
		function checkTarget(e){
			if(sc.hitTestPoint(stage.mouseX,stage.mouseY,true)) return;
			
			if(e.target.currentFrame == e.target.totalFrames){
				trace("Target Found!");
				ttlPassScore++;
				newEnemy();
				e.target.gotoAndStop(1);
				e.target.clearTimer();
				enemies.splice(enemies.indexOf(e.target), 1);
				trace("New Enemy Created.");
				//trace(enemies);
			}
			else ttlFailScore++;
			
			scoreMCPass.text = ttlPassScore;
			scoreMCFail.text = ttlFailScore;
		}
		
		public function newEnemy(){
			var r = rand(1,targetNo*targetHeightNo)-1;
			var enemy = targetObj.getChildAt(r);
			if(enemy.currentFrame != enemy.totalFrames){
				enemy.gotoAndStop(enemy.totalFrames);
				enemies.push(enemy);
				enemy.startTimer();
			}
			else newEnemy();
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
				
		//Other Functions
		public function clearLevel(){
			for(i=0;i<enemies.length;i++){
				enemies[i].clearTimer();
			}
			stage.removeChild(levelObj);
			stage.removeChild(cueObj);
			stage.removeChild(tm);
			stage.removeChild(sc);
		}
		
		function rand(lw,hg){
			return Math.floor(Math.random()*(1+hg-lw))+lw;
		}
	}
}
