package;

import flixel.FlxSprite;

using StringTools;

class HealthIcon extends FlxSprite {
    public var sprTracker:FlxSprite;
    private var isPlayer:Bool;
    public var char:String;

    private var iconOffsets:Array<Float> = [0, 0, 0];

    public function new(char:String = 'bf', isPlayer:Bool = false, ?allowGPU:Bool = true) {
        super();
        this.isPlayer = isPlayer;
        
        changeIcon(char);
        scrollFactor.set();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (sprTracker != null) {
            setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y - 30);
        }
    }

    public function changeIcon(char:String):Void {
        if (this.char != char) {
            this.char = char;
            
            var graphic = Paths.image(getIconPath(char));
            loadGraphic(graphic, true, Math.floor(graphic.width / 3), Math.floor(graphic.height));
            super.updateHitbox();

            animation.add(char, [0, 1, 2], 0, false, isPlayer);
            animation.play(char);

            antialiasing = char.endsWith('-pixel') ? false : ClientPrefs.globalAntialiasing;
        }
    }

	public function getCharacter():String {
		return char;
	}

    public function getIconPath(char:String):String {
        var name:String = 'icons/' + char;
        if (!Paths.fileExists('images/' + name + '.png', IMAGE)) {
            name = 'icons/icon-' + char; // Older versions of psych engine's support
        }
        if (!Paths.fileExists('images/' + name + '.png', IMAGE)) {
            name = 'icons/icon-face'; // Prevents crash from missing icon
        }
        return name;
    }
}