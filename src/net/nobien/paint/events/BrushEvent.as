package net.nobien.paint.events 
{
	import flash.events.Event;
	
	public class BrushEvent extends Event 
	{
		public static const DRAW:String = "draw";
		
		public function BrushEvent( type:String ) 
		{ 
			super( type );
		} 
		
		public override function clone():Event 
		{ 
			return new BrushEvent( type );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "BrushEvent", "type" ); 
		}
		
	}
	
}