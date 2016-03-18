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
		public var bulletHolder:Sprite = new Sprite();
		public var alertHolder:Sprite = new Sprite();
		public var enemyHolder:Sprite = new Sprite();
		public var enemyBulHolder:Sprite = new Sprite();
		public var core:MovieClip;
		public var coreShield;
		public var barrel;
		public var barrelLen = 28;
		private var sizeInc:Number = 1;
		public var nLives:Number = 3;
		//public var gameOver:Boolean = false;
		private var stage;
		
		public var timer=new Date().time;
		public var timerObj:Timer=new Timer(50);
		public var timerCheck = false;
		public var timeMC;
		public var ttlTime;
		
		private var enemy;
		public var enemySpawn:Number = 2; //seconds
		public var enemyProb:Number = 2; //Lower, the more likely to spawn, must be positive integer
		public var armouredChance:Number = 10; //Lower, the more likely to be armoured, must be positive integer
		private var enemyInc:Number = 1; //control size of enemy
		public var enemyAveSpd:Number = 3;
		public var enemySpdRange:Number = 1; //speed = enemyAveSpd+-enemySpdRange
		public var enemyAveMovement:Number = 80; //how far forward the enemy will move
		public var enemyMovementRange:Number = 40;
		public var enemyAcc:Number = 0;
		//public var enemyMaxNum:Number = 5;
		public var bTimer = new Timer(enemySpawn*1000);
	
		public function Level(args){
			stage = args["stage"];
			core = new Core();
			core.width *= sizeInc;
			core.height *= sizeInc;
			var args2 = {
				"rad":core.width/1.5,
				"angleStart":270,
				"size":90, //in degrees
				"width":3,
				"stage":stage
			}
			coreShield = new Shield(args2);
			barrel = new Barrel();
			
			timeMC = core.timeTxt;
			barrel.x = core.x = stage.stageWidth/2;
			barrel.y = core.y = stage.stageHeight/2;
			stage.addChild(core);
			stage.addChild(coreShield);
			stage.addChild(barrel);
			
			time(1);
			bTimer.addEventListener(TimerEvent.TIMER, enemyTimer);
			bTimer.start();
			
			//Lives and shield alerts 
			var nitems = 5;
			var pad = 10;
			var shieldy = new Shieldy();
			var life = new Lives();
			var ammotype = new AmmoType();
			var sidePad = (stage.stageWidth-(nitems-1)*pad-3*life.width-shieldy.width-ammotype.width)/2;
			ammotype.x = stage.stageWidth-ammotype.width/2-sidePad; 
			shieldy.x = ammotype.x-pad-ammotype.width/2-shieldy.width/2;
			ammotype.y = shieldy.y = core.y+core.height/2+pad*3;
			
			for(var i=0;i<3;i++){
				life = new Lives();
				life.x = sidePad+i*life.width+(i+1)*pad;
				life.y = shieldy.y;
				alertHolder.addChild(life);		
			}
			alertHolder.addChild(shieldy);
			alertHolder.addChild(ammotype);
			
			stage.addChild(alertHolder);
			
			stage.addChild(bulletHolder);
			stage.addChild(enemyHolder);
			stage.addChild(enemyBulHolder);
		}
		
		//Enemies
		function enemyTimer(e){
			var args = {
				"enemyBulHolder":enemyBulHolder,
				"bulletHolder":bulletHolder,
				"core":core,
				"type":1,
				"shield":coreShield,
				"stage":stage
			};
			
			if(rand(1,enemyProb) == 1){
				if(rand(1,armouredChance) == 1) args["type"] = 2; //armoured
				
				var enemy = new Enemy(args);
				enemy.width *= enemyInc;
				enemy.height *= enemyInc;
				enemyHolder.addChild(enemy);
				
				var r = rand(1,4);
				if(r == 1){ //top
					enemy.x = rand(-5,stage.stageWidth+5);
					enemy.y = -5;
				}
				else if(r == 2){ //bottom
					enemy.x = rand(-5,stage.stageWidth+5);
					enemy.y = stage.stageHeight+5;
				}
				else if(r == 3){
					enemy.x = stage.stageWidth+5;
					enemy.y = rand(-5,stage.stageHeight+5);
				}
				else{
					enemy.x = -5;
					enemy.y = rand(-5,stage.stageHeight+5);
				}
				
				enemy.startX = enemy.x;
				enemy.startY = enemy.y;
				
				enemy.spd = rand(enemyAveSpd-enemySpdRange,enemyAveSpd+enemySpdRange);
				enemy.acc = enemyAcc;
				
				enemy.posMove = rand(enemyAveMovement-enemyMovementRange,enemyAveMovement+enemyMovementRange);
			}
		}
		
		//Level Clear
		public function clearLevel(){
			stage.removeChild(core);
			stage.removeChild(coreShield);
			stage.removeChild(barrel);
			stage.removeChild(enemyHolder);
			stage.removeChild(enemyBulHolder);
			stage.removeChild(bulletHolder);
			stage.removeChild(alertHolder);
			
			bTimer.removeEventListener(TimerEvent.TIMER, enemyTimer);
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
