package  
{
    
	import flash.display.Loader;
	import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
	import flash.events.TouchEvent;
    import flash.net.FileReference;
    import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import net.hires.debug.Stats;
    import net.nobien.paint.brushes.PaintBrush;
	import net.nobien.paint.brushes.TouchPaintBrush;
	import net.nobien.paint.display.Layer;
	import net.nobien.paint.display.Painting;
    import net.nobien.paint.encoders.PNGEncoder;
    import net.nobien.paint.events.EncoderEvent;
    
    [SWF(width="1024", height="768", backgroundColor="#C1C1C1", frameRate="30")]
    public class Example extends Sprite 
    {
        private var painting:Painting;
        private var brush:PaintBrush;
        private var customBrush:ExampleCustomBrush;
        private var touchBrush:TouchPaintBrush;
        
        public function Example() 
        {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            painting = new Painting( stage.stageWidth, stage.stageHeight, 2 );
            addChild( painting );
            
            var paintLayer:Layer = new Layer( painting );
            painting.addLayer( paintLayer );
			
            customBrush = new ExampleCustomBrush( paintLayer, 10 );
			
            if ( Multitouch.supportsTouchEvents )
            {
                touchBrush = new TouchPaintBrush( paintLayer );
                Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
            }
			
			var stats:Stats = new Stats();
			addChild( stats );
            
            stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
		}
        
        private function onKeyUp( event:KeyboardEvent ):void 
        {
            if ( event.keyCode == Keyboard.SPACE )
            {
                mouseEnabled = mouseChildren = false;
                var encoder:PNGEncoder = new PNGEncoder();
                encoder.addEventListener( EncoderEvent.COMPLETE, onEncodingComplete );
                encoder.encode( painting.composite );
            }
        }
        
        private function onEncodingComplete( event:EncoderEvent ):void 
        {
            var encoder:PNGEncoder = event.target as PNGEncoder;
            var fr:FileReference = new FileReference();
            fr.save( encoder.bytes, "painting." + encoder.fileExtension );
        }
    }
}