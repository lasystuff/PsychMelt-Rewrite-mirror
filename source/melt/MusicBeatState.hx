package melt;

import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxState;
import melt.scripting.*;
import melt.gameplay.*;
import melt.Conductor;

using StringTools;

class MusicBeatState extends FlxUIState
{
	public var scriptArray:Array<FunkinRule> = [];
	
	//states that don't allow scripting/overriding by hscripts!
	static final excludeStates:Array<Dynamic> = [LoadingState, melt.gameplay.PlayState, ScriptedState];

	private var curSection:Int = 0;
	private var stepsToDo:Int = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;
	public var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create() {
		var skip:Bool = FlxTransitionableState.skipNextTransOut;

		super.create();

		if(!skip) {
			openSubState(new CustomFadeTransition(0.6, true));
		}
		FlxTransitionableState.skipNextTransOut = false;

		if (!excludeStates.contains(Type.getClass(this)))
		{
			final statePath = Type.getClassName(Type.getClass(this)).split(".");
			final stateString = statePath[statePath.length - 1];

			if (AssetUtil.exists('states/$stateString.hx') && !excludeStates.contains(stateString))
				scriptArray.push(new FunkinHScript(Paths.hscript(stateString, "states"), this));
			if (AssetUtil.exists('states/$stateString.lua') && !excludeStates.contains(stateString))
				scriptArray.push(new FunkinHScript(Paths.hscript(stateString, "states"), this));	
		}
	}

	override function update(elapsed:Float)
	{
		callOnScripts("onUpdate", [elapsed]);
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

		setOnScripts('curBpm', Conductor.bpm);
		setOnScripts('crochet', Conductor.crochet);
		setOnScripts('stepCrochet', Conductor.stepCrochet);

		setOnScripts('curStep', curStep);
		setOnScripts('curBeat', curBeat);

		setOnScripts('curDecStep', curDecStep);
		setOnScripts('curDecBeat', curDecBeat);

		if(FlxG.save.data != null) FlxG.save.data.fullscreen = FlxG.fullscreen;

		super.update(elapsed);
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
		callOnScripts("onStepHit");
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		callOnScripts("onBeatHit");
	}

	public function sectionHit():Void
	{
		callOnScripts("onSectionHit");
	}

	function getBeatsOnSection()
	{
		var val:Null<Float> = 4;
		if(PlayState.SONG != null && PlayState.SONG.notes[curSection] != null) val = PlayState.SONG.notes[curSection].sectionBeats;
		return val == null ? 4 : val;
	}

	public static function switchState(nextState:FlxState, ?noOverride:Bool = false) {
		if (!noOverride && !excludeStates.contains(Type.getClass(nextState)))
		{
			final statePath = Type.getClassName(Type.getClass(nextState)).split(".");
			final stateString = statePath[statePath.length - 1];

			if ((AssetUtil.exists('states/override/$stateString.hx') || AssetUtil.exists('states/override/$stateString.lua')) && !excludeStates.contains(stateString))
				nextState = new ScriptedState('override/$stateString');
		}
		FlxG.switchState(nextState);
	}

	public static function switchCustomState(path:String)
	{
		FlxG.switchState(new ScriptedState(path));
	}

	public function setOnScripts(variable:String, arg:Dynamic)
	{
		for (script in scriptArray)
		{
			script.setVar(variable, arg);
		}
	}

	public function callOnScripts(func:String, ?args:Dynamic):Dynamic
	{
		var returnThing:Dynamic = FunkinLua.Function_Continue;
		for (script in scriptArray)
		{
			var scriptThing = script.callFunc(func, args);
			if (scriptThing == FunkinLua.Function_Stop)
				returnThing = scriptThing;
		}
		return returnThing;
	}

	public static function resetState() {
		FlxG.switchState(FlxG.state);
	}

	override public function destroy() {
		callOnScripts("onDestroy");
		for (script in scriptArray)
			script = null;
		super.destroy();
	}
}