package melt.gameplay.hud;

// heavily based on Andromeda and Yoshi
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxStringUtil;
import flixel.tweens.FlxEase;

class MeltHUD extends VanillaHUD
{
	public var grade:String = "N/A";

	public static final gradeConditions:Map<Int, String> = [
		100 => "☆☆☆☆",
		99 => "☆☆☆",
		98 => "☆☆",
		96 => "☆",
		94 => "S+",
		92 => "S",
		89 => "S-",
		86 => "A+",
		83 => "A",
		80 => "A-",
		76 => "B+",
		72 => "B",
		68 => "B-",
		64 => "C+",
		60 => "C",
		55 => "C-",
		50 => "D+",
		45 => "D",
	];

	override public function new()
	{
		super();

		scoreTxt = new FlxText(0, healthBarBG.y + 36, FlxG.width, "", 18);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		add(scoreTxt);
	}

	override public function reloadHealthBar()
	{
		var dad = PlayState.instance.dad;
		var boyfriend = PlayState.instance.boyfriend;

		healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
			FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));

		healthBar.updateBar();
	}
	
	override public function updateScore(miss:Bool)
	{
		if (PlayState.instance.totalPlayed > 0)
		{
			var acc = Highscore.floorDecimal(PlayState.instance.songAccuracy * 100, 2);

			var highest:Float = 0;
			for (gradeAcc in gradeConditions.keys())
			{
				if (acc >= gradeAcc && gradeAcc >= highest)
				{
					highest = gradeAcc;
					grade = gradeConditions.get(gradeAcc);
				}
			}
		}

		scoreTxt.text = 'Score: ' + FlxStringUtil.formatMoney(PlayState.instance.songScore, false);
		scoreTxt.text += ' • Misses: ' + FlxStringUtil.formatMoney(PlayState.instance.songMisses, false);
		scoreTxt.text += ' • Accuracy: ' + Highscore.floorDecimal(PlayState.instance.songAccuracy * 100, 2) + '%';
		scoreTxt.text += ' • ' + grade;
	}
}
