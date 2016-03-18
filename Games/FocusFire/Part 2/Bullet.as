package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Bullet extends MovieClip {
		public var spd:Number = 30;
		public var type:Number = 1;
		
		private var stage2;
		private var bulletHolder;
		private var posX,posY;
		private var spdX,spdY;
		//private var ttlMiss;
		
		public function Bullet(args){
			bulletHolder = args["bulletHolder"];
			stage2 = args["stage"];
			posX = args["posX"];
			posY = args["posY"];
			//ttlMiss = args["ttlMiss"];
			type = args["type"];
			gotoAndStop(type);
			
			var startX = args["startX"];
			var startY = args["startY"];
			var angle = Math.atan2(posY-startY,posX-startX);
			spdX = spd*Math.cos(angle);
			spdY = spd*Math.sin(angle);
			this.rotation = angle/(Math.PI/180)+90;
						
			this.addEventListener(Event.ENTER_FRAME,moveBul); //we need to keep the bullet moving, so use ENTER_FRAME
		}
		
		function moveBul(e){
			this.x += spdX;
			this.y += spdY;
			
			//trace(stage2+" "+ttlMiss);
			if(this.y<0 || this.y>stage2.stageHeight || this.x<0 || this.x>stage2.stageWidth){
				removeBul();
			}			
		}
		
		public function removeBul(){
				this.removeEventListener(Event.ENTER_FRAME,moveBul);
				this.parent.removeChild(this);
		}
	}
	
}
