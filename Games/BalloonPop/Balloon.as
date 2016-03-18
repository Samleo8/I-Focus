package  {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	public class Balloon extends MovieClip{
		private var balHolder;
		private var popHolder;
		public var spd:Number;
		public var colour:Number;
		private var cursor;
		private var pop:MovieClip;
		private var popInc:Number = 0.5;
		
		public function Balloon(args){
			balHolder = args["balHolder"];
			popHolder = args["popHolder"];
			cursor = args["cursor"];
			this.mainBalloon.addEventListener(MouseEvent.MOUSE_OVER,destroy);
			this.addEventListener(Event.ENTER_FRAME,floatUp);
		}
		
		public function floatUp(e){
			y -= spd;
		}
		
		public function destroy(e){
			var args2 = {
				"stage":stage,
				"popHolder":popHolder
			}
			
			pop = new Pops2(args2);
			pop.mc.x = this.x;
			pop.mc.y = this.y-this.height/3;
			pop.mc.width *= popInc;
			pop.mc.height *= popInc;
			popHolder.addChild(pop.mc);
			balHolder.removeChild(this);
		}
	}
	
}
