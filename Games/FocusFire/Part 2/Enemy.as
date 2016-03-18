package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	public class Enemy extends MovieClip {
		//private var stage;
		public var spd:Number;
		public var acc:Number;
		public var type:Number = 1;
		public var posSet:Boolean = false;
		public var posMove:Number; //set how far the guy moves
		
		public var reloadTime:Number = 2500; //milliseconds
		public var laseTime:Number = reloadTime - 1000; //1000ms warning
		public var reloadTimer, reloadTimer2;
		private var firstShot:Boolean = true;
		public var bulSpd:Number = 30;
		
		private var args2;
		private var core;
		private var shield;
		private var bulletHolder;
		private var enemyBulHolder;
		private var enemyBarHolder;
		
		public var startX,startY;
		
		public function Enemy(args){
			//stage = args["stage"];
			core = args["core"];
			shield = args["shield"];
			type = args["type"];
			bulletHolder = args["bulletHolder"];
			enemyBulHolder = args["enemyBulHolder"];
			enemyBarHolder = args["enemyBarHolder"];
			args2 = args;
			this.gotoAndStop(type);
			
			reloadTimer = reloadTimer2 = new Date().time;
		}
		
		public function setUpPos(){
			/* RETURNS
			 * 0: No hit
			 * 1: Hit (die)
			 * 2: Hit (wrong)
			 */

			if(distMoved()<posMove){
				return moves(); 
			}
			
			var t = new Date().time;
			//Lasing
			if(t-reloadTimer2>=laseTime){
				reloadTimer2 = t; // Laser stays until firing or destroyed (in their respective fn)
				var enemyBar = new EnemyBarrel();
				var dx = shield.x - this.x;
				var dy = shield.y - this.y;
				var angle = Math.atan2(dy, dx)*(180/Math.PI)+90;
				var distance = Math.sqrt(dx * dx + dy * dy)-85;
				
				enemyBar.x = this.x;
				enemyBar.y = this.y;
				enemyBar.height = distance;
				enemyBar.rotation = angle;
				enemyBarHolder.addChild(enemyBar);
			}
			//Firing
			if(t-reloadTimer>=reloadTime){
				reloadTimer = reloadTimer2 = new Date().time;
				var enemyBul = new EnemyBullet(args2);
				enemyBul.x = this.x;
				enemyBul.y = this.y;
				enemyBul.spd = bulSpd;
				enemyBul.acc = 0;
				if(enemyBarHolder.numChildren) enemyBarHolder.removeChildAt(0);
				enemyBulHolder.addChild(enemyBul);
			}
			
			//Hit Check
			for(var j=0;j<bulletHolder.numChildren;j++){
				var bul = bulletHolder.getChildAt(j);
				if(accHitTest(bul)){
					bul.removeBul();
					if(enemyBarHolder.numChildren) enemyBarHolder.removeChildAt(0);
					
					if(bul.type==this.type) return 1;
					return 2;
				}
			}
			
			return 0;
		}
		
		private function moves(){			
			var dx = core.x - x;
			var dy = core.y - y;
			var angle = Math.atan2(dy, dx);
			this.rotation = angle/(Math.PI/180);
			//var distance = Math.sqrt(dx * dx + dy * dy);
			for(var i=0;i<spd;i++){
				x += Math.cos(angle);
				y += Math.sin(angle);
				for(var j=0;j<bulletHolder.numChildren;j++){
					var bul = bulletHolder.getChildAt(j);
					if(accHitTest(bul)){
						bul.removeBul();
						
						if(bul.type==this.type) return 1;
						return 2;
					}
				}
			}
			return 0;
		}
		
		private function distMoved(){
			return Math.sqrt(Math.pow(this.x-startX,2)+Math.pow(this.y-startY,2));
		}
		
		public function accHitTest(obj){
			var col = new CollisionGroup(this,obj);
			var h = col.checkCollisions();
			return h.length;
		}
	}
	
}
