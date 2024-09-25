/*
swiped this code (and edited it a smidge) from MetaDoom
So maybe possibly dehacked won't completely fuck things up here
*/

class PropsReplacer : EventHandler
{
	bool safetylock;

	// Check whether a DEHACKED lump has messed with frame names in a way we
	// can't detect any other way, and completely shut down prop replacements
	// if that turns out to be the case (see: Demonastery)
	// Code loosely based on Beautiful Doom's DEHACKED detector by 3saster.
    override void OnRegister()
	{
		string data = Wads.ReadLump(Wads.FindLump("DEHACKED",0,1));
		// Delete comments
		while(data.IndexOf("#") != -1)
		{
			int start = data.IndexOf("#");
			int end   = data.IndexOf("\n",start);
			data.Remove(start,end-start);
		}
		// Split Lines
		Array<String> lines;
		data.Split(lines, "\n");
		
		// Parse each line
		for(int i=0; i<lines.Size(); i++)
		{
			if (lines[i].left(8) ~== "Text 4 4" && !safetylock)
			{
				Console.printf("Optional: DEHACKED lump is fucking with frame names, prop replacements disabled.");
				safetylock = true;
				break;
			}
		}
	}
	
	override void CheckReplacement(ReplaceEvent e)
	{
		static const string oldActor[] =
		{
			// Gore
			"Gibs", "BrainStem", "ColonGibs", "SmallBloodPool", 
			"BloodyTwitch", "NonsolidTwitch", "DeadStick", "LiveStick", 
			"Meat2", "Meat3", "Meat4", "Meat5", 
			"NonsolidMeat2", "NonsolidMeat3", "NonsolidMeat4", "NonsolidMeat5", 
			"HangBNoBrain", "HangNoGuts", "HangTLookingDown", "HangTLookingUp", 
			"HangTNoBrain", "HangTSkull", 
			// Hell
			"FloatingSkull","HeartColumn","RedTorch","BlueTorch",
			"GreenTorch","ShortRedTorch","ShortBlueTorch","ShortGreenTorch",
			"BigTree","TorchTree","Candelabra","Candlestick",
			"HeadCandles","EvilEye","HeadOnAStick","HeadsOnAStick",
			// Tech
			"TechLamp","TechLamp2","Column","BurningBarrel","TechPillar",
			// Corpses
			"DeadCacodemon", "DeadDemon", "DeadDoomImp", "DeadMarine",
			"DeadZombieman", "DeadShotgunGuy", "GibbedMarine"
		};
		
		static const string newActor[] =
		{
			// Gore
			"Gibs", "BrainStem", "ColonGibs", "SmallBloodPool", 
			"BloodyTwitch", "NonsolidTwitch", "DeadStick", "LiveStick", 	
			"Meat2", "Meat3", "Meat4", "Meat5", 
			"NonsolidMeat2", "NonsolidMeat3", "NonsolidMeat4", "NonsolidMeat5", 
			"HangBNoBrain", "HangNoGuts", "HangTLookingDown", "HangTLookingUp", 
			"HangTNoBrain", "HangTSkull", 
			// Hell
			"skp_FloatingSkull","HeartColumn","skp_RedTorch","skp_BlueTorch",
			"skp_GreenTorch","skp_ShortRedTorch","skp_ShortBlueTorch","skp_ShortGreenTorch",
			"BigTree","TorchTree","Candelabra","skp_Candle",
			"HeadCandles","EvilEye","HeadOnAStick","HeadsOnAStick",
			// Tech
			"skp_TechLamp","skp_TechLamp2","skp_Column","skp_BurningBarrel","TechPillar",
			// Corpses
			"skp_DeadCacodemon", "skp_DeadDemon", "skp_DeadDoomImp", "skp_DeadMarine",
			"skp_DeadZombieman", "skp_DeadShotgunGuy", "skp_GibbedMarine"
		};
		
		for(int i = 0; i < oldActor.size(); i++)
		{
			if ( e.Replacee == oldActor[i]) 
			{
				if (GetDefaultByType(e.Replacee).SpawnState.bDeHacked
				|| (GetDefaultByType(e.Replacee).SeeState != null && GetDefaultByType(e.Replacee).SeeState.bDeHacked)
				|| (GetDefaultByType(e.Replacee).MeleeState != null && GetDefaultByType(e.Replacee).MeleeState.bDeHacked)
				|| (GetDefaultByType(e.Replacee).MissileState != null && GetDefaultByType(e.Replacee).MissileState.bDeHacked)
				|| (GetDefaultByType(e.Replacee).FindState("Pain") != null && GetDefaultByType(e.Replacee).FindState("Pain").bDeHacked)
				|| (GetDefaultByType(e.Replacee).FindState("Death") != null && GetDefaultByType(e.Replacee).FindState("Death").bDeHacked)
				|| (GetDefaultByType(e.Replacee).FindState("XDeath") != null && GetDefaultByType(e.Replacee).FindState("XDeath").bDeHacked))
				{
					break;
				}
				else if(!safetylock)
				{
					e.Replacement = newActor[i];
				}
			}
		}
	}
}

class MonsterReplacer : EventHandler
{
    override void CheckReplacement(ReplaceEvent e)
	{
		static const string oldActor[] =
		{
			// Standard Doom Actors
			"ZombieMan", "ShotgunGuy", "ChaingunGuy", "DoomImp", "Demon", 
			"MBFHelperDog", "Spectre", "Cacodemon", "HellKnight", "PainElemental", 
			"LostSoul", "ArchVile", "Revenant", "BaronOfHell", "Arachnotron", "Fatso",
			"SpiderMastermind", "Cyberdemon",
			// Traditionally "Optional" Actors
			"WolfensteinSS", "CommanderKeen",
			// Scripted Marines - Order is important!
			"MarineRocket", "MarineBerserk", "MarineFist", "MarineChainsaw",
			"MarinePistol", "MarineShotgun", "MarineSSG", "MarineChaingun",
			"MarinePlasma", "MarineRailgun", "MarineBFG", "ScriptedMarine"
		};
		
		static const string newActor[] =
		{
			// Standard Doom Actors
			"skp_ZombieMan", "skp_ShotgunGuy", "skp_ChaingunGuy", "skp_DoomImp", "skp_Demon", 
			"MBFHelperDog", "skp_Spectre", "skp_Cacodemon", "skp_HellKnight", "skp_PainElemental", 
			"skp_LostSoul", "skp_ArchVile", "skp_Revenant", "skp_BaronOfHell", "skp_Arachnotron", "skp_Mancubus",
			"skp_SpiderMastermind", "skp_Cyberdemon",
			// Traditionally "Optional" Actors
			"WolfensteinSS", "skp_Keen",
			// Scripted Marines - Order is important!
			"MarineRocket", "MarineBerserk", "MarineFist", "MarineChainsaw",
			"MarinePistol", "MarineShotgun", "MarineSSG", "MarineChaingun",
			"MarinePlasma", "MarineRailgun", "MarineBFG", "ScriptedMarine"
		};
		
		for(int i = 0; i < oldActor.size(); i++)
		{
			if ( e.Replacee == oldActor[i] ) 
			{
				if (GetDefaultByType(e.Replacee).SpawnState.bDeHacked
				|| (GetDefaultByType(e.Replacee).SeeState != null && GetDefaultByType(e.Replacee).SeeState.bDeHacked)
				|| (GetDefaultByType(e.Replacee).MeleeState != null && GetDefaultByType(e.Replacee).MeleeState.bDeHacked)
				|| (GetDefaultByType(e.Replacee).MissileState != null && GetDefaultByType(e.Replacee).MissileState.bDeHacked)
				|| (GetDefaultByType(e.Replacee).FindState("Pain") != null && GetDefaultByType(e.Replacee).FindState("Pain").bDeHacked)
				|| (GetDefaultByType(e.Replacee).FindState("Death") != null && GetDefaultByType(e.Replacee).FindState("Death").bDeHacked)
				|| (GetDefaultByType(e.Replacee).FindState("XDeath") != null && GetDefaultByType(e.Replacee).FindState("XDeath").bDeHacked))
				{
						break;
				}
				else
				{
					e.Replacement = newActor[i];
				}
			}
		}
    }
}

class WeaponReplacer : EventHandler
{
    override void CheckReplacement(ReplaceEvent e)
	{
		static const string oldActor[] =
		{
			"fist", "Chainsaw", "Pistol", "Shotgun", "SuperShotgun", "Chaingun", "RocketLauncher", "PlasmaRifle", "BFG9000"
		};
		
		static const string newActor[] =
		{
			"skp_Fist", "skp_Chainsaw", "skp_Pistol", "skp_Shotgun", "skp_SuperShotgun", "skp_Chaingun", "skp_RocketLauncher", "skp_PlasmaRifle", "skp_BFG9000"
		};
		static const string LoRActor[] =
		{
			"skp_Fist", "skp_Chainsaw", "skp_Pistol", "skp_Shotgun", "skp_SuperShotgun", "skp_Chaingun", "skp_RocketLauncher", "skp_Incinerator", "skp_HeatBlade"
		};
		
		for(int i = 0; i < oldActor.size(); i++)
			if (e.Replacee == oldActor[i] )
				e.Replacement = LorWeapons ? LoRActor[i] : newActor[i];//add something here to deal with Legacy of Rust weapon stuff
    }
}

class skp_Tonemap : EventHandler
{
	PlayerInfo p;
	//ui int OldTone;
	override void UiTick()
	{
		bool DoShade = CVar.GetCvar("arg_tone", p).GetBool();
		if(p)
		{
			//OldTone = CVar.GetCVar("gl_tonemap", p).GetInt();
			//CVar.GetCVar("gl_tonemap", p).SetInt(0);
			PPShader.SetEnabled("ExtendedPalLUT", DoShade);
			//PPShader.SetEnabled("tonemap", false);
		}
		/*else if(OldTone)
		{
			CVar.GetCVar("gl_tonemap", p).SetInt(OldTone);
			OldTone = 0;
		}*/
	}

	override void PlayerEntered(PlayerEvent e)
	{
		p = players[e.PlayerNumber];
		
	}
}