package net.nobien.paint.brushes 
{
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import net.nobien.paint.core.ILayer;

    public class MouseEnabledBrush extends Brush
    {
        public function MouseEnabledBrush( targetLayer:ILayer = null ) 
        {
            super( targetLayer );
        }
        
        protected function onRollOver( event:MouseEvent ):void
        {
            targetLayer.painting.removeEventListener( MouseEvent.ROLL_OVER, onRollOver );
            targetLayer.painting.addEventListener( MouseEvent.ROLL_OUT, onRollOut );
        }
        
        protected function onRollOut( event:MouseEvent ):void
        {
            targetLayer.painting.removeEventListener( MouseEvent.ROLL_OUT, onRollOut );
            targetLayer.painting.addEventListener( MouseEvent.ROLL_OVER, onRollOver );
        }
        
        protected function onMouseDown( event:MouseEvent ):void
        {
            _tracking = true;
            targetLayer.painting.removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
            targetLayer.painting.stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
            targetLayer.painting.stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
            move( targetLayer.mouseX, targetLayer.mouseY );
        }
        
        protected function onMouseUp( event:MouseEvent ):void
        {
            _tracking = false;
            targetLayer.painting.stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
            targetLayer.painting.stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
            targetLayer.painting.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
        }
        
        protected function onMouseMove( event:MouseEvent ):void
        {
            move( targetLayer.mouseX, targetLayer.mouseY );
        }
        
        protected function initMouseEvents():void
        {
            if( targetLayer && targetLayer.painting )
            {
                targetLayer.painting.addEventListener( MouseEvent.ROLL_OVER, onRollOver );
                targetLayer.painting.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
            }
        }
		
        protected function killMouseEvents():void
        {
            if( targetLayer && targetLayer.painting )
            {
                targetLayer.painting.removeEventListener( MouseEvent.ROLL_OVER, onRollOver );
                targetLayer.painting.removeEventListener( MouseEvent.ROLL_OUT, onRollOut );
                targetLayer.painting.removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
                targetLayer.painting.stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
                targetLayer.painting.stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
            }
        }
        
        override protected function enable():void 
        {
            super.enable();
            initMouseEvents();
        }
        
        override protected function disable(  ):void 
        {
            super.disable();
            killMouseEvents();
        }
        
        override public function destroy():void 
        {
            killMouseEvents();
            super.destroy();
        }
        
        override public function set targetLayer( value:ILayer ):void 
        {
            killMouseEvents();
            super.targetLayer = value;
            if( enabled ) initMouseEvents();
        }
    }
}