package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	public class EnemyBullet extends MovieClip {
		//private var stage;
		public var spd:Number;
		public var acc:Number;
		public var type:Number = 1;
		
		private var core;
		private var shield;
		private var bulletHolder;
		
		public function EnemyBullet(args){
			//stage = args["stage"];
			core = args["core"];
			shield = args["shield"];
			bulletHolder = args["bulletHolder"];
			this.gotoAndStop(type);
		}
		
		public function moveToMiddle(){
			/* RETURNS
			 * 0: No hit 
			 * 1: Hit Shield
			 * 2: Hit Core
			 * 3: Hit Bullet (die)
			 * 4: Hit Bullet (wrong)
			*/
			
			var dx = core.x - x;
			var dy = core.y - y;
			var angle = Math.atan2(dy, dx);
			//var distance = Math.sqrt(dx * dx + dy * dy);
			for(var i=0;i<spd;i++){
				x += Math.cos(angle);
				y += Math.sin(angle);
				if(accHitTest(shield)){
					return 1;
				}
				if(accHitTest(core)){
					return 2;
				}
				
			}
			spd+=acc;
			return 0;
		}
		
		public function accHitTest(obj){
			var col = new CollisionGroup(this,obj);
			var h = col.checkCollisions();
			return h.length;
		}
	}
	
}
