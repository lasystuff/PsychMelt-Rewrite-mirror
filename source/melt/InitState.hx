package melt;

import flixel.util.FlxSave;
import flixel.FlxState;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.addons.transition.FlxTransitionableState;
import lime.app.Application;
import melt.data.WeekData;
import melt.Discord.DiscordClient;
import melt.plugin.*;
import flixel.util.FlxColor;
import melt.scripting.ScriptClassManager;


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

		FlxG.mouse.visible = false;
		FlxG.cameras.useBufferLocking = true;

		Content.load();

		PlayerSettings.init();

		FlxG.save.bind('funkin', 'ninjamuffin99');

		ClientPrefs.loadPrefs();

		Highscore.load();

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

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

		DebugTextPlugin.init();
		ScriptClassManager.init();

		// hotreload function
		FlxG.signals.postUpdate.add(function(){
			if (FlxG.keys.justPressed.F5)
			{
				Content.load();
				ScriptClassManager.reloadScriptedClasses();
				FlxG.resetState();
				// melt.cache.ImageCache.clearAll(); HOW??????
			}
		});
		
		MusicBeatState.switchState(new TitleState());
	}
}