package;


import lime.graphics.Image;
import lime.graphics.opengl.GL;
import lime.math.Rectangle;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.events.Event;


class Main extends Sprite {


	private var renderIndex = 0;
	private var renderSequence = new Array<Sprite->(Image->Bool)> ();
	private var testIndex = 0;
	private var testSequence = new Array<Image->Bool> ();
	private var testNames = new Array<String> ();

	private var maxTestNameLength = 0;
	private var numFailed = 0;
	private var pauseFrames = 0;


	public function new () {
		
		super ();

		stage.addEventListener (Event.ENTER_FRAME, onEnterFrame);

		var fields = Type.getClassFields (Tests);
		renderSequence.push (initialTest);
		for (f in fields) {
			if (!StringTools.startsWith (f, "test")) {
				continue;
			}
			renderSequence.push (Reflect.field(Tests, f));
			testNames.push (f);
			if (f.length > maxTestNameLength) {
				maxTestNameLength = f.length;
			}
		}

	}


	private function onEnterFrame (event:Event):Void {

		if (pauseFrames > 0) {
			pauseFrames--;
			return;
		}

		var image = new Image (null, 0, 0, 256, 256);

		switch (stage.window.renderer.context) {

			case OPENGL(ctx):
				ctx.readPixels (0, 0, 256, 256, GL.RGBA, GL.UNSIGNED_BYTE, image.buffer.data);
				transformOpenGLImage (image);

			//case CONSOLE(ctx):

			default:
				throw "renderer type not yet supported";

		}

		if (renderIndex < renderSequence.length) {

			removeChildren ();
			var sprite = new Sprite ();
			addChild (sprite);

			testSequence.push (renderSequence[renderIndex++] (sprite));

		}

		if (testIndex < testSequence.length) {

			var result = testSequence[testIndex] (image);
			if (testIndex == 0) {
				// initialTest determines how many frames before we test against backbuffer
				if (result == true) {
					testIndex++;
				}
			} else {
				var name = testNames[testIndex - 1];
				var status = (result == true) ? " OK" : " FAILED";
				Sys.println (StringTools.rpad (name, " ", maxTestNameLength) + status);
				testIndex++;
				if (result != true) {
					numFailed++;
				}
				//pauseFrames = 60;
			}

		} else {

			Sys.exit ((numFailed > 0) ? 1 : 0);

		}
		
	}


	// transformOpenGLImage transforms the image from GL-space, where (0, 0) is at
	// the bottom-left of the image, into an image where (0, 0) is at the
	// top-left of the image.
	private static function transformOpenGLImage (image:Image):Void {

		var rect0 = new Rectangle (0, 0, image.width, 1);
		var rect1 = new Rectangle (0, 0, image.width, 1);

		for (y in 0...Std.int(image.height/2)) {

			rect0.y = y;
			rect1.y = image.height - y - 1;

			var bytes0 = image.getPixels (rect0);
			var bytes1 = image.getPixels (rect1);
			image.setPixels(rect0, bytes1);
			image.setPixels(rect1, bytes0);

		}

	}


	// initialTest is the first test that is run, and is used to determine how
	// many frames we should wait after rendering before capturing the
	// backbuffer and validating the results.
	private static function initialTest (sprite:Sprite):Image->Bool {
	
		sprite.graphics.beginFill (0xcc00ff);
		sprite.graphics.drawRect (0, 0, 256, 256);

		return function (image:Image):Bool {
			var color = image.getPixel (10, 10) & 0xffffff00;
			if (color == 0xcc00ff00) {
				return true;
			} else {
				return false;
			}
		}
		
	}


}
