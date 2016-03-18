package  {	
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;

	public class Pops2 extends MovieClip{
		private var popHolder;
		private var destroyTime:Number = 0.1;
		private var t;
		public var mc:MovieClip;
		
		public function Pops2(args2){
			mc = new Pops();
			popHolder = args2["popHolder"];
			t = setTimeout(destroyPop, destroyTime*1000);
		}
		
		private function destroyPop(){
			clearTimeout(t);
			popHolder.removeChild(mc);
		}
	}
	
}
