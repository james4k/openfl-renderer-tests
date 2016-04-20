package;


import lime.graphics.Image;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;


class Tests {


	private static function testDrawRectSinglePixel (sprite:Sprite):Image->Bool {

		var C = 0x4410ff00;
	
		sprite.graphics.beginFill (C >> 8);
		sprite.graphics.drawRect (50, 50, 1, 1);

		return function (image:Image):Bool {
			return (
				((image.getPixel (50, 50) & 0xffffff00) == C) &&
				((image.getPixel (49, 50) & 0xffffff00) != C) &&
				((image.getPixel (51, 50) & 0xffffff00) != C) &&
				((image.getPixel (50, 49) & 0xffffff00) != C) &&
				((image.getPixel (50, 51) & 0xffffff00) != C)
			);
		}
		
	}


	private static function testScrollRectBitmapPosition (sprite:Sprite):Image->Bool {
		
		var C = 0xaa557f00;

		var child = new Bitmap (new BitmapData (1, 1, false, C >> 8));
		child.x = 50;
		child.y = 50;

		sprite.x = 10;
		sprite.y = 10;
		sprite.scrollRect = new flash.geom.Rectangle (10, 10, 100, 100);
		sprite.addChild (child);

		return function (image:Image):Bool {
			return (
				((image.getPixel (50, 50) & 0xffffff00) == C) &&
				((image.getPixel (49, 50) & 0xffffff00) != C) &&
				((image.getPixel (51, 50) & 0xffffff00) != C) &&
				((image.getPixel (50, 49) & 0xffffff00) != C) &&
				((image.getPixel (50, 51) & 0xffffff00) != C)
			);
		}
		
	}


	private static function testScrollRectBitmapScissor (sprite:Sprite):Image->Bool {
		
		var C = 0x99ff0400;

		var child = new Bitmap (new BitmapData (110, 110, false, C >> 8));
		child.x = -10;
		child.y = -10;

		sprite.x = 10;
		sprite.y = 10;
		sprite.scrollRect = new flash.geom.Rectangle (0, 0, 90, 90);
		sprite.addChild (child);

		return function (image:Image):Bool {
			var tl = ((image.getPixel ( 10,  10) & 0xffffff00) == C) &&
			         ((image.getPixel (  9,  10) & 0xffffff00) != C) &&
			         ((image.getPixel ( 10,   9) & 0xffffff00) != C);
			var tr = ((image.getPixel ( 99,  10) & 0xffffff00) == C) &&
			         ((image.getPixel (100,  10) & 0xffffff00) != C) &&
			         ((image.getPixel ( 99,   9) & 0xffffff00) != C);
			var br = ((image.getPixel ( 99,  99) & 0xffffff00) == C) &&
			         ((image.getPixel (100,  99) & 0xffffff00) != C) &&
			         ((image.getPixel ( 99, 100) & 0xffffff00) != C);
			var bl = ((image.getPixel ( 10,  99) & 0xffffff00) == C) &&
			         ((image.getPixel (  9,  99) & 0xffffff00) != C) &&
			         ((image.getPixel ( 10, 100) & 0xffffff00) != C);
			return (tl && tr && br && bl);
		}
		
	}


	private static function testScrollRectSpritePosition (sprite:Sprite):Image->Bool {
		
		var C = 0xaa557f00;
	
		var child = new Sprite ();
		child.graphics.beginFill (C >> 8);
		child.graphics.drawRect (50, 50, 1, 1);

		sprite.x = 10;
		sprite.y = 10;
		sprite.scrollRect = new flash.geom.Rectangle (10, 10, 100, 100);
		sprite.addChild (child);

		return function (image:Image):Bool {
			return (
				((image.getPixel (50, 50) & 0xffffff00) == C) &&
				((image.getPixel (49, 50) & 0xffffff00) != C) &&
				((image.getPixel (51, 50) & 0xffffff00) != C) &&
				((image.getPixel (50, 49) & 0xffffff00) != C) &&
				((image.getPixel (50, 51) & 0xffffff00) != C)
			);
		}
		
	}


	private static function testScrollRectSpriteScissor (sprite:Sprite):Image->Bool {
		
		var C = 0x99ff0400;
	
		var child = new Sprite ();
		child.graphics.beginFill (C >> 8);
		child.graphics.drawRect (-10, -10, 110, 110);

		sprite.x = 10;
		sprite.y = 10;
		sprite.scrollRect = new flash.geom.Rectangle (0, 0, 90, 90);
		sprite.addChild (child);

		return function (image:Image):Bool {
			var tl = ((image.getPixel ( 10,  10) & 0xffffff00) == C) &&
			         ((image.getPixel (  9,  10) & 0xffffff00) != C) &&
			         ((image.getPixel ( 10,   9) & 0xffffff00) != C);
			var tr = ((image.getPixel ( 99,  10) & 0xffffff00) == C) &&
			         ((image.getPixel (100,  10) & 0xffffff00) != C) &&
			         ((image.getPixel ( 99,   9) & 0xffffff00) != C);
			var br = ((image.getPixel ( 99,  99) & 0xffffff00) == C) &&
			         ((image.getPixel (100,  99) & 0xffffff00) != C) &&
			         ((image.getPixel ( 99, 100) & 0xffffff00) != C);
			var bl = ((image.getPixel ( 10,  99) & 0xffffff00) == C) &&
			         ((image.getPixel (  9,  99) & 0xffffff00) != C) &&
			         ((image.getPixel ( 10, 100) & 0xffffff00) != C);
			return (tl && tr && br && bl);
		}
		
	}


}
