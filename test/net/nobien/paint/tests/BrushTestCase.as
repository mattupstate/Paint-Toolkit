package net.nobien.paint.tests 
{
    import net.nobien.paint.brushes.Brush;
    import org.flexunit.Assert;
    
    public class BrushTestCase
    {
        private var brush:Brush;
        
        [Before]
        public function before():void
        {
            brush = new Brush();
        }
        
        [After]
        public function after():void
        {
            brush = null;
        }
        
        [Test(order="1")]
        public function brush_is_initially_enabled():void
        {
            Assert.assertTrue( "Brush should initially be enabled", brush.enabled );
        }
        
        [Test(order="2")]
        public function brush_is_initially_at_0_0():void
        {
            Assert.assertEquals( "Brush position.x should be 0 after instantiated", brush.position.x, 0 );
            Assert.assertEquals( "Brush position.y should be 0 after instantiated", brush.position.y, 0 );
        }
        
        [Test(order="3")]
        public function move_changes_position():void
        {
            brush.move( 10, 20 );
            Assert.assertEquals( "Brush's position.x should change to specied coordinates after calling move()", brush.position.x, 10 );
            Assert.assertEquals( "Brush's position.y should change to specied coordinates after calling move()", brush.position.y, 20 );
        }
        
        [Test(order="4")]
        public function destroy_clears_target_layer():void
        {
            brush.destroy();
            Assert.assertNull( "Brush's targetLayer property should be null after calling destroy()", brush.targetLayer );
        }
        
    }

}