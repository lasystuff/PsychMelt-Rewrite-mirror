package melt.scripting;

import sys.io.File;

import hscript.Parser;
import hscript.Interp;

using StringTools;

class FunkinHScript extends Interp
{

    override public function new(path:String, ?parentInstance:Dynamic){
        super();
        setVariables();

        var parser = new Parser();
        parser.allowJSON = parser.allowMetadata = parser.allowTypes = true;
        
        var scriptToRun:String = File.getContent(path);

        if (parentInstance != null)
            scriptObject = parentInstance;
        
        execute(parser.parseString(scriptToRun));

        callFunc("create");
    }

    //call Function in Interp
    public function callFunc(func:String, ?args:Array<Dynamic>):Dynamic {
		if (variables.exists(func)) {
			if (args == null){ args = []; }

			try {
				return Reflect.callMethod(null, variables.get(func), args);
			}
			catch(e){
				trace(e.message);
            }
		}
		return null;
	}

    //not needed cuz we re using hscript-improved but keep this for shortcut for setVariables
    public function importClass(classPath:String) {
        var className:String = classPath.split(".")[classPath.split(".").length - 1];

        if (variables.exists(className)){
            trace(className + "already imported!");
            return;
        }

        variables.set(className, Type.resolveClass(classPath));
	}

    //import some default classes
    private function setVariables(){
        importClass("melt.Paths");
        importClass("melt.Character");
        importClass("melt.CoolUtil");
        importClass("melt.MusicBeatState");
        importClass("melt.Conductor");
        importClass("melt.gameplay.PlayState");
        importClass("melt.Math");
        importClass("StringTools");
        importClass("melt.BGSprite");
        importClass("Std");

        variables.set('add', flixel.FlxG.state.add);
		variables.set('insert', flixel.FlxG.state.insert);
		variables.set('remove', flixel.FlxG.state.remove);

        //aw... i remember i was an lua "coder"
        variables.set('Function_Stop', FunkinLua.Function_Stop);
		variables.set('Function_Continue', FunkinLua.Function_Continue);
    }

    public function stop(){
        //idk how i stop it please help please
        variables.clear();
    }
}