package melt.gameplay.objects;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class BGSprite extends FlxSprite
{
	public function new(image:String, x:Float = 0, y:Float = 0, ?scrollX:Float = 1, ?scrollY:Float = 1, ?animArray:Array<AnimData> = null)
	{
		super(x, y);

		if (animArray != null && animArray.length > 0)
		{
			frames = AssetUtil.getSparrow(image);
			for (anim in animArray)
			{
				animation.addByPrefix(anim.name, anim.prefix, anim.fps, anim.loop);
			}

			animation.play(animArray[0].name);
		}
		else
		{
			if (image != null)
				loadGraphic(Paths.image(image));
			active = false;
		}
		scrollFactor.set(scrollX, scrollY);
		antialiasing = ClientPrefs.globalAntialiasing;
	}
}

@:structInit class AnimData
{
	public var name:String;
	public var prefix:String;
	public var offset:Array<Float> = [0, 0];

	public var fps:Float = 24;
	public var loop:Bool = false;
}