package melt.scripting;

import sys.io.File;
import flixel.util.FlxColor;

import rulescript.*;
import rulescript.parsers.*;

import melt.scripting.extension.RuleScriptInterpEx;

interface IFunkinScript
{
	public var scriptType:String;

	public function callFunction(func:String, ?args:Array<Dynamic>):Dynamic
	public function getVar(variable:String):Dynamic
	public function setVar(variable:String, data:Dynamic):Dynamic
	public function existsVar(variable:String):Bool

	public function stop():Void
}