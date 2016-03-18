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
		public var enemyBarHolder:Sprite = new Sprite();
		public var core:MovieClip;
		public var coreShield;
		public var shieldAid;
		public var barrel;
		public var barrelAngle;
		public var barrelLen = 28;
		private var sizeInc:Number = 1;
		public var nLives:Number = 3;
		//public var gameOver:Boolean = false;
		private var stage;
		
		public var timer=new Date().time;
		public var timerObj:Timer=new Timer(50);
		public var timerCheck = false;
		public var timeMCHolder;
		public var timeMC;
		public var ttlTime;
		
		private var enemy;
		public var enemySpawn:Number = 3.5; //seconds
		public var minEnemySpawn:Number = 2.5; //seconds
		public var enemySpawnDec:Number = 0.2; //seconds
		public var enemySpawnRed:Boolean = true;
		public var enemyProb:Number = 1; //Lower, the more likely to spawn, must be positive integer
		public var armouredChance:Number = 2; //Lower, the more likely to be armoured, must be positive integer
		private var enemyInc:Number = 1; //control size of enemy
		public var enemyAveSpd:Number = 3;
		public var enemySpdRange:Number = 1; //speed = enemyAveSpd+-enemySpdRange
		public var enemyAveMovement:Number = 100; //how far forward the enemy will move
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
				"rad":Math.max(core.height,core.width)/1.5,
				"angleStart":270,
				"size":90, //in degrees
				"width":3,
				"stage":stage
			}
			coreShield = new Shield(args2);
			shieldAid = new ShieldAid(args2);
			barrel = new Barrel();
			barrelAngle = barrel.rotation;
			
			timeMCHolder = new TimeMC();
			timeMCHolder.x = stage.stageWidth/2;
			timeMCHolder.y = stage.stageHeight/2;
			timeMC = timeMCHolder.timeTxt;
			barrel.x = core.x = stage.stageWidth/2;
			barrel.y = core.y = stage.stageHeight/2;
			stage.addChild(core);
			stage.addChild(coreShield);
			stage.addChild(shieldAid);
			stage.addChild(barrel);
			stage.addChild(timeMCHolder);
			
			time(1);
			bTimer.addEventListener(TimerEvent.TIMER, enemyTimer);
			bTimer.start();
			
			//Lives and shield alerts 
			var nitems = 4;
			var pad = 10;
			//var shieldy = new Shieldy();
			var life = new Lives();
			var ammotype = new AmmoType();
			//var shieldLock = new ShieldLock();
			var sidePad = (stage.stageWidth-(nitems-1)*pad-3*life.width-ammotype.width)/2;
			ammotype.x = stage.stageWidth-ammotype.width/2-sidePad; 
			//shieldy.x = ammotype.x-pad-ammotype.width/2-shieldy.width/2;
			//shieldLock.x = shieldy.x-pad-shieldLock.width/2-shieldy.width/2;
			ammotype.y = core.y+Math.max(core.height,core.width)/2+pad*3;
			
			for(var i=0;i<3;i++){
				life = new Lives();
				life.x = sidePad+i*life.width+(i+1)*pad;
				life.y = ammotype.y;
				alertHolder.addChild(life);		
			}
			
			//alertHolder.addChild(shieldLock);
			//alertHolder.addChild(shieldy);
			alertHolder.addChild(ammotype);
			
			stage.addChild(alertHolder);
			
			stage.addChild(bulletHolder);
			stage.addChild(enemyHolder);
			stage.addChild(enemyBulHolder);
			stage.addChild(enemyBarHolder);
		}
		
		//Enemies
		function enemyTimer(e){
			var args = {
				"enemyBulHolder":enemyBulHolder,
				"enemyBarHolder":enemyBarHolder,
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
			stage.removeChild(shieldAid);
			stage.removeChild(barrel);
			stage.removeChild(enemyHolder);
			stage.removeChild(enemyBulHolder);
			stage.removeChild(enemyBarHolder);
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
			
			enemySpawn = Math.max(enemySpawn,minEnemySpawn);
			
			//*
			if(ttlTime%30==0 && enemySpawnRed && ttlTime!=0){
					enemySpawn-=enemySpawnDec;
					bTimer.removeEventListener(TimerEvent.TIMER, enemyTimer);
					bTimer.reset();
					bTimer.delay = enemySpawn*1000;
					bTimer.addEventListener(TimerEvent.TIMER, enemyTimer);
					bTimer.start();
					enemySpawnRed = false;
			}
			else if(ttlTime%30!=0){
				enemySpawnRed = true;
			}
			//*/
			
			trace(bTimer.delay);
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
