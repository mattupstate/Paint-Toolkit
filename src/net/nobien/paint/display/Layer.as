package net.nobien.paint.display 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import net.nobien.paint.core.IComposite;
	import net.nobien.paint.core.ICompositeSource;
	import net.nobien.paint.core.ILayer;
	import net.nobien.paint.core.IPainting;
	import net.nobien.paint.events.PaintEvent;
	
    public class Layer extends Sprite implements ILayer, ICompositeSource
    {
		protected var _painting:IPainting;
        protected var _composite:IComposite;
        protected var _drawingLayersContainer:DisplayObjectContainer;
		
        public function Layer( painting:IPainting, numDrawingLayers:int = 1 ) 
        {
            if( !painting ) 
                throw new Error( "Cann't create layer. Constructor argument 'painting' cannot be null." );
                
			_painting = painting;
            _composite = IComposite( addChild( new Composite( this ) ) );
            _drawingLayersContainer = DisplayObjectContainer( addChild( new Sprite() ) );
            
            var amt:int = Math.max( 1, numDrawingLayers );
            for( var i:int = 0; i < amt; i++ )
                addDrawingLayer( new Sprite() );
        }
        
        public function addDrawingLayer( layer:DisplayObjectContainer ):DisplayObjectContainer
        {
            layer.visible = false;
            return DisplayObjectContainer( _drawingLayersContainer.addChild( layer ) );
        }
        
        public function addDrawingLayerAt( layer:DisplayObjectContainer, index:int ):DisplayObjectContainer
        {
            layer.visible = false;
            return DisplayObjectContainer( _drawingLayersContainer.addChildAt( layer, index ) );
        }
        
        public function clearAllDrawingLayers():void
        {
            for( var i:int = 0; i < numDrawingLayers; i++ )
                clearDrawingLayerAt( i );
        }
        
		public function clearDrawingLayer( layer:DisplayObjectContainer ):void
		{
			while ( layer.numChildren > 0 )
				layer.removeChildAt( 0 );
		}
		
		public function clearDrawingLayerAt( index:int ):void
		{
			clearDrawingLayer( getDrawingLayerAt( index ) );
		}
		
        public function removeAllDrawingLayers():void
        {
            for( var i:int = 0; i < numDrawingLayers; i++ )
                removeDrawingLayerAt( i );
        }
        
        public function removeDrawingLayer( layer:DisplayObjectContainer ):DisplayObjectContainer
        {
            return DisplayObjectContainer( _drawingLayersContainer.removeChild( layer ) );
        }
        
        public function removeDrawingLayerAt( index:int ):DisplayObjectContainer
        {
            return DisplayObjectContainer( _drawingLayersContainer.removeChildAt( index ) );
        }
        
        public function getDrawingLayerAt( index:int ):DisplayObjectContainer
        {
            return DisplayObjectContainer( _drawingLayersContainer.getChildAt( index ) );
        }
        
		public function getDrawingLayers():Vector.<DisplayObjectContainer>
		{
            var result:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
            
            for( var i:int = 0; i < numDrawingLayers; i++ )
                result.push( getDrawingLayerAt( i ) );
            
			return result;
		}
		
		public function render():void
		{
			_painting.render();
			_composite.render();
			dispatchEvent( new PaintEvent( PaintEvent.RENDER ) );
		}
		
		public function destroy():void
		{
            clearAllDrawingLayers();
            removeAllDrawingLayers();
            
			_composite.destroy();
			_composite = null;
			_painting = null;
		}
		
		public function get rect():Rectangle { return painting.rect; }
		public function get composite():IComposite { return _composite; }
		public function get numDrawingLayers():int { return _drawingLayersContainer.numChildren; }
        public function get painting():IPainting { return _painting; }
    }
}