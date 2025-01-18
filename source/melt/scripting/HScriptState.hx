package melt.scripting;

import flixel.FlxG;

class HScriptState extends MusicBeatState
{
	public var state:String = "";
	public static var staticVar:Map<String, Map<Dynamic, Dynamic>> = [];
	public static var script:FunkinHScript;

	override public function new(state:String)
	{
		super();
		this.state = state;
	}

	override public function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		
		super.create();

		script = new FunkinHScript(Paths.modFolders('states/$state.hx'), this);
		script.variables.set("global", staticVar[state]);
		
		callOnHScript("createPost");
	}

	override public function update(elapsed:Float)
	{
		if (controls.RESET)
			FlxG.switchState(new HScriptState(state));

		super.update(elapsed);
	}

	override public function destroy()
	{
		script = null;
		super.destroy();
	}


	override public function callOnHScript(func:String, ?args:Dynamic):Dynamic
	{
		if (script != null)
			script.callFunc(func, args);

		return null;
	}
}
