package;

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
        importClass("Paths");
        importClass("Character");
        importClass("CoolUtil");
        importClass("MusicBeatState");
        importClass("Conductor");
        importClass("PlayState");
        importClass("Math");
        importClass("StringTools");
        importClass("BGSprite");
        importClass("Std");

        variables.set('add', flixel.FlxG.state.add);
		variables.set('insert', flixel.FlxG.state.insert);
		variables.set('remove', flixel.FlxG.state.remove);
    }

    public function stop(){
        //idk how i stop it please help please
        variables.clear();
    }
}