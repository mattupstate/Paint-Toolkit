package net.nobien.paint.brushes 
{
	import flash.events.EventDispatcher;
    import flash.geom.Point;
    import net.nobien.paint.core.IBrush;
    import net.nobien.paint.core.ILayer;
	import net.nobien.paint.events.BrushEvent;
	
	public class Brush extends EventDispatcher implements IBrush
	{
        protected var _position:Point = new Point();
        protected var _enabled:Boolean = true;
        protected var _targetLayer:ILayer;
        protected var _tracking:Boolean = false;
		
		public function Brush( targetLayer:ILayer = null ) 
		{
            this.targetLayer = targetLayer;
		}
		
		protected function notifyDraw():void
		{
			dispatchEvent( new BrushEvent( BrushEvent.DRAW ) );
		}
		
		protected function enable():void
        {
            _enabled = true;
        }
        
        protected function disable():void
        {
            _enabled = false;
        }
        
		protected function draw( render:Boolean = true, cleanup:Boolean = true ):void
		{
			notifyDraw();
		}
		
        public function move( x:Number, y:Number ):void
        {
            position.x = x;
            position.y = y;
        }
        
        public function destroy():void
        {
            targetLayer = null;
        }
        
        public function get targetLayer():ILayer { return _targetLayer; }
		public function set targetLayer( value:ILayer ):void { _targetLayer = value; }
        
        public function get enabled():Boolean { return _enabled; }
        public function set enabled( value:Boolean ):void 
        {
            if( value != _enabled )
            {
                if( value ) enable();
                else disable();
            }
        }
        
        public function get position():Point { return _position; }
        
        public function get tracking():Boolean { return _tracking; }
	}
}