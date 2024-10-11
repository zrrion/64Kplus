class PurpleCard : SingelUseKeyBase
{
	Default
	{
		//$Category "Single Use Keys"
        //$Title "Purple key card"
		Inventory.Pickupmessage "You picked up a purple key card.";
		Inventory.Icon "STKEYSP";
		Tag "Purple key card";

		Dropitem "$vend_purplecard", VEND_DESC;
	}
	States
	{
	Spawn:
		PKEY A 10;
		PKEY B 10 bright;
		loop;
	}
}

class PurpleButton : GreenButton
{
	//$Category Switch Pilar
	Default
	{
		//$Arg0 "Place action"
        //$Arg0Type 14
        //$Arg0Default 0

        //$Arg1 "Take action"
        //$Arg1Type 14
        //$Arg1Default 0

		//$Category Switch Pilar
	}
	Override void PostBeginPlay()
	{
		super.PostBeginPlay();
		user_MarkerType = 7;
		if(user_SpawnWithKey)
		{
			if(target)
				target.Destroy();
			SetStateLabel("Placed");
		}			
	}
	States
	{
	Spawn:
		SPPE AA 1
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
		TNT1 A 0
		{
			bUSESPECIAL = true;
			A_StartSound("switch/reset");
		}
	Taken.Anim:
		SPPE # 1;
		wait;
	Placed:
		TNT1 A 0 A_GiveInventory(Key.GetType(user_MarkerType), 1);
		SPRP #### 35 { bUSESPECIAL = false;	}
		TNT1 A 0
		{
			LightLevel = -1;
			bUSESPECIAL = true;
			A_StartSound("switch/reset");
		}
	Placed.Anim:
		SPPA # 10;
		SPPB # 10 bright;
		loop;
	}
}