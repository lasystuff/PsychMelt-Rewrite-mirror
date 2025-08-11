import haxe.ds.StringMap;
import StringTools;

var boyfriendMap = new StringMap();
var dadMap = new StringMap();
var gfMap = new StringMap();

function onEventPushed(event)
{
	if (event.event == "Change Character")
	{
		var charType:Int = 0;
		switch (event.value1.toLowerCase())
		{
			case 'gf' | 'girlfriend' | '1':
				charType = 2;
			case 'dad' | 'opponent' | '0':
				charType = 1;
			default:
				charType = Std.parseInt(event.value1);
				if (Math.isNaN(charType))
					charType = 0;
		}

		var newCharacter:String = event.value2;
		addCharacterToList(newCharacter, charType);
	}
}

function onEvent(eventName, value1, value2)
{
	if (eventName == "Change Character")
	{
		var charType:Int = 0;
		switch (StringTools.trim(value1.toLowerCase()))
		{
			case 'gf':
				charType = 2;
			case 'girlfriend':
				charType = 2;
			case 'dad':
				charType = 1;
			case 'opponent':
				charType = 1;
			default:
				charType = Std.parseInt(value1);
				if (Math.isNaN(charType))
					charType = 0;
		}

		switch (charType)
		{
			case 0:
				if (boyfriend.curCharacter != value2)
				{
					if (!boyfriendMap.exists(value2))
					{
						addCharacterToList(value2, charType);
					}

					for (ghost in ghostMap.get(boyfriend))
						ghost.destroy();

					var lastAlpha:Float = boyfriend.alpha;
					boyfriend.alpha = 0;
					boyfriend = boyfriendMap.get(value2);
					boyfriend.alpha = lastAlpha;
					hud.changeIcon(boyfriend, boyfriend.healthIcon);
					ghostMap.set(boyfriend, boyfriend.createGhosts());
					for (ghost in ghostMap.get(boyfriend))
						ghostGroup.add(ghost);
				}
				setOnScripts('boyfriendName', boyfriend.curCharacter);

			case 1:
				if (dad.curCharacter != value2)
				{
					if (!dadMap.exists(value2))
					{
						addCharacterToList(value2, charType);
					}

					for (ghost in ghostMap.get(dad))
						ghost.destroy();

					var wasGf:Bool = StringTools.startsWith(dad.curCharacter, "gf");
					var lastAlpha:Float = dad.alpha;
					dad.alpha = 0;
					dad = dadMap.get(value2);
					if (!StringTools.startsWith(dad.curCharacter, "gf"))
					{
						if (wasGf && gf != null)
						{
							gf.visible = true;
						}
					}
					else if (gf != null)
					{
						gf.visible = false;
					}
					dad.alpha = lastAlpha;
					hud.changeIcon(dad, dad.healthIcon);
					ghostMap.set(dad, dad.createGhosts());
					for (ghost in ghostMap.get(dad))
						ghostGroup.add(ghost);
				}
				setOnScripts('dadName', dad.curCharacter);

			case 2:
				if (gf != null)
				{
					if (gf.curCharacter != value2)
					{
						if (!gfMap.exists(value2))
						{
							addCharacterToList(value2, charType);
						}

						for (ghost in ghostMap.get(gf))
							ghost.destroy();

						var lastAlpha:Float = gf.alpha;
						gf.alpha = 0;
						gf = gfMap.get(value2);
						gf.alpha = lastAlpha;
						ghostMap.set(gf, gf.createGhosts());
						for (ghost in ghostMap.get(gf))
							ghostGroup.add(ghost);
					}
					setOnScripts('gfName', gf.curCharacter);
				}
		}
		hud.reloadHealthBar();
	}
}

function addCharacterToList(newCharacter:String, type:Int)
{
	switch (type)
	{
		case 0:
			if (!boyfriendMap.exists(newCharacter))
			{
				var newBoyfriend:Character = new Character(0, 0, newCharacter, true);
				boyfriendMap.set(newCharacter, newBoyfriend);
				boyfriendGroup.add(newBoyfriend);
				startCharacterPos(newBoyfriend);
				newBoyfriend.alpha = 0.00001;
				startCharacterLua(newBoyfriend.curCharacter);
			}

		case 1:
			if (!dadMap.exists(newCharacter))
			{
				var newDad:Character = new Character(0, 0, newCharacter);
				dadMap.set(newCharacter, newDad);
				dadGroup.add(newDad);
				startCharacterPos(newDad, true);
				newDad.alpha = 0.00001;
				startCharacterLua(newDad.curCharacter);
			}

		case 2:
			if (gf != null && !gfMap.exists(newCharacter))
			{
				var newGf:Character = new Character(0, 0, newCharacter);
				gfMap.set(newCharacter, newGf);
				gfGroup.add(newGf);
				startCharacterPos(newGf);
				newGf.alpha = 0.00001;
				startCharacterLua(newGf.curCharacter);
			}
	}
}
