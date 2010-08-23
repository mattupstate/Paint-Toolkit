package net.nobien.paint.core 
{
    import flash.geom.Rectangle;

    public interface IComposite
    {
		function destroy():void;
        function getPixel32( x:int, y:int ):int;
		function render( preserve:Boolean = true ):void;
        function get rect():Rectangle;
    }
}