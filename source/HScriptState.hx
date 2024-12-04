package;

import flixel.FlxG;

class HScriptState extends MusicBeatState
{
	public static var script:FunkinHScript;

	override public function new(state:String)
	{
		super();
		script = new FunkinHScript(Paths.modFolders('states/$state.hx'), this);
	}

	override public function create()
	{
		super.create();
		callOnHScript("createPost");
	}

	override public function update(elapsed:Float)
	{
		callOnHScript("update", [elapsed]);

		super.update(elapsed);

		callOnHScript("updatePost", [elapsed]);
	}

	override public function beatHit()
	{
		super.beatHit();
		callOnHScript("beatHit");
	}


	override public function callOnHScript(func:String, ?args:Dynamic)
	{
		if (script != null)
			script.callFunc(func, args);
	}
}
