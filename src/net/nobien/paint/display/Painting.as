package net.nobien.paint.display 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
    import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import net.nobien.paint.core.IComposite;
	import net.nobien.paint.core.ICompositeSource;
    import net.nobien.paint.core.ILayer;
    import net.nobien.paint.core.IPainting;
	import net.nobien.paint.events.PaintEvent;
	
    public class Painting extends Sprite implements IPainting, ICompositeSource
    {
        protected var _composite:Composite;
		protected var _rect:Rectangle;
        protected var _cursor:DisplayObject;
        protected var _layerContainer:DisplayObjectContainer;
        protected var _background:Shape;
        
        public function Painting( width:Number, height:Number, compositeScale:Number = 2 ) 
        {
            _rect = new Rectangle( 0, 0, width, height );
            
			_composite = new Composite( this, compositeScale );
            
			_background = Shape( addChild( new Shape() ) );
			_background.graphics.clear();
			_background.graphics.beginFill( 0xFFFFFF, 1 );
			_background.graphics.drawRect( 0, 0, _rect.width, _rect.height );
			_background.graphics.endFill();
			
			_layerContainer = DisplayObjectContainer( addChild( new Sprite() ) );
        }
		
		protected function handleEnterFrame( event:Event ):void 
		{
			updateCursor();
		}
		
		protected function handleMouseLeave( event:Event ):void 
		{
			removeEventListener( Event.ENTER_FRAME, handleEnterFrame );
			hideCursor();
		}
		
		protected function handleRollOver( event:MouseEvent ):void 
		{
			addEventListener( Event.ENTER_FRAME, handleEnterFrame );
			showCursor();
		}
		
		protected function hideCursor():void
		{
			if ( _cursor.parent == this )
			{
				removeChild( _cursor );
				Mouse.show();
			}
		}
        
		protected function showCursor():void
		{
			if ( _cursor.parent != this )
			{
				Mouse.hide();
				addChild( _cursor );
			}
		}
		
		protected function updateCursor():void 
		{
			if ( mouseX >= 0 && mouseX <= _rect.width && mouseY >= 0 && mouseY <= _rect.height )
			{
				showCursor();
				_cursor.x = mouseX;
				_cursor.y = mouseY;
			}
			else
			{
				hideCursor();
			}
		}
		
        protected function validateLayer( layer:ILayer ):ILayer
        {
            if ( layer.painting != this )
				throw new Error( "Error: Layer does not belong to this painting." );
            else
                return layer;
        }
		
		public function removeCursor():void
		{
			if ( _cursor )
			{
				hideCursor();
				_cursor = null;
			}
			
			removeEventListener( Event.ENTER_FRAME, handleEnterFrame );
			removeEventListener( MouseEvent.ROLL_OVER, handleRollOver );
			stage.removeEventListener( Event.MOUSE_LEAVE, handleMouseLeave );
		}
		
		public function addLayer( layer:ILayer ):ILayer
		{
			return ILayer( _layerContainer.addChild( DisplayObject( validateLayer( layer ) ) ) );
		}
		
		public function addLayerAt( layer:ILayer, index:int ):ILayer
		{
			validateLayer( layer );
			return ILayer( _layerContainer.addChildAt( DisplayObject( validateLayer( layer ) ), index ) );
		}
        
		public function getDrawingLayers():Vector.<DisplayObjectContainer>
		{
			var result:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
			
			for ( var i:int = 0; i < numLayers; i++ )
                result = result.concat( getLayerAt( i ).getDrawingLayers() );
            
            return result;
		}
		
        public function getLayerAt( index:int ):ILayer
        {
            return ILayer( _layerContainer.getChildAt( index ) );;
        }
		
		public function removeLayer( layer:ILayer ):ILayer
		{
			var result:ILayer  = ILayer( _layerContainer.removeChild( DisplayObject( layer ) ) );
			result.destroy();
			return result;
		}
		
		public function removeLayerAt( index:int ):ILayer
		{
			var result:ILayer  = ILayer( _layerContainer.removeChildAt( index ) );
			result.destroy();
			return result;
		}
		
        public function renderAllLayers():void
        {
            for( var i:int = 0; i < numLayers; i++ )
                renderLayerAt( i );
        }
        
        public function render():void
        {
            _composite.render();
			dispatchEvent( new PaintEvent( PaintEvent.RENDER ) );
        }
        
		public function renderLayer( layer:ILayer ):void
		{
			layer.render();
		}
		
		public function renderLayerAt( index:int ):void
		{
			renderLayer( getLayerAt( index ) );
		}
		
		public function setCursor( cursor:DisplayObject ):void
		{
			removeCursor();
			
			_cursor = cursor;
			
			if ( _cursor )
			{
				addEventListener( Event.ENTER_FRAME, handleEnterFrame );
				addEventListener( MouseEvent.ROLL_OVER, handleRollOver );
				stage.addEventListener( Event.MOUSE_LEAVE, handleMouseLeave );
				updateCursor();
			}
		}
		
        public function get composite():IComposite { return _composite; }
		public function get numLayers():int { return _layerContainer.numChildren; }
		public function get rect():Rectangle { return _rect; }
        
        override public function get width():Number { return rect.width; }
        override public function set width( value:Number ):void 
        {
            throw new Error( "Error: Cannot change painting width." );
        }
        
        override public function get height():Number { return rect.height; }
        override public function set height( value:Number ):void 
        {
            throw new Error( "Error: Cannot change painting height." );
        }
    }
}