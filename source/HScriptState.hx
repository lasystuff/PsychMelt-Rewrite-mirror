package;

import flixel.FlxG;

class HScriptState extends MusicBeatState
{
	public var state:String = "";
	public static var script:FunkinHScript;

	override public function new(state:String)
	{
		super();
		this.state = state;
	}

	override public function create()
	{
		super.create();
		script = new FunkinHScript(Paths.modFolders('states/$state.hx'), this);
		
		callOnHScript("createPost");
	}

	override public function update(elapsed:Float)
	{
		if (controls.RESET)
			FlxG.switchState(new HScriptState(state));

		callOnHScript("update", [elapsed]);

		super.update(elapsed);
		//HOT RELOADING SHIT

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
