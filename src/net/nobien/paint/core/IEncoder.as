package net.nobien.paint.core 
{
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;
    
    public interface IEncoder extends IEventDispatcher
    {
        function encode( source:IComposite ):void;
        function get bytes():ByteArray;
        function get contentType():String;
        function get fileExtension():String;
    }
}