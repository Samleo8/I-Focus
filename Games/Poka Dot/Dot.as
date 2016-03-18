package  {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Dot{
		private var stage1;
		private var dotHolder;
		private var scoreMC;
		private var score;
		private var destroyTime:Number = 0.5;
		private var nx,ny;
		//private var t:Timer = new Timer(destroyTime*1000);
		public var mc:MovieClip;
		
		public function Dot(args) {
			stage1 = args["stage"];
			dotHolder = args["dotHolder"];
			scoreMC = args["scoreMC"];
			score = args["ttlScore"];
			
			mc = new DotMc();
			newPos();
			
			mc.addEventListener(MouseEvent.MOUSE_OVER,hitPop);
			//t.addEventListener(TimerEvent.TIMER,destroyPop);
			//t.start();			
		}
		private function hitPop(e){
			score++;
			scoreMC.text = score;
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.align = TextFormatAlign.LEFT;
			scoreMC.setTextFormat(txtFormat);
			
			destroyPop(e);
		}
			
		private function destroyPop(e){
			//t.reset();
			//t.start();
			newPos();
		}
		
		public function newPos(){
			nx = (stage1.stageWidth/6)*(rand(1,3)*2-1);
			ny = (stage1.stageHeight/6)*(rand(1,3)*2-1);
			if(nx != mc.x && ny != mc.y){
				mc.x = nx;
				mc.y = ny;
				return;
			}
			newPos();
		}
		
		function rand(lw,hg){
			return Math.floor(Math.random()*(1+hg-lw))+lw;
		}
	}
	
}
