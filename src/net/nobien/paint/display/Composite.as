package net.nobien.paint.display 
{
	import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
	import net.nobien.paint.core.ICompositeSource;
    import net.nobien.paint.core.IComposite;
	
    public class Composite extends Bitmap implements IComposite
    {
        protected var _fillColor:uint = 0x00FFFFFF;
        protected var _source:ICompositeSource;
        protected var _rect:Rectangle;
        protected var _scale:Number;
        protected var _border:int;
        protected var _gridSize:int;
        protected var _gridWidth:int;
        protected var _gridHeight:int;
        protected var _gridRect:Rectangle;
        protected var _gridData:Vector.<BitmapData>;
        
        public function Composite( source:ICompositeSource, scale:Number = 1, gridSize:int = 1024, border:int = 128 ) 
        {
			super( null, "auto", true );
			
            _source = source;
            _scale = Math.max( 1, scale );
            _gridSize = gridSize;
            _border = border;
            
            _rect = new Rectangle(0, 0, Math.ceil( _source.rect.width * scale ), Math.ceil( _source.rect.height * scale ));
            
            _gridWidth = Math.ceil( _rect.width / _gridSize );
			_gridHeight = Math.ceil( _rect.height / _gridSize );
            
            var rectSize:int = _gridSize + ( border * 2 );
            
			_gridRect = new Rectangle( 0, 0, rectSize, rectSize );
            _gridData = new Vector.<BitmapData>();
            
            for( var i:int = 0; i < _gridHeight; ++i )
            {
				for ( var j:int = 0; j < _gridWidth; ++j ) 
                {
                    var index:int = i * _gridWidth + j;
					_gridData[index] = new BitmapData( rectSize, rectSize, true, _fillColor );
				}
			}
			
			if ( _scale == 1 ) this.bitmapData = _gridData[0];
        }
        
        public function render( preserve:Boolean = true ):void
        {
            var i:int = 0;
            var amount:int = _gridData.length;
			
			if ( !preserve )
            {
				for ( i = 0; i < amount; ++i )
                {
					_gridData[i].fillRect( _rect, _fillColor );
				}
			}
			
            var layers:Vector.<DisplayObjectContainer> = _source.getDrawingLayers();
            
            if( _scale == 1 )
            {
                for( i = 0; i < layers.length; i++ )
                    _gridData[0].draw( layers[i], null, null, null, _rect );
            }
            else
            {
                for ( i = 0; i < amount; ++i )
                {
                    var column:int = i % _gridWidth;
                    var row:int = int( i / _gridWidth );
                    var matrix:Matrix = new Matrix( _scale, 0, 0, _scale, _border - ( column * _gridSize ), _border - ( row * _gridSize ) );
                    
                    for( var j:int = 0; j < layers.length; j++ )
                        _gridData[i].draw( layers[j], matrix );
                }
            }
        }
        
		public function destroy():void
		{
			for ( var i:int = 0; i < _gridData.length; i++ )
			{
				var bd:BitmapData = _gridData.pop();
				bd.dispose();
			}
			_gridData = null;
			_source = null;
		}
		
        public function getPixel32( x:int, y:int ):int 
        {
			var x1:int = int( x / _gridSize );
			var y1:int = int( y / _gridSize );
			var x2:int = x - ( x1 * _gridSize );
			var y2:int = y - ( y1 * _gridSize );
			
			return _gridData[y1 * _gridWidth + x1].getPixel32( x2 + _border, y2 + _border );
		}
        
        public function get rect():Rectangle { return _rect; }
    }
}