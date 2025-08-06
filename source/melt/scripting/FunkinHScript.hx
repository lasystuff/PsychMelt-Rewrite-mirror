package melt.scripting;

import sys.io.File;

import rulescript.*;
import rulescript.parsers.*;

using StringTools;

class FunkinHScript
{
    private var rule:RuleScript;

    public function new(path:String, ?parentInstance:Dynamic = null, skipCreate:Bool = true){
    
        rule = new RuleScript(new HxParser());
        rule.scriptName = path;
        rule.getParser(HxParser).allowAll();
        // rule.errorHandler = onError;
        
        var scriptToRun:String = File.getContent(path);
        rule.tryExecute(scriptToRun);

        if (parentInstance != null)
            rule.superInstance = parentInstance;

        if (!skipCreate)
            callFunc("create");
    }

    //call Function in Interp
    public function callFunc(func:String, ?args:Array<Dynamic>):Dynamic {
		if (rule.variables.exists(func)) {
			if (args == null){ args = []; }

			try {
				return Reflect.callMethod(null, rule.variables.get(func), args);
			}
			catch(e){
				trace(e.message);
            }
		}
		return null;
	}

    public function stop(){
        //idk how i stop it please help please
        rule.interp = null;
        rule.variables.clear();
    }
}