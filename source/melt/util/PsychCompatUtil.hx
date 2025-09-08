package melt.util;

import melt.scripting.FunkinRule;
import melt.gameplay.PlayState;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

using StringTools;

class PsychCompatUtil
{
	// dummy functions (yet)
	public static final COMPAT_DUMMY_FUNCTIONS:Array<String> = [
		"setPropertyFromGroup",
		"getProperty",
		"getPropertyFromGroup",
		"getPropertyFromClass",
		"initLuaShader",
		"setSpriteShader",
		"setShaderFloat",
		"instanceArg"
	];

	public static function buildVariables(script:IFunkinScript)
	{
		script.setVar("makeLuaSprite", function(tag:String, ?image:String = null, ?x:Float = 0, ?y:Float = 0)
        {
            var spr = new FlxSprite(x, y);
			if (Paths.image(image) != null)
				spr.loadGraphic(Paths.image(image));
			spr.antialiasing = ClientPrefs.globalAntialiasing;
			script.setVar(tag, spr);
        });

		script.setVar("makeAnimatedLuaSprite", function(tag:String, ?image:String = null, ?x:Float = 0, ?y:Float = 0, ?spriteType:String = 'auto')
        {
            var spr = new FlxSprite(x, y);
			if (Paths.xml(image) != null)
				spr.frames = AssetUtil.getSparrow(image);
			spr.antialiasing = ClientPrefs.globalAntialiasing;
			script.setVar(tag, spr);
        });

		script.setVar("addAnimationByPrefix", function(tag:String, name:String, prefix:String, ?framerate:Float = 24, ?loop:Bool = true)
        {
			if (!script.existsVar(tag))
				return;

			cast(script.getVar(tag), FlxSprite).animation.addByPrefix(name, prefix, framerate, loop);
        });

		script.setVar("playAnim", function(tag:String, name:String, ?forced:Bool = false, ?reverse:Bool = false, ?startFrame:Int = 0)
        {
			if (!script.existsVar(tag))
				return;

			cast(script.getVar(tag), FlxSprite).animation.play(name, forced, reverse, startFrame);
        });

		script.setVar("makeGraphic", function(tag:String, ?width:Int = 256, ?height:Int = 256, ?color:String = 'FFFFFF')
		{
			if (script.existsVar(tag))
				cast(script.getVar(tag), FlxSprite).makeGraphic(width, height, FlxColor.fromString(color));
		});
		
		script.setVar("scaleObject", function(tag:String, x:Float, y:Float, ?updateHitbox:Bool = true)
		{
			if (!script.existsVar(tag))
				return;
			
			cast(script.getVar(tag), FlxSprite).scale.set(x, y);
			if (updateHitbox)
				cast(script.getVar(tag), FlxSprite).updateHitbox();
		});

		script.setVar("setScrollFactor", function(tag:String, scrollX:Float, scrollY:Float)
		{
			if (!script.existsVar(tag))
				return;
			
			cast(script.getVar(tag), FlxSprite).scrollFactor.set(scrollX, scrollY);
		});

		script.setVar("screenCenter", function(tag:String, ?axis:String = "xy")
		{
			if (!script.existsVar(tag))
				return;
			
			var target = cast(script.getVar(tag), FlxSprite);
			switch(axis.toLowerCase())
			{
				case "x":
					target.screenCenter(X);
				case "y":
					target.screenCenter(XY);
				default:
					target.screenCenter();
			}
		});

		script.setVar("setBlendMode", function(obj:String, blend:String = '')
		{
			if (!script.existsVar(obj))
				return;
			script.getVar(obj).blend = blendModeFromString(blend);
		});

		script.setVar("updateHitbox", function(tag:String)
		{
			if (!script.existsVar(tag))
				return;
			cast(script.getVar(tag), FlxSprite).updateHitbox();
		});

		script.setVar("addLuaSprite", function(tag:String, ?inFront:Bool = false)
		{
			if (!script.existsVar(tag))
				return;

			var target = cast(script.getVar(tag), FlxSprite);
			if (PlayState.instance != null && !inFront)
				if (!inFront)
					PlayState.instance.stage.add(target);
				else
					PlayState.instance.stage.foreground.add(target);
			else
				FlxG.state.add(target);
		});

		script.setVar("setProperty", function(prop:String, data:Dynamic)
		{
			setVarPsychLua(null, prop, data);
		});
		script.setVar("setPropertyFromClass", function(cls:String, prop:String, data:Dynamic)
		{
			setVarPsychLua(Type.resolveClass(cls), prop, data);
		});

        // dummy functions (yet)
        for (dummy in COMPAT_DUMMY_FUNCTIONS)
            script.setVar(dummy, function(?_arg0, ?_arg0, ?_arg0, ?_arg0, ?_arg0, ?_arg0){return null;});
	}



	// shitty infamous psychlua funcs
	private static function setVarPsychLua(?parent:Dynamic, path:String, value:Dynamic, ?script:FunkinRule):Void
	{
		var killMe:Array<String> = path.split('.');
		if (parent == null && script != null)
		{
			@:privateAccess
			if (script.existsVar(killMe[0]))
				parent = script.rule.interp.variables;
			else
				parent = FlxG.state;
		}
		var die:Dynamic = Reflect.getProperty(parent, killMe[0]);

		if(killMe.length > 1) {
			killMe.shift();

			for (i in 0...killMe.length)
			{
				// oh god no
				if (i == killMe.length - 1)
					Reflect.setProperty(die, killMe[i], value);
				else
					die = Reflect.getProperty(die, killMe[i]);
			}
		}
	}

	private static function blendModeFromString(blend:String):openfl.display.BlendMode
	{
		switch(blend.toLowerCase().trim())
		{
			case 'add': return ADD;
			case 'alpha': return ALPHA;
			case 'darken': return DARKEN;
			case 'difference': return DIFFERENCE;
			case 'erase': return ERASE;
			case 'hardlight': return HARDLIGHT;
			case 'invert': return INVERT;
			case 'layer': return LAYER;
			case 'lighten': return LIGHTEN;
			case 'multiply': return MULTIPLY;
			case 'overlay': return OVERLAY;
			case 'screen': return SCREEN;
			case 'shader': return SHADER;
			case 'subtract': return SUBTRACT;
		}
		return NORMAL;
	}
}