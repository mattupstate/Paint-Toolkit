package  
{
    public class ColorUtil
    {
        public static function RGBToHex(r:uint, g:uint, b:uint):uint
        {
            var hex:uint = (r << 16 | g << 8 | b);
            return hex;
        }

        public static function HexToRGB(hex:uint):Array
        {
            var rgb:Array = [];

            var r:uint = hex >> 16 & 0xFF;
            var g:uint = hex >> 8 & 0xFF;
            var b:uint = hex & 0xFF;

            rgb.push(r, g, b);
            return rgb;
        }

        public static function RGBtoHSV(r:uint, g:uint, b:uint):Array
        {
            var max:uint = Math.max(r, g, b);
            var min:uint = Math.min(r, g, b);

            var hue:Number = 0;
            var saturation:Number = 0;
            var value:Number = 0;

            var hsv:Array = [];

            //get Hue
            if(max == min){
                hue = 0;
            }else if(max == r){
                hue = (60 * (g-b) / (max-min) + 360) % 360;
            }else if(max == g){
                hue = (60 * (b-r) / (max-min) + 120);
            }else if(max == b){
                hue = (60 * (r-g) / (max-min) + 240);
            }

            //get Value
            value = max;

            //get Saturation
            if(max == 0){
                saturation = 0;
            }else{
                saturation = (max - min) / max;
            }

            hsv = [Math.round(hue), Math.round(saturation * 100), Math.round(value / 255 * 100)];
            return hsv;

        }

        public static function HSVtoRGB(h:Number, s:Number, v:Number):Array{
            var r:Number = 0;
            var g:Number = 0;
            var b:Number = 0;
            var rgb:Array = [];

            var tempS:Number = s / 100;
            var tempV:Number = v / 100;

            var hi:int = Math.floor(h/60) % 6;
            var f:Number = h/60 - Math.floor(h/60);
            var p:Number = (tempV * (1 - tempS));
            var q:Number = (tempV * (1 - f * tempS));
            var t:Number = (tempV * (1 - (1 - f) * tempS));

            switch(hi){
                case 0: r = tempV; g = t; b = p; break;
                case 1: r = q; g = tempV; b = p; break;
                case 2: r = p; g = tempV; b = t; break;
                case 3: r = p; g = q; b = tempV; break;
                case 4: r = t; g = p; b = tempV; break;
                case 5: r = tempV; g = p; b = q; break;
            }

            rgb = [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
            return rgb;
        }
        
        public static function HSVtoHEX( h:Number, s:Number, v:Number ):uint
        {
            var rgb:Array = ColorUtil.HSVtoRGB( h, s, v );
            return ColorUtil.RGBToHex( rgb[0], rgb[1], rgb[2] );
        }
    }
    
}