package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.FlxBasic;

class MusicBeatState extends FlxUIState
{
	public static var script:FunkinHScript;
	
	//states that don't allow scripting/overriding by hscripts!
	static final excludeStates = ["LoadingState", "PlayState", "HScriptState"];

	private var curSection:Int = 0;
	private var stepsToDo:Int = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;
	public var controls(get, never):Controls;

	public static var camBeat:FlxCamera;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create() {
		var skip:Bool = FlxTransitionableState.skipNextTransOut;

		//State Script!
		final statePath = Type.getClassName(Type.getClass(this)).split(".");
		final stateString = statePath[statePath.length - 1];

		if (sys.FileSystem.exists(Paths.modFolders('states/$stateString.hx')) && !excludeStates.contains(stateString))
			script = new FunkinHScript(Paths.modFolders('states/$stateString.hx'), this);

		super.create();

		if(!skip) {
			openSubState(new CustomFadeTransition(0.6, true));
		}
		FlxTransitionableState.skipNextTransOut = false;
	}

	override function update(elapsed:Float)
	{
		callOnHScript("update", [elapsed]);
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
		{
			if(curStep > 0)
				stepHit();

			if(PlayState.SONG != null)
			{
				if (oldStep < curStep)
					updateSection();
				else
					rollbackSection();
			}
		}

		if(FlxG.save.data != null) FlxG.save.data.fullscreen = FlxG.fullscreen;

		super.update(elapsed);
		callOnHScript("updatePost", [elapsed]);
	}

	private function updateSection():Void
	{
		if(stepsToDo < 1) stepsToDo = Math.round(getBeatsOnSection() * 4);
		while(curStep >= stepsToDo)
		{
			curSection++;
			var beats:Float = getBeatsOnSection();
			stepsToDo += Math.round(beats * 4);
			sectionHit();
		}
	}

	private function rollbackSection():Void
	{
		if(curStep < 0) return;

		var lastSection:Int = curSection;
		curSection = 0;
		stepsToDo = 0;
		for (i in 0...PlayState.SONG.notes.length)
		{
			if (PlayState.SONG.notes[i] != null)
			{
				stepsToDo += Math.round(getBeatsOnSection() * 4);
				if(stepsToDo > curStep) break;
				
				curSection++;
			}
		}

		if(curSection > lastSection) sectionHit();
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep/4;
	}

	private function updateCurStep():Void
	{
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - ClientPrefs.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}

	override function startOutro(onOutroComplete:()->Void):Void
	{
		if (!FlxTransitionableState.skipNextTransIn)
		{
			FlxG.state.openSubState(new CustomFadeTransition(0.6, false));

			CustomFadeTransition.finishCallback = onOutroComplete;

			return;
		}

		FlxTransitionableState.skipNextTransIn = false;

		onOutroComplete();
	}

	public static function getState():MusicBeatState
	{
		return cast (FlxG.state, MusicBeatState);
	}

	public function stepHit():Void
	{
		callOnHScript("stepHit");
		if (curStep % 4 == 0)
			beatHit();
	}

	function callOnHScript(func:String, ?args:Dynamic):Dynamic
	{
		if (script != null)
			return script.callFunc(func, args);
		
		return null;
	}

	public function beatHit():Void
	{
		callOnHScript("beatHit");
	}

	public function sectionHit():Void
	{
		callOnHScript("sectionHit");
	}

	function getBeatsOnSection()
	{
		var val:Null<Float> = 4;
		if(PlayState.SONG != null && PlayState.SONG.notes[curSection] != null) val = PlayState.SONG.notes[curSection].sectionBeats;
		return val == null ? 4 : val;
	}

	public static function switchState(nextState:FlxState, ?noOverride:Bool = false) {
		
		final statePath = Type.getClassName(Type.getClass(nextState)).split(".");
		final stateString = statePath[statePath.length - 1];

		if (sys.FileSystem.exists(Paths.modFolders('states/override/$stateString.hx')) && !excludeStates.contains(stateString))
			nextState = new HScriptState('override/$stateString');

		FlxG.switchState(nextState);
	}

	public static function switchCustomState(nextState:String)
	{
		if (sys.FileSystem.exists(Paths.modFolders('states/$nextState.hx')) && !excludeStates.contains(nextState))
			FlxG.switchState(new HScriptState(nextState));
	}

	public static function resetState() {
		FlxG.switchState(FlxG.state);
	}

	override public function destroy() {
		callOnHScript("destroy");
		script = null;
		super.destroy();
	}
}
