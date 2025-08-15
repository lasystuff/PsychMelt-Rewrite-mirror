package melt.gameplay.objects;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class CharacterGhost extends FlxSprite
{
	public var parent(default, set):Character;
	var alphaTween:FlxTween;

	override public function new(parent:Character)
	{
		super();

		this.parent = parent;
		this.alpha = 0;
	}

	function set_parent(value:Character):Character
	{
		parent = value;

		frames = AssetUtil.getSparrow(parent.imageFile);
		animation.copyFrom(parent.animation);
		color = FlxColor.fromRGB(parent.healthColorArray[0], parent.healthColorArray[1], parent.healthColorArray[2]);
		
		updateHitbox();
		return parent;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		flipX = parent.flipX;
		setPosition(parent.x, parent.y);
		scale.set(parent.scale.x, parent.scale.y);
	}

	public function play(anim:String):Void
	{
		if (parent.animOffsets.exists(anim))
		{
			if (alphaTween != null)
				alphaTween.cancel();
			this.alpha = parent.alpha - 0.4;
			var animOff = parent.animOffsets.get(anim);
			offset.set(animOff[0], animOff[1]);

			animation.play(anim, true);

			alphaTween = FlxTween.tween(this, {alpha: 0}, (Conductor.crochet / 1000)*1.5, {ease: FlxEase.quadOut});
		}
	}
}