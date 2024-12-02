package;

import flixel.FlxG;

class HScriptState extends MusicBeatState
{
	public var script:FunkinHScript;

	override public function new(state:String)
	{
		super();
		script = new FunkinHScript(Paths.modFolders('states/override/' + state + '.hx'), this);
	}

	override public function create()
	{
		super.create();
		script.callFunc("createPost");
	}

	override public function update(elapsed:Float)
	{
		script.callFunc("update", [elapsed]);
		
		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new StoryMenuState());
		}

		super.update(elapsed);
		script.callFunc("updatePost", [elapsed]);
	}

	override public function beatHit()
	{
		super.beatHit();
		script.callFunc("beatHit");
	}
}
