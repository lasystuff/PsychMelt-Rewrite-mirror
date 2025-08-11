import flixel.FlxG;

function onEvent(eventName, value1, value2)
{
	if (eventName == 'Add Camera Zoom')
	{
		if (ClientPrefs.camZooms && FlxG.camera.zoom < 1.35)
		{
			var camZoom:Float = Std.parseFloat(value1);
			var hudZoom:Float = Std.parseFloat(value2);
			if (Math.isNaN(camZoom))
				camZoom = 0.015;
			if (Math.isNaN(hudZoom))
				hudZoom = 0.03;

			FlxG.camera.zoom += camZoom;
			camHUD.zoom += hudZoom;
		}
	}
}