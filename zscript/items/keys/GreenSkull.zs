class skp_GreenSkull : SingelUseKeyBase
{
	Default
	{
		//$Category "Single Use Keys"
        //$Title "Green skull key"
		Inventory.Pickupmessage "You picked up a green skull key.";
		Inventory.Icon "STKEYS7";
	}
	States
	{
	Spawn:
		GSKU A 10;
		GSKU B 10 bright;
		loop;
	}
}

class GreenButton : SwitchBase
{
	//$Category Switch Pilar
	bool user_SpawnWithKey;
	Actor DroppedKey, Flipper;
	Default
	{
		//$Arg0 "Place action"
        //$Arg0Type 14
        //$Arg0Default 0

        //$Arg1 "Take action"
        //$Arg1Type 14
        //$Arg1Default 0

		//$Category Switch Pilar
		height 25;
		radius 12;
		+SOLID;
		-NOGRAVITY;
		-NOCLIP;
		-FIXMAPTHINGPOS;
	}
	Override void PostBeginPlay()
	{
		super.PostBeginPlay();
		user_MarkerType = 8;
		if(user_SpawnWithKey)
		{
			if(target)
				target.Destroy();
			SetStateLabel("Placed");
		}
			
	}
	Override void Activate(Actor activator)
	{
		Flipper = activator;
		if(self.CountInv(Key.GetType(user_MarkerType)))
		{
			self.Deactivate(activator);
			return;
		}
		A_StartSound("switches/normbutn",CHAN_AUTO);

		bool haskey = user_MarkerType ? activator.CountInv(Key.GetType(user_MarkerType)) > 0 : true;
		if(haskey && args[0] && activator.A_CallSpecial(130, args[0]))
		{
			activator.A_TakeInventory(Key.GetType(user_MarkerType), 1);
			if(target)
				target.Destroy();
			SetStateLabel("Placed");
		}
		else
		{
			if(user_MarkerType && !haskey)
				Activator.A_Print(Key.GetString(user_MarkerType));
		}
	}
	Override void Deactivate (Actor activator)
	{
		Flipper = activator;
		if(!self.CountInv(Key.GetType(user_MarkerType)))
		{
			self.Activate(activator);
			return;
		}
		A_StartSound("switches/normbutn",CHAN_AUTO);
		if(args[1])
			activator.A_CallSpecial(130, args[1]);
		PlaceMarker();
		SetStateLabel("Taken");
	}
	override void Tick()
	{
		super.Tick();
		frame = (level.time/3)%4;
	}
	void A_TryTouch()
	{
		if(inventory(DroppedKey) && !inventory(DroppedKey).Owner && Flipper)
		{
			inventory(DroppedKey).Touch(Flipper);
		}
	}
	States
	{
	Spawn:
		SPGE AA 1
		{
			if(CurSector.lightlevel < 128)
				LightLevel = 128;
		}
		Goto Taken.Anim;
	Taken:
		TNT1 A 0
		{
			DroppedKey = A_DropItem(Key.GetType(user_MarkerType));
			A_TakeInventory(Key.GetType(user_MarkerType), 1);
			if(CurSector.lightlevel < 128)
				LightLevel = 128;
			bUSESPECIAL = false;
		}
		SPRE ## 35;
		SPRE # 0 A_TryTouch();
		SPRE ## 35;
		TNT1 A 0 {	bUSESPECIAL = true;	}
	Taken.Anim:
		SPGE # 1;
		wait;
	Placed:
		TNT1 A 0 A_GiveInventory(Key.GetType(user_MarkerType), 1);
		SPRG #### 35 { bUSESPECIAL = false;	}
		TNT1 A 0 {	LightLevel = -1;	bUSESPECIAL = true;	}
	Placed.Anim:
		SPGA # 10;
		SPGB # 10 bright;
		loop;
	}
}

class ButtonAction : SwitchableDecoration
{
	//$Category Switch Pilar
	int oldspecial;
	default
	{
		//$Category Switch Pilar
		+USESPECIAL;
		Activation THINGSPEC_Switch;
	}
	override void PostBeginPlay()
	{
		oldspecial = special;
		special = 0;

	}
	Override void Activate(Actor activator)
	{
		A_CallSpecial(oldspecial, args[0], args[1], args[2], args[3], args[4]);
		if(SwitchBase(activator) && SwitchBase(activator).user_NoRepeat)
			self.destroy();

	}
	Override void Deactivate(Actor activator)
	{
		super.Activate(activator);
	}
	states
	{
		spawn:
		activate:
		deactivate:
			ACTN A 1;
			wait;
	}
}