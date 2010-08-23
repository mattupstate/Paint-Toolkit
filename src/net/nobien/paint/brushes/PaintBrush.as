package net.nobien.paint.brushes 
{
    import flash.display.Shape;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import net.nobien.paint.core.ILayer;
	
    public class PaintBrush extends MouseEnabledBrush
    {
        public static const CIRCLE:String = "circle";
        public static const SQUARE:String = "square";
        
        protected var _color:uint;
        protected var _layerIndex:int;
        protected var _shape:String;
        protected var _size:Number;
        
        public function PaintBrush( targetLayer:ILayer, color:uint = 0x000000, size:Number = 10, shape:String = "circle" ) 
        {
            super( targetLayer );
            this.color = color;
            this.size = size;
            this.shape = shape;
        }
        
        override protected function onMouseDown( event:MouseEvent ):void 
        {
            super.onMouseDown( event );
            draw();
        }
        
        override protected function onMouseMove( event:MouseEvent ):void
        {
            draw();
            super.onMouseMove( event );
        }
        
        protected function drawBrush( x:Number, y:Number ):void
        {
            var s:Shape = new Shape();
            s.graphics.beginFill( _color );
            
            switch( _shape )
            {
                case CIRCLE:
                    s.graphics.drawCircle( x, y, _size * 0.5 );
                    break;
                    
                case SQUARE:
                    s.graphics.drawRect( _size * -0.5, _size * -0.5, _size, _size );
                    break;
            }
            
            s.graphics.endFill();
            targetLayer.getDrawingLayerAt( _layerIndex ).addChild( s );
        }
        
        override protected function draw( render:Boolean = true, cleanup:Boolean = true ):void
        {
            var newPoint:Point = new Point( targetLayer.mouseX, targetLayer.mouseY );
            var distance:Number = Math.floor( Point.distance( position, newPoint ) );
            
            if( distance == 0 )
            {
                drawBrush( targetLayer.mouseX, targetLayer.mouseY );
            }
            else
            {
                var f:Number = 0 / distance;
                var nextPoint:Point = Point.interpolate( position, newPoint, f );
                
                for( var i:int = 0; i < distance; i++ )
                {
                    f = i / distance;
                    nextPoint = Point.interpolate( position, newPoint, f );
                    drawBrush( Math.ceil( nextPoint.x ), Math.ceil( nextPoint.y ) );
                }
            }
            
            if( render ) targetLayer.render();
            if ( cleanup ) targetLayer.clearDrawingLayerAt( _layerIndex );
			
			super.draw();
        }
        
        override public function destroy(  ):void 
        {
            super.destroy();
            targetLayer.painting.stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
        }
        
        public function get size():Number { return _size; }
        public function set size( value:Number ):void { _size = value; }
        
        public function get color():uint { return _color; }
        public function set color( value:uint ):void { _color = value; }
        
        public function get shape():String { return _shape; }
        public function set shape( value:String ):void { _shape = value; }
    }
}