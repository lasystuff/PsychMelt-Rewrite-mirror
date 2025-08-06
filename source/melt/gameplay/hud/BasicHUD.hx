package melt.gameplay.hud;

// basically v-slice ui
import flixel.group.FlxGroup;
import sys.FileSystem;
import melt.scripting.*;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxStringUtil;

class BasicHUD extends FlxGroup
{
	override public function new()
	{
		super();
	}

	public function reloadHealthBar(){}

	override public function update(elapsed:Float){}

	public function startSong(){}
	public function beatHit(beat:Int){}

	public function changeIcon(target:Character, name:String){}

	public function updateScore(miss:Bool){}
}