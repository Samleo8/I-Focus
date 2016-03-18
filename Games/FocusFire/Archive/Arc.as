package {
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.events.Event;
	import flash.display.MovieClip;
	
    public class Arc{
		private var stage;
        public var my_canvas:Sprite = new Sprite();
        var deg_to_rad=0.0174532925;
        var power:int=0;
        public function Arc(args){
			stage = args["stage"];
			//my_canvas.addEventListener(Event.ENTER_FRAME,on_enter_frame);
            my_canvas.graphics.lineStyle(20,0xD9D9D9,1);
        }
        public function draw_arc(movieclip,center_x,center_y,radius,angle_from,angle_to,precision) {
			my_canvas.graphics.clear();
			my_canvas.graphics.lineStyle(4,0xD9D9D9,1);
            var angle_diff=angle_to-angle_from;
            var steps=Math.round(angle_diff*precision);
            var angle=angle_from;
            var px=center_x+radius*Math.cos(angle*deg_to_rad);
            var py=center_y+radius*Math.sin(angle*deg_to_rad);
            movieclip.graphics.moveTo(px,py);
            for (var i:int=1; i<=steps; i++) {
                angle=angle_from+angle_diff/steps*i;
                movieclip.graphics.lineTo(center_x+radius*Math.cos(angle*deg_to_rad),center_y+radius*Math.sin(angle*deg_to_rad));
            }
        }
        public function on_enter_frame(e:Event) {
            if (1) {
                power++;
                if (power>=120) {
                    power-=120;
                }
                my_canvas.graphics.clear();
                my_canvas.graphics.lineStyle(20,0x000000,1);
                draw_arc(my_canvas,250,200,150,270-power,270+power,1);
            }
        }
    }
}