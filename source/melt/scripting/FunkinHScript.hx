package melt.scripting;

import rulescript.parsers.HxParser;
import sys.io.File;

using StringTools;

class FunkinHScript extends FunkinRule
{
    public function new(path:String, parentInstance:Dynamic = null, skipCreate:Bool = false){
        super(path, parentInstance, skipCreate);
        scriptType = "HScript";

        rule.parser = new HxParser();
        rule.getParser(HxParser).allowAll();

        var scriptToRun:String = File.getContent(path);
		execute(scriptToRun, skipCreate);
    }
}