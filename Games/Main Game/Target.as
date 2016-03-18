package  {
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	public class Target extends MovieClip{
		public var t;
		private var lvlObj;
		private var targetTimeSwitch:Number;
		public function Target(args){
			lvlObj = args["lvlObj"];
			targetTimeSwitch = args["enemyDisappearTime"];
			this.buttonMode = true;
			this.mouseChildren = false;
		}
		public function startTimer(){
			t = setTimeout(activateSwitch,targetTimeSwitch);
		}
		public function clearTimer(){
			clearTimeout(t);
		}
		private function activateSwitch(){
			this.gotoAndStop(1);
			lvlObj.enemies.splice(lvlObj.enemies.indexOf(this), 1);
			lvlObj.newEnemy();
			trace("Enemy Switch!");
		}
	}
	
}
