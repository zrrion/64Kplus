class SKP_HealthStation : SwitchBase
{
	//$Category Health and Armor
	Default
	{
		//$Arg0 "Heal per Use"
		//$Arg0Default 5

		//$Arg1 "Number of Uses"
        //$Arg1Type 11
		//$Arg1Enum { 0 = "Empty"; 1 = "1 Use"; 2 = "2 Uses"; 3 = "3 Uses"; 4 = "4 Uses"; 5 = "5 Uses/Full"; }
		//$Arg1Default 5

		//$Arg2 "Heal action"
        //$Arg2Type 14
        //$Arg2Default 0

        //$Arg3 "Empty action"
        //$Arg3Type 14
        //$Arg3Default 0

		

		//$Category Health and Armor
		height 42;
		radius 15;
		+SOLID;
		-NOGRAVITY;
		-NOCLIP;
		-FIXMAPTHINGPOS;
		-USESPECIAL;

		/*+SHOOTABLE;
		+NEVERTARGET;
		+DONTTHRUST;
		+INVULNERABLE;*/

	}
	int StartHealth;
	Override void PostBeginPlay()
	{
		super.PostBeginPlay();
		special = 0;

		if(args[0] < 0 || args[1] < 1)
		{
			SetStateLabel("Death");
			return;
		}
		if(!(args[0] && args[1]))//we need to have an amount per use and we need to have uses remaining
		{
			args[0] = 5;
			args[1] = 5;
		}
		self.health = args[0] * args[1];
		StartHealth = args[0] * 5;
		HalfFull();
	}
	Override void Activate(Actor activator)	{	}
	Override void Deactivate (Actor activator)	{	}
	Override bool Used(Actor user)
	{
		if(!user)
			return false;
		if(self.Health)
		{
			self.health -= args[0];
			user.A_GiveInventory("HealthBonus", args[0]);
			if(self.health && args[2])
				user.A_CallSpecial(130, args[2]);
			else if(args[3])
				user.A_CallSpecial(130, args[3]);
			
			user.A_StartSound(HalfFull() ? "misc/quaff/some" : "misc/quaff/all", CHAN_AUTO, CHANF_UI);

			inventory.PrintPickupMessage(true, string.Format("%s\cr (+%i)\cl", health ? "You quaff some of the potion." : "You quaff the remainder of the potion.", args[0]));
			if(playerpawn(user))
				playerpawn(user).player.bonuscount = 3;
		}
		else
			user.A_StartSound("*usefail", CHAN_AUTO, CHANF_UI);
		return false;
	}
	Override void Tick()
	{
		actor.Tick();
		int LightTarget;
		LightTarget = 160 * (self.health/100);
		if(CurSector.lightlevel < LightTarget)
			self.LightLevel = LightTarget;
		else
			self.LightLevel = CurSector.lightlevel;
	}
	bool HalfFull()
	{
		if(self.health > StartHealth - args[0])
			SetStateLabel("Spawn");
		else if(self.health > StartHealth - (args[0] * 2))
			SetStateLabel("Spawn2");
		else if(self.health > StartHealth - (args[0] * 3))
			SetStateLabel("Spawn3");
		else if(self.health > StartHealth - (args[0] * 4))
			SetStateLabel("Spawn4");
		else if(self.health)
			SetStateLabel("Spawn5");
		else
		{
			SetStateLabel("Death");
			return false;
		}
		return true;
	}
	States
	{
	Spawn:
		HSOF ABCDCB 6;
		loop;
	Spawn2:
		HSOF EFGHGF 6;
		loop;
	Spawn3:
		HSOF IJKLKJ 6;
		loop;
	Spawn4:
		HSOF MNOPON 6;
		loop;
	Spawn5:
		HSOF QRSTSR 6;
		loop;
	Death:
		HSOF U -1;
		Stop;
	}
}