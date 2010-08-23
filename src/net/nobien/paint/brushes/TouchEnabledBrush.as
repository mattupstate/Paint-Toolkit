package net.nobien.paint.brushes 
{
	import flash.events.TouchEvent;
	import flash.geom.Point;
    import net.nobien.paint.core.ILayer;
	
	public class TouchEnabledBrush extends Brush
	{
        protected var _touchPoint:Point = new Point();
		
		public function TouchEnabledBrush( targetLayer:ILayer = null ) 
        {
            super( targetLayer );
		}
		
		protected function onTouchEnd( event:TouchEvent ):void 
		{
            _tracking = false;
            targetLayer.painting.removeEventListener( TouchEvent.TOUCH_END, onTouchEnd );
            targetLayer.painting.removeEventListener( TouchEvent.TOUCH_MOVE, onTouchMove );
            targetLayer.painting.addEventListener( TouchEvent.TOUCH_BEGIN, onTouchBegin );
		}
		
		protected function onTouchBegin( event:TouchEvent ):void 
		{
            _tracking = true;
            move( event.localX, event.localY );
            targetLayer.painting.removeEventListener( TouchEvent.TOUCH_BEGIN, onTouchBegin );
            targetLayer.painting.addEventListener( TouchEvent.TOUCH_END, onTouchEnd );
            targetLayer.painting.addEventListener( TouchEvent.TOUCH_MOVE, onTouchMove );
		}
		
		protected function onTouchRollOut( event:TouchEvent ):void 
		{
            targetLayer.painting.removeEventListener( TouchEvent.TOUCH_ROLL_OUT, onTouchRollOut );
            targetLayer.painting.addEventListener( TouchEvent.TOUCH_ROLL_OVER, onTouchRollOver );
		}
		
		protected function onTouchRollOver( event:TouchEvent ):void 
		{
            targetLayer.painting.removeEventListener( TouchEvent.TOUCH_ROLL_OVER, onTouchRollOver );
            targetLayer.painting.addEventListener( TouchEvent.TOUCH_ROLL_OUT, onTouchRollOut );
		}
        
		protected function onTouchMove( event:TouchEvent ):void 
		{
            move( event.localX, event.localY );
		}
		
        protected function initTouchEvents():void
        {
            if( targetLayer && targetLayer.painting )
            {
				targetLayer.painting.addEventListener( TouchEvent.TOUCH_ROLL_OVER, onTouchRollOver );
                targetLayer.painting.addEventListener( TouchEvent.TOUCH_BEGIN, onTouchBegin );
            }
        }
		
        protected function killTouchEvents():void
        {
            if( targetLayer && targetLayer.painting )
            {
				targetLayer.painting.removeEventListener( TouchEvent.TOUCH_ROLL_OVER, onTouchRollOver );
				targetLayer.painting.removeEventListener( TouchEvent.TOUCH_ROLL_OUT, onTouchRollOut );
				targetLayer.painting.removeEventListener( TouchEvent.TOUCH_BEGIN, onTouchBegin );
				targetLayer.painting.removeEventListener( TouchEvent.TOUCH_END, onTouchEnd );
				targetLayer.painting.removeEventListener( TouchEvent.TOUCH_MOVE, onTouchMove );
            }
        }
		
        override protected function enable():void 
        {
            super.enable();
			initTouchEvents();
        }
        
        override protected function disable(  ):void 
        {
            super.disable();
            killTouchEvents();
        }
        
        override public function destroy():void 
        {
            killTouchEvents();
            super.destroy();
        }
        
        override public function set targetLayer( value:ILayer ):void 
        {
            killTouchEvents();
            super.targetLayer = value;
            if( enabled ) initTouchEvents();
        }
	}
}