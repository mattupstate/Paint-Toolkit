package net.nobien.paint.encoders 
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.ByteArray;
	import flash.utils.getTimer;
    import net.nobien.paint.core.IComposite;
    import net.nobien.paint.core.IEncoder;
    import net.nobien.paint.events.EncoderEvent;

    public class PNGEncoder extends EventDispatcher implements IEncoder
    {
        private var _bytes:ByteArray;	
		private var _crcTable:Array = [];	
        private var _frameLimit:int = 35;
        private var _IDAT:ByteArray;
        private var _currentRow:int;
		private var _source:IComposite;
        private var _sprite:Sprite;
        
        public function PNGEncoder( frameLimit:int = 35 ) 
        {
            super();
            createCRCTable();
        }
        
        private function onEnterFrame( event:Event ):void 
        {
            writeRows();
            if( _currentRow >= _source.rect.height )
            {
                _sprite.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
                finish();
            }
	    }
        
        private function createCRCTable():void
        {
            var c:uint;
            for ( var n:uint = 0; n < 256; n++ )
            {
                c = n;
                for ( var k:uint = 0; k < 8; k++ ) 
                {
                    if ( c & 1 )
                        c = uint( uint( 0xedb88320 ) ^ uint( c >>> 1 ) );
                    else
                        c = uint( c >>> 1 );
                }
                _crcTable[n] = c;
            }		
        }
        
        private function finish():void
        {
            _IDAT.compress();
            writeChunk( _bytes, 0x49444154, _IDAT );
            writeChunk( _bytes, 0x49454E44, null );
            dispatchEvent( new EncoderEvent( EncoderEvent.COMPLETE, 1 ) );
        }
        
	    private function writeChunk( png:ByteArray, type:uint, data:ByteArray ):void 
        {
			var c:uint;
	        var len:uint = 0;
	        
	        if (data != null) 
	            len = data.length;
            
	        png.writeUnsignedInt( len );
            
	        var p:uint = png.position;
	        png.writeUnsignedInt( type );
            
	        if ( data != null )
	            png.writeBytes( data );
	        
	        var e:uint = png.position;
	        png.position = p;
	        c = 0xffffffff;
            
	        for ( var i:int = 0; i < ( e - p ); i++) 
            {
	            c = uint( _crcTable[ ( c ^ png.readUnsignedByte() ) & uint( 0xff )] ^ uint( c >>> 8 ) );
	        }
            
	        c = uint( c^uint( 0xffffffff ) );
	        png.position = e;
	        png.writeUnsignedInt( c );
	    }
        
        private function writeRows():void
        {
            var startTime:int = getTimer();
            
            while ( getTimer() - startTime < _frameLimit )
            {
                if ( _currentRow < _source.rect.height )
                {
                    _IDAT.writeByte( 0 );
                    for( var j:int = 0; j < _source.rect.width; j++ )
                    {
                        var p:int = _source.getPixel32( j, _currentRow );
                        _IDAT.writeUnsignedInt( uint( ( ( p&0xFFFFFF ) << 8 ) | ( p>>>24 ) ) );
                    }
                    _currentRow++;
                } 
                else 
                {
                    break;
                }
            }
            dispatchEvent( new EncoderEvent( EncoderEvent.PROGRESS, _currentRow / _source.rect.height ) );
        }
        
        public function encode( source:IComposite ):void
        {
            _source = source;
	    	_bytes = new ByteArray();
            
	        _bytes.writeUnsignedInt( 0x89504e47 );
	        _bytes.writeUnsignedInt( 0x0D0A1A0A );
	        
            var IHDR:ByteArray = new ByteArray();
	        IHDR.writeInt( int( _source.rect.width ) );
	        IHDR.writeInt( int( _source.rect.height ) );
	        IHDR.writeUnsignedInt( 0x08060000 );
	        IHDR.writeByte( 0 );
	        writeChunk( _bytes, 0x49484452, IHDR );
            
	        _IDAT= new ByteArray();
	        _currentRow = 0;
	        
			_sprite = new Sprite();
            _sprite.addEventListener( Event.ENTER_FRAME, onEnterFrame );
	    }
        
        public function destroy():void
        {
            _bytes.clear();
            _bytes = null;
        }
        
        public function get bytes():ByteArray { return _bytes; }
        public function get contentType():String { return "image/png"; }
        public function get fileExtension():String { return "png"; }
    }
}