package  {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	public class ShieldAid extends Sprite{		
		private var angle_start,angle_to,angle_from;
		private var radius;
		private var stagez;
		private var thickness;
		private var deg_to_rad=(Math.PI/180);
		private var extend:Number = 400;
		
		public function ShieldAid(args){
			angle_start = args["angleStart"];
			angle_to = angle_start+args["size"]/2;
			angle_from = angle_start-args["size"]/2;
			thickness = args["width"];
			radius = args["rad"];
			stagez = args["stage"];
						
			this.graphics.clear();
			
			var start1 = new Array(radius*Math.cos(angle_from*deg_to_rad), radius*Math.sin(angle_from*deg_to_rad));
			var start2 = new Array((radius+extend)*Math.cos(angle_from*deg_to_rad), (radius+extend)*Math.sin(angle_from*deg_to_rad));
			var end1 = new Array(radius*Math.cos(angle_to*deg_to_rad), radius*Math.sin(angle_to*deg_to_rad));
			var end2 = new Array((radius+extend)*Math.cos(angle_to*deg_to_rad), (radius+extend)*Math.sin(angle_to*deg_to_rad));
			
			graphics.beginFill(0xCCCCCC,0.1);
			graphics.moveTo(start1[0],start1[1]);
			drawShield();
			graphics.lineTo(end2[0],end2[1]);
			radius+=extend;
			drawShieldRev();
			graphics.lineTo(start1[0],start1[1]);
			//graphics.endFill();
		}
		
		private function drawShield(){
			x = 0;
			y = 0;
			
			//this.graphics.lineStyle(thickness,0xCCCCCC,0.5);
            			
			var angle_diff=angle_to-angle_from;
            var steps=Math.round(angle_diff);
            var angle=angle_from;
            var px=x+radius*Math.cos(angle*deg_to_rad);
            var py=y+radius*Math.sin(angle*deg_to_rad);
            
			for (var i:int=1; i<=steps; i++) {
                angle=angle_from+angle_diff/steps*i;
                this.graphics.lineTo(x+radius*Math.cos(angle*deg_to_rad),y+radius*Math.sin(angle*deg_to_rad));
            }
			
			this.x = stagez.stageWidth/2;
			this.y = stagez.stageHeight/2;
		}
		
		private function drawShieldRev(){
			x = 0;
			y = 0;
			
			//this.graphics.lineStyle(thickness,0xCCCCCC,0.5);
            			
			var angle_diff=angle_to-angle_from;
            var steps=Math.round(angle_diff);
            var angle=angle_to;
            var px=x+radius*Math.cos(angle*deg_to_rad);
            var py=y+radius*Math.sin(angle*deg_to_rad);
            
			for (var i:int=1; i<=steps; i++) {
                angle=angle_to-angle_diff/steps*i;
                this.graphics.lineTo(x+radius*Math.cos(angle*deg_to_rad),y+radius*Math.sin(angle*deg_to_rad));
            }
			
			this.x = stagez.stageWidth/2;
			this.y = stagez.stageHeight/2;
		}
	}
}
