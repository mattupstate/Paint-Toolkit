package net.nobien.paint.core 
{
    import flash.geom.Point;
	public interface IBrush 
	{
        function destroy():void;
        function get position():Point;
		function get targetLayer():ILayer;
		function set targetLayer( value:ILayer ):void;
        function get tracking():Boolean;
	}
}