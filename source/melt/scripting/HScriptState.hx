package melt.scripting;

import flixel.FlxG;

class HScriptState extends MusicBeatState
{
	public var state:String = "";
	public static var staticVar:Map<String, Map<Dynamic, Dynamic>> = [];

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

		scriptArray.push(new FunkinHScript(Paths.modFolders('states/$state.hx'), this));
		setOnScripts("global", staticVar[state]);
		
		callOnScripts("onCreatePost");
	}

	override public function update(elapsed:Float)
	{
		if (controls.RESET)
			FlxG.switchState(new HScriptState(state));

		super.update(elapsed);
	}
}
