package melt;

import flixel.util.FlxSave;
import flixel.FlxState;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.addons.transition.FlxTransitionableState;
import lime.app.Application;
import melt.data.WeekData;
import rulescript.RuleScript;
import melt.Discord.DiscordClient;


class InitState extends FlxState
{
	override public function create():Void
	{
		super.create();
		if (FlxG.save.data != null && FlxG.save.data.fullscreen)
		{
			FlxG.fullscreen = FlxG.save.data.fullscreen;
			// trace('LOADED FULLSCREEN SETTING!!');
		}

		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end
		// Just to load a mod on start up if ya got one. For mods that change the menu music and bg
		WeekData.loadTheFirstEnabledMod();

		PlayerSettings.init();

		FlxG.save.bind('funkin', 'ninjamuffin99');

		ClientPrefs.loadPrefs();

		Highscore.load();

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;

		#if desktop
		if (!DiscordClient.isInitialized)
		{
			DiscordClient.initialize();
			Application.current.onExit.add(function(exitCode)
			{
				DiscordClient.shutdown();
			});
		}
		#end

		setRuleScriptImports();
		
		MusicBeatState.switchState(new TitleState());
	}

	function setRuleScriptImports()
	{
		RuleScript.defaultImports[""].set("Paths", Paths);
        RuleScript.defaultImports[""].set("Character", Character);
        RuleScript.defaultImports[""].set("CoolUtil", CoolUtil);
        RuleScript.defaultImports[""].set("MusicBeatState", MusicBeatState);
        RuleScript.defaultImports[""].set("Conductor", Conductor);
        RuleScript.defaultImports[""].set("PlayState", melt.gameplay.PlayState);
        RuleScript.defaultImports[""].set("BGSprite", melt.gameplay.objects.BGSprite);
		RuleScript.defaultImports[""].set("FunkinLua", melt.scripting.FunkinLua);
	}
}