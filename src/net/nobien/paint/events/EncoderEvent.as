package net.nobien.paint.events 
{
    import flash.events.Event;
    
    public class EncoderEvent extends Event 
    {
        public static const PROGRESS:String = "progress";
        public static const COMPLETE:String = "complete";
        
        private var _progress:Number;
        
        public function EncoderEvent( type:String, progress:Number = 0 ) 
        { 
            super(type, bubbles, cancelable);
            _progress = progress;
        } 
        
        public override function clone():Event 
        { 
            return new EncoderEvent( type, progress);
        } 
        
        public override function toString():String 
        { 
            return formatToString( "EncoderEvent", "type", "progress" ); 
        }
        
        public function get progress():Number { return _progress; }
    }
}