package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class Joystick extends MovieClip{
		private var  _startX:Number = 0;
		private var  _startY:Number = 0;
		private var  _tension:Number = .5;
		private var  _decay:Number = .7;
		private var  _xSpeed:Number = 0;
		private var  _isDragging:Boolean = false;
		private var  _angle:int;
		private var  _radius:int = 30;
		
		public var isKeyDown = {
			"left":false,
			"right":false
		};
		
		public function Joystick(stage) {
			_startX = this.x;
			_startY = this.y;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,on_mouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP,on_mouseUp);
			stage.addEventListener(Event.ENTER_FRAME,on_enterFrame);
		}
		
		function on_mouseDown(e:MouseEvent):void
		{
			_isDragging = true;
		}
		 
		function  on_mouseUp(e:MouseEvent):void
		{
			_isDragging = false;
		}
		
		function  on_enterFrame(e:Event):void
		{
			if( _isDragging )
			{	
				//trace(root.mouseX+" "+root.mouseY);
				//_angle = Math.atan2(mouseY-_startY,mouseX-_startX)/(Math.PI/180);
				//this.rotation = _angle;
				//this.knob.rotation = -_angle; 
				this.knob.x = mouseX;
				if(this.knob.x > _radius)
				{
					this.knob.x = _radius;
				}
				else if(this.knob.x < -_radius){
					this.knob.x = -_radius;
				}
				
				if(this.knob.x > 0)
				{
					 isKeyDown["left"] = false;
					 isKeyDown["right"] = true;
				}
				else if(this.knob.x == 0){
					isKeyDown["left"] = false;
					isKeyDown["right"] = false;
				}
				else
				{
					isKeyDown["left"] = true;
					isKeyDown["right"] = false;
				}
			}
			else
			{
				//If the this is not being touched, return it to the neutral position
				//and decellerate player speed
				_xSpeed = -this.knob.x*_tension;
				this.knob.x += _xSpeed;
				isKeyDown["left"] = false;
				isKeyDown["right"] = false;
			}
		}
	}
}
