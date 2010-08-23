package net.nobien.paint.core 
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;
    import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	import net.nobien.paint.core.IComposite;
    
    public interface IPainting extends IEventDispatcher
    {
        function addLayer( layer:ILayer ):ILayer;
		function addLayerAt( layer:ILayer, index:int ):ILayer;
        function getDrawingLayers():Vector.<DisplayObjectContainer>;
        function getLayerAt( index:int ):ILayer;
        function removeLayer( layer:ILayer ):ILayer;
		function removeLayerAt( index:int ):ILayer;
        function renderAllLayers():void;
        function render():void;
		function renderLayer( layer:ILayer ):void;
		function renderLayerAt( index:int ):void;
        function setCursor( cursor:DisplayObject ):void;
        function get composite():IComposite;
        function get mouseX():Number;
        function get mouseY():Number;
        function get numLayers():int;
        function get rect():Rectangle;
        function get stage():Stage;
    }
}