package net.nobien.paint.core 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	import net.nobien.paint.core.IComposite;
	
    public interface ILayer extends IEventDispatcher
    {
        function addDrawingLayer( layer:DisplayObjectContainer ):DisplayObjectContainer;
        function addDrawingLayerAt( layer:DisplayObjectContainer, index:int ):DisplayObjectContainer;
        function clearAllDrawingLayers():void;
        function clearDrawingLayer( layer:DisplayObjectContainer ):void;
        function clearDrawingLayerAt( index:int ):void;
        function getDrawingLayers():Vector.<DisplayObjectContainer>;
        function getDrawingLayerAt( index:int ):DisplayObjectContainer;
        function removeDrawingLayer( layer:DisplayObjectContainer ):DisplayObjectContainer;
        function removeDrawingLayerAt( index:int ):DisplayObjectContainer;
        function render():void;
		function destroy():void;
		
        function get composite():IComposite;
        function get mouseX():Number;
        function get mouseY():Number;
        function get numDrawingLayers():int;
		function get painting():IPainting;
        function get rect():Rectangle;
    }
}