package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	public class Bullet extends MovieClip {
		//private var stage;
		private var bulletHolder;
		public var spd:Number;
		public var acc:Number;
		
		private var core;
		private var shield;
		
		public function Bullet(args){
			//stage = args["stage"];
			bulletHolder = args["bulletHolder"];
			core = args["core"];
			shield = args["shield"];
		}
		
		public function moveToMiddle(){
			/* RETURNS
			 * 0: No hit 
			 * 1: Hit Shield
			 * 2: Hit Core
			*/
			
			var dx = stage.stageWidth/2 - x;
			var dy = stage.stageHeight/2 - y;
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
