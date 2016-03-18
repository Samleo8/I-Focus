package  {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	public class Shield extends Sprite{		
		private var angle_start,angle_to,angle_from;
		private var radius;
		private var stagez;
		private var thickness;
		private var deg_to_rad=(Math.PI/180);
		
		public function Shield(args){
			angle_start = args["angleStart"];
			angle_to = angle_start+args["size"];
			angle_from = angle_start-args["size"];
			thickness = args["width"];
			radius = args["rad"];
			stagez = args["stage"];
						
			drawShield();
		}
		
		private function drawShield(){
			x = 0;
			y = 0;
			
			this.graphics.clear();
			this.graphics.lineStyle(thickness,0xCCCCCC,1);
            			
			var angle_diff=angle_to-angle_from;
            var steps=Math.round(angle_diff);
            var angle=angle_from;
            var px=x+radius*Math.cos(angle*deg_to_rad);
            var py=y+radius*Math.sin(angle*deg_to_rad);
            
			this.graphics.moveTo(px,py);
			
			for (var i:int=1; i<=steps; i++) {
                angle=angle_from+angle_diff/steps*i;
                this.graphics.lineTo(x+radius*Math.cos(angle*deg_to_rad),y+radius*Math.sin(angle*deg_to_rad));
            }
			
			this.x = stagez.stageWidth/2;
			this.y = stagez.stageHeight/2;
		}
		
		public function reduceSize(sizeReduce){
			angle_to-=sizeReduce;
			angle_from+=sizeReduce;
			drawShield();
		}
	}
	
}
