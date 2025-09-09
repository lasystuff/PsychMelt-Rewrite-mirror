package melt.scripting;

interface IFunkinScript
{
	public function callFunction(func:String, ?args:Array<Dynamic>):Dynamic;
	public function getVar(variable:String):Dynamic;
	public function setVar(variable:String, data:Dynamic):Void;
	public function existsVar(variable:String):Bool;

	public function stop():Void;
}