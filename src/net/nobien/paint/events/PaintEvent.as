package net.nobien.paint.events 
{
	import flash.events.Event;
	
	public class PaintEvent extends Event 
	{
		public static const RENDER:String = "render";
		
		public function PaintEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event 
		{ 
			return new PaintEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PaintEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}