package melt.scripting;

class ScriptedState extends MusicBeatState
{
	public static var state:String = "";

    public function new(_state:String){
		super();
		state = _state;

		if (AssetUtil.exists('states/$state.hx'))
			scriptArray.push(new FunkinHScript(Paths.hscript(state, "states"), this));
		if (AssetUtil.exists('states/$state.lua'))
			scriptArray.push(new FunkinHScript(Paths.lua(state, "states"), this));
    }
}