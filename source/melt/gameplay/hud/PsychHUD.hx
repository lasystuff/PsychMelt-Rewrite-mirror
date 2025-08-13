package melt.gameplay.hud;

// classic thing
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxStringUtil;
import flixel.tweens.FlxEase;

class PsychHUD extends VanillaHUD
{
	var scoreTxtTween:FlxTween;

	var timeTxt:FlxText;
	private var timeBarBG:AttachedSprite;
	public var timeBar:FlxBar;
	var songPercent:Float = 0;
	var songTime:Float = 0;

	override public function new()
	{
		super();

		scoreTxt = new FlxText(0, healthBarBG.y + 36, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		add(scoreTxt);

		var showTime:Bool = (ClientPrefs.timeBarType != 'Disabled');
		timeTxt = new FlxText(42 + (FlxG.width / 2) - 248, 19, 400, "", 32);
		timeTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.borderSize = 2;
		timeTxt.visible = showTime;
		timeTxt.alpha = 0;
		if (ClientPrefs.downScroll)
			timeTxt.y = FlxG.height - 44;

		if (ClientPrefs.timeBarType == 'Song Name')
			timeTxt.text = PlayState.SONG.song;

		timeBarBG = new AttachedSprite('timeBar');
		timeBarBG.x = timeTxt.x;
		timeBarBG.y = timeTxt.y + (timeTxt.height / 4);
		timeBarBG.scrollFactor.set();
		timeBarBG.visible = showTime;
		timeBarBG.color = FlxColor.BLACK;
		timeBarBG.xAdd = -4;
		timeBarBG.yAdd = -4;
		timeBarBG.alpha = 0;
		add(timeBarBG);

		timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this,
			'songPercent', 0, 1);
		timeBar.scrollFactor.set();
		timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		timeBar.numDivisions = 800; // How much lag this causes?? Should i tone it down to idk, 400 or 200?
		timeBar.visible = showTime;
		timeBar.alpha = 0;
		add(timeBar);
		add(timeTxt);
		timeBarBG.sprTracker = timeBar;

		if (ClientPrefs.timeBarType == 'Song Name')
		{
			timeTxt.size = 24;
			timeTxt.y += 3;
		}
	}

	override public function reloadHealthBar()
	{
		var dad = PlayState.instance.dad;
		var boyfriend = PlayState.instance.boyfriend;

		healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
			FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));

		healthBar.updateBar();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!PlayState.instance.paused)
		{
			songTime += FlxG.game.ticks - FlxG.game.ticks;

			// Interpolation type beat
			if (Conductor.lastSongPos != Conductor.songPosition)
			{
				songTime = (songTime + Conductor.songPosition) / 2;
				Conductor.lastSongPos = Conductor.songPosition;
				// Conductor.songPosition += FlxG.elapsed * 1000;
				// trace('MISSED FRAME');
			}

			if (FlxG.sound.music.playing)
			{
				var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
				if (curTime < 0)
					curTime = 0;
				songPercent = (curTime / FlxG.sound.music.length);

				var songCalc:Float = (FlxG.sound.music.length - curTime);
				if (ClientPrefs.timeBarType == 'Time Elapsed')
					songCalc = curTime;

				var secondsTotal:Int = Math.floor(songCalc / 1000);
				if (secondsTotal < 0)
					secondsTotal = 0;

				if (ClientPrefs.timeBarType != 'Song Name')
					timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
			}
		}

		timeBar.value = songPercent; // die
	}

	override public function updateScore(miss:Bool)
	{	
		scoreTxt.text = 'Score: '
			+ FlxStringUtil.formatMoney(PlayState.instance.songScore, false)
			+ ' | Misses: '
			+ FlxStringUtil.formatMoney(PlayState.instance.songMisses, false)
			+ ' | Rating: '
			+ PlayState.instance.ratingName
			+
			(PlayState.instance.ratingName != '?' ? ' (${Highscore.floorDecimal(PlayState.instance.ratingPercent * 100, 2)}%) - ${PlayState.instance.ratingFC}' : '');

		if (ClientPrefs.scoreZoom && !miss && !PlayState.instance.cpuControlled)
		{
			if (scoreTxtTween != null)
			{
				scoreTxtTween.cancel();
			}
			scoreTxt.scale.x = 1.075;
			scoreTxt.scale.y = 1.075;
			scoreTxtTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {
				onComplete: function(twn:FlxTween)
				{
					scoreTxtTween = null;
				}
			});
		}
	}

	override public function startSong()
	{
		super.startSong();
		FlxTween.tween(timeBarBG, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(timeBar, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
	}
}