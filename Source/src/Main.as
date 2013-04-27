package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.media.Camera;
	import flash.media.Video;
	
	/**
	 * ...
	 * @author Miguel Murça
	 */
	public class Main extends Sprite 
	{
		public var cam:Camera;
		public var vid:Video;
		public var bmd:BitmapData;
		public var resizedBmd:BitmapData;
		public var bmp:Bitmap;
		public var threshold:Number = 0.35;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			cam = Camera.getCamera();
			cam.setMode(cam.width, cam.height, cam.fps);
			vid = new Video(stage.stageWidth, stage.stageHeight);
			vid.attachCamera(cam);
			addChild(vid);
			
			bmd = new BitmapData(stage.stageWidth, stage.stageHeight);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, getPixels);
			
		}
		
		public function getPixels(e:Event = null):void
		{
			var tempbmd:BitmapData = new BitmapData(vid.width, vid.height);
			tempbmd.draw(vid);
			
			for (var x:int = 0; x < vid.width; x++)
			{
				for (var y:int = 0; y < vid.height; y++)
				{
					var temprgb:Array = HexRGB(tempbmd.getPixel(x, y));
					if ((Math.sqrt(0.241 * temprgb[0] * temprgb[0] + 0.691 * temprgb[1] * temprgb[1] + 0.068 * temprgb[2] * temprgb[2]) / 225) < threshold)
					{
						bmd.setPixel(x, y, 0x000000);
					}
				}
			}
			
			removeChild(vid);
			bmp = new Bitmap(bmd);
			stage.addChild(bmp);
		}
		
		private function HexRGB(color:uint):Array
		{
			var rgb:Array = [];
			var r:uint = color >> 16 & 0xFF;
			var g:uint = color >> 8 & 0xFF;
			var b:uint = color & 0xFF;
			rgb.push(r, g, b);
			return rgb;
		}
		
	}
	
}