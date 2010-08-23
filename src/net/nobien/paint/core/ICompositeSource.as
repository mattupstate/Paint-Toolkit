package net.nobien.paint.core 
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	public interface ICompositeSource 
	{
		function getDrawingLayers():Vector.<DisplayObjectContainer>;
		function get rect():Rectangle;
	}	
}