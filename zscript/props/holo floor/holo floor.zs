//LFLRA0.png
class HoloFloor : Actor
{
	default
	{
		RenderStyle "Add";
		Alpha 0.75;
		Radius 32;
		Height 4;
		+SOLID
		+NOGRAVITY
		+NOLIFTDROP
		+ACTLIKEBRIDGE
		+BRIGHT
		+FLATSPRITE
	}
	States
	{
	Spawn:
		LFLR ABCDEFGHI 4;
		LFLR J 16;
		LFLR K 2;
		Loop;
	}
	Override void Tick()
	{
		if (isFrozen())
			return;
			
		int FlickerTime = 30;
		if(level.totaltime % FlickerTime == 0 && Random(0,4) == 0)
			alpha = 1.0;
		else if(level.totaltime % FlickerTime/3 == 0 && alpha == 1.0 && Random(0,1) == 0)
			alpha = 0.75;
	
		if(level.totaltime % 8 == 0)
		{
			int NewRad = 32;
			A_SetSize(NewRad, self.height, FALSE);
		}
		super.Tick();
	}
}