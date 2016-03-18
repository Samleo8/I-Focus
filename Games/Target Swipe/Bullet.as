package  {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	public class Bullet extends MovieClip{
		//private var stage;
		private var bulletHolder;
		public var spd:Number;
		
		public function Bullet(args){
			//stage = args["stage"];
			bulletHolder = args["bulletHolder"];
			this.alpha = 1; //health directly related to alpha - 1 is full, 0 is dead
		}
		
		public function moveToMiddle(){
			//trace(x+","+y);
			this.bulShell.alpha=1;
			var dx = stage.stageWidth/2 - x;
			var dy = stage.stageHeight/2 - y;
			var angle = Math.atan2(dy, dx);
			//var distance = Math.sqrt(dx * dx + dy * dy);
			x += Math.cos(angle) * spd;
			y += Math.sin(angle) * spd;
		}
	}
	
}
