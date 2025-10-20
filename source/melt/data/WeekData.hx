package melt.data;

#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;
import haxe.Json;
import haxe.format.JsonParser;
import melt.gameplay.PlayState;

using StringTools;

class WeekData
{
	public static var weeksLoaded:Map<String, WeekData> = new Map<String, WeekData>();
	public static var weeksList:Array<String> = [];

	// JSON variables
	public var name:String;

	public var songs:Array<Dynamic> = [
		["Bopeebo", "dad", [146, 113, 253]],
		["Fresh", "dad", [146, 113, 253]],
		["Dad Battle", "dad", [146, 113, 253]]
	];
	public var weekCharacters:Array<String> = ['dad', 'bf', 'gf'];
	public var weekBackground:String = "stage";
	public var weekBefore:String = "tutorial";
	public var storyName:String = 'Your New Week';
	public var weekName:String = 'Custom Week';
	public var freeplayColor:Array<Int> = [146, 113, 253];
	public var startUnlocked:Bool = true;
	public var hiddenUntilUnlocked:Bool = false;
	public var hideStoryMode:Bool = false;
	public var hideFreeplay:Bool = false;
	public var difficulties:String = "";

	public function new(){}

	public function stringify():String
	{
		var nameBck = this.name;
		this.name = null;
		var r = Json.stringify(this, "\t");
		this.name = nameBck;
		return r;
	}

	public static function fromJson(path:String)
	{
		var instance = new WeekData();
		var json = Json.parse(File.getContent(path));

		for (field in Reflect.fields(json))
		{
			if (field != "name" && !Reflect.isFunction(Reflect.getProperty(json, field)))
				Reflect.setProperty(instance, field, Reflect.getProperty(json, field));
		}

		return instance;
	}

	public static function reloadWeekFiles(isStoryMode:Null<Bool> = false)
	{
		weeksList = [];
		weeksLoaded.clear();

		for (file in AssetUtil.readDirectory("weeks"))
		{
			if (file.endsWith(".json"))
				addWeek(file.split(".json")[0]);
		}

		weeksList.sort(function(a,b) return CoolUtil.sortByList(AssetUtil.getText("weekList.txt", "weeks", MERGE), a, b));
	}

	private static function addWeek(weekToCheck:String)
	{
		if (!weeksLoaded.exists(weekToCheck))
		{
			var week:WeekData = WeekData.fromJson(Paths.json(weekToCheck, "weeks"));
			week.name = weekToCheck;

			weeksLoaded.set(weekToCheck, week);
			weeksList.push(weekToCheck);
		}
	}

	// Used on LoadingState, nothing really too relevant
	public static function getCurrentWeek():WeekData
	{
		return weeksLoaded.get(weeksList[PlayState.storyWeek]);
	}
}
