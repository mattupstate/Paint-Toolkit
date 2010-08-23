package 
{
    import flash.display.Shape;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
	import net.nobien.paint.brushes.MouseEnabledBrush;
    import net.nobien.paint.core.ILayer;
	
    public class ExampleCustomBrush extends MouseEnabledBrush
    {        
        private var _layerIndex:Number = 0;
        private var _segmentWidth:Number = 2;
        private var _minSpeed:Number = 10;
        private var _maxSpeed:Number = 50;
        private var _minForce:Number = 5;
        private var _maxForce:Number = 20;
        private var _currentColor:Number = 0;
        private var _vehicles:Vector.<SteeredVehicle> = new Vector.<SteeredVehicle>();
        
        public function ExampleCustomBrush( targetLayer:ILayer, numVehicles:Number = 1, segmentWidth:Number = 2 ) 
        {
            super( targetLayer );
            this.numVehicles = numVehicles;
            this.segmentWidth = segmentWidth;
        }
        
        override protected function onMouseDown( event:MouseEvent ):void 
        {
            super.onMouseDown( event );
            moveVehiclesToMouse();
            targetLayer.addEventListener( Event.ENTER_FRAME, onEnterFrame );
        }
        
        override protected function onMouseUp( event:MouseEvent ):void 
        {
            super.onMouseUp( event );
            targetLayer.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
        }
        
        protected function onEnterFrame( event:Event ):void 
        {
            draw();
        }
        
        protected function moveVehiclesToMouse():void
        {
            for( var i:int = 0; i < _vehicles.length; i++ )
            {
                _vehicles[i].position = new Vector2D( targetLayer.mouseX, targetLayer.mouseY );
            }
        }
        
        override protected function draw( render:Boolean = true, cleanup:Boolean = true ):void
        {
            var newPoint:Point = new Point( targetLayer.mouseX, targetLayer.mouseY );
            var color:uint = ColorUtil.HSVtoHEX( _currentColor, 80, 100 );
            
            for( var i:int = 0; i < _vehicles.length; i++ )
            {
                var v:SteeredVehicle = _vehicles[i];
				
				var lastPos:Vector2D = v.position;
				var lastVel:Vector2D = v.velocity;
				
				v.arrive( new Vector2D( targetLayer.mouseX, targetLayer.mouseY ) );
			    //v.wander();
				v.update();
				
				var currPos:Vector2D = v.position;
				var currVel:Vector2D = v.velocity;
                
                var midX:Number = ( lastPos.x + currPos.x ) * 0.5;
				var midY:Number = ( lastPos.y + currPos.y ) * 0.5;
				
                var s:Shape = new Shape();
                s.graphics.beginFill( color, 1 );
                s.graphics.lineStyle( 0.1, 0x000000, 0.5 );
                
                var pt1:Point = new Point( lastPos.x + ( segmentWidth * Math.cos( lastVel.perp.angle ) ), lastPos.y + ( segmentWidth * Math.sin( lastVel.perp.angle ) ) );
                var pt2:Point = new Point( lastPos.x + ( -segmentWidth * Math.cos( lastVel.perp.angle ) ), lastPos.y + ( -segmentWidth * Math.sin( lastVel.perp.angle ) ) );
                var pt3:Point = new Point( currPos.x + ( segmentWidth * Math.cos( currVel.perp.angle ) ), currPos.y + ( segmentWidth * Math.sin( currVel.perp.angle ) ) );
                var pt4:Point = new Point( currPos.x + ( -segmentWidth * Math.cos( currVel.perp.angle ) ), currPos.y + ( -segmentWidth * Math.sin( currVel.perp.angle ) ) );
                
                s.graphics.moveTo( pt1.x, pt1.y );
                s.graphics.lineTo( pt3.x, pt3.y );
                s.graphics.lineTo( pt4.x, pt4.y );
                s.graphics.lineTo( pt2.x, pt2.y );
                
                targetLayer.getDrawingLayerAt( _layerIndex ).addChild( s );
            }
            _currentColor ++;
                
            if( _currentColor > 360 )
                _currentColor = 0;
                
            if( render ) targetLayer.render();
            if ( cleanup ) targetLayer.clearDrawingLayerAt( _layerIndex );
			
			super.draw();
        }
        
        
        protected function createVehicle():SteeredVehicle
        {
            var vehicle:SteeredVehicle = new SteeredVehicle();
            vehicle.edgeBehavior = Vehicle.BOUNCE;
            vehicle.bounds = targetLayer.rect;
            vehicle.maxSpeed = minSpeed + Math.random() * ( maxSpeed - minSpeed );
            vehicle.maxForce = minForce + Math.random() * ( maxForce - minForce );
            return vehicle;
        }
        
        protected function updateVehicleAmount( newAmount:int ):void
        {
            var i:int = 0;
            
            if( newAmount < _vehicles.length )
            {
                for( i = _vehicles.length - 1; i > -1; i-- )
                {
                    _vehicles.pop();
                    if( _vehicles.length == newAmount )
                        break;
                }
            }
            else if( newAmount > _vehicles.length )
            {
                for( i = 0; i < newAmount; i++ )
                {
                    _vehicles.push( createVehicle() );
                    if( _vehicles.length == newAmount )
                        break;
                }
            }
        }
        
        override protected function disable(  ):void 
        {
            super.disable();
            targetLayer.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
        }
        
        public function get segmentWidth():Number { return _segmentWidth; }
        public function set segmentWidth( value:Number ):void { _segmentWidth = Math.max( 0, value ); }
        
        public function get numVehicles():int { return _vehicles.length; }
        public function set numVehicles( value:int ):void { updateVehicleAmount( Math.max( 0, value ) ); }
        
        public function get minSpeed():Number { return _minSpeed; }
        public function set minSpeed( value:Number ):void { _minSpeed = value; }
        
        public function get maxSpeed():Number { return _maxSpeed; }
        public function set maxSpeed( value:Number ):void { _maxSpeed = value; }
        
        public function get minForce():Number { return _minForce; }
        public function set minForce( value:Number ):void { _minForce = value; }
        
        public function get maxForce():Number { return _maxForce; }
        public function set maxForce( value:Number ):void { _maxForce = value; }
    }
}