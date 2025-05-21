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
			"MBFHelperDog", "skp_Spectre", "skp_Cacodemon", "skp_Knight", "skp_PainElemental", 
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

class VendSpawner : EventHandler
{
	override void NetworkProcess(ConsoleEvent e)
    {
		string WhatToSpawn = e.name;
		if (WhatToSpawn.IndexOf("\r") != -1)
        {
			WhatToSpawn.Replace("\r", "");
			if(skp_DoomPlayer(players[e.player].mo))
			{
				skp_SpawnVend Vend = skp_DoomPlayer(players[e.player].mo).LastVend;
				if(Vend)
				{
					Vend.VendSpawn(WhatToSpawn, e.args[0]);
					/*ActorIterator it = level.CreateActorIterator(Vend.args[e.args[0]]);
					Actor mo = it.Next();
					while(mo)
					{
						vector3 SpawnPos = (mo.pos.X + random( -mo.radius, mo.radius), mo.pos.y + random( -mo.radius, mo.radius), mo.pos.z);
						if(WhatToSpawn != "")
							Vend.Spawn(WhatToSpawn, SpawnPos);
						Vend.Spawn("teleportfog", SpawnPos);
						mo = it.Next();
					}*/
				}
			}
        }
	}
}

class skp_Tonemap : EventHandler
{	
	PlayerInfo p;
	array<int> BigPaletteRed;
	array<int> BigPaletteGreen;
	array<int> BigPaletteBlue;
	//ui int OldTone;
	override void OnRegister()
	{
		/*
		step 1: import png as lump
		step 2: get colour data out of png
		step 2: make list of unique colours from png
		step 3: add game palette to the list of colours
		*/
		GenPal();
		GenLUT();
	}

	override void UiTick()
	{
		int DoShade = CVar.GetCvar("arg_tone", p).GetInt();
		if(p)
		{
			//OldTone = CVar.GetCVar("gl_tonemap", p).GetInt();
			//CVar.GetCVar("gl_tonemap", p).SetInt(0);
			PPShader.SetEnabled("HalfPalTonemap", (DoShade == 1));
			PPShader.SetEnabled("ExtendedPalTonemap", (DoShade == 2));
			PPShader.SetEnabled("FullPalTonemap", (DoShade == 3));
			//PPShader.SetEnabled("tonemap", false);
		}
		/*else if(OldTone)
		{
			CVar.GetCVar("gl_tonemap", p).SetInt(OldTone);
			OldTone = 0;
		}*/
	}
	/*override void RenderOverlay (RenderEvent e)
	{
		super.RenderOverlay(e);
		Screen.DrawTexture(TexMan.CheckForTexture("skp_LUT"), false, 0, 0);
	}*/

	override void PlayerEntered(PlayerEvent e)
	{
		p = players[e.PlayerNumber];	
	}

	void GenPal()
	{
		for(int i = 0; i < 256; i++)
		{
			color C = Screen.PaletteColor(i);
			BigPaletteRed.Push(C.R);
			BigPaletteGreen.Push(C.G);
			BigPaletteBlue.Push(C.B);
		}
		string PNG_Data;
		string PNG_IHDR;
		[PNG_IHDR, PNG_Data] = PNG_Helper.PNGLoader("palLUT");
		if(PNG_IHDR.Length() > -1 && PNG_Data.Length() > -1)
		{
			int width = PNG_Helper.HexByteToInt(PNG_IHDR, 0, 4);
			int height = PNG_Helper.HexByteToInt(PNG_IHDR, 4, 4);
			int bitDepth = PNG_Helper.HexByteToInt(PNG_IHDR, 8, 1);
			int colorType = PNG_Helper.HexByteToInt(PNG_IHDR, 9, 1);
			//console.printf("width: %i\nheight: %i\nbit depth: %i\ncolour type: %i", width, height, bitDepth, colorType);
			if(colorType == 3 && bitDepth <= 8)
			{
				int PalLength = PNG_Data.Length();
				for(int i = 0; i < PalLength; i += 3)
				{
					BigPaletteRed.Push(PNG_Helper.HexByteToInt(PNG_Data, i, 1));
					BigPaletteGreen.Push(PNG_Helper.HexByteToInt(PNG_Data, i + 1, 1));
					BigPaletteBlue.Push(PNG_Helper.HexByteToInt(PNG_Data, i + 2, 1));
				}
			}
		}
	}

	

	void GenLUT()
	{
		TextureID LUTtid = Texman.CheckForTexture("skp_LUT");
		Canvas LUTcv = TexMan.GetCanvas("skp_LUT");
		vector2 LUTsize;
		[LUTsize.X, LUTsize.Y] = TexMan.GetSize(LUTtid);

		for(int height = 0; height < LUTsize.Y; height++)
		{
			for(int width = 0; width < LUTsize.X; width++)
			{
				int r = (height/(LUTsize.Y - 1)) * 255;
				int g = ((height % 8)/7.) * 255;
				int b = ((width % 64)/63.) * 255;
				color PrePal = color(255, r, g, b);
				color PostPal = GetFriendlyColor(PrePal);
				LUTcv.Clear(width+1, height+1, width, height, PostPal, -1);
			}
		}
	}

	color GetFriendlyColor(color PrePal)
	{
		color ClosestColor;
		double ClosestDist;
		for(int i = 0; i < BigPaletteRed.Size(); i++)
		{
			color LoopColor = Color(255, BigPaletteRed[i], BigPaletteGreen[i], BigPaletteBlue[i]);
			vector3 v = (LoopColor.R - PrePal.R, LoopColor.G - PrePal.G, LoopColor.B - PrePal.B);
			double dist = ((v.X * v.X) + (v.Y * v.Y) + (v.Z * v.Z))/3;
			if(ClosestDist > dist || !i)
			{
				ClosestDist = dist;
				ClosestColor = LoopColor;
			}
		}
		return ClosestColor;
	}
}

class PNG_Helper : Object
{
	static int HexByteToInt(string str, int offset, int NumBytes)
	{
		string IntStr;
		for(int i = 0; i < NumBytes; i++)
			IntStr.AppendFormat("%02X", str.ByteAt(offset + i));
		return IntStr.ToInt(16);
	}

	Static string, string PNGLoader(string lump = "PlayPalPlus")
	{
		string AnEntirePNG = Wads.ReadLump(Wads.CheckNumForFullName(string.format("shaders/%s.png", lump)));
		if(AnEntirePNG.IndexOf("\x89PNG\r\n\x1a\n") != -1)
			AnEntirePNG.Replace("\x89PNG\r\n\x1a\n", "");
		else
		{
			console.printf("this is NOT a valid PNG!");
			return "", "";
		}
		
		string ihdrChunk;
		string idatChunk;
		string palChunk;
		int offset;

		while (offset < AnEntirePNG.Length())
        {
            // Read the chunk length
            int Length = PNG_Helper.HexByteToInt(AnEntirePNG, offset, 4);//convert that hex number to an int
            offset += 4;

            // Read the chunk type
            string chunkType = AnEntirePNG.Mid(offset, 4);
            offset += 4;

            // Read the chunk data
            string chunkData = AnEntirePNG.Mid(offset, Length);
            offset += Length;

            // Read the CRC
            string crc = AnEntirePNG.Mid(offset, 4);
            offset += 4;

            // Handle IHDR and IDAT chunks
            if (chunkType == "IHDR")  // IHDR
                ihdrChunk = chunkData;
			else if (chunkType == "PLTE")  // IHDR
                palChunk = chunkData;
            else if (chunkType == "IDAT")  // IDAT
                idatChunk.AppendFormat(chunkData);  // Concatenate IDAT data chunks
        }

		if (ihdrChunk.Length() == 0)
		{
			Console.printf("No IHDR chunk found");
			return "", "";
		}
		if(PNG_Helper.HexByteToInt(ihdrChunk, 9, 1) == 3 && PNG_Helper.HexByteToInt(ihdrChunk, 8, 1) <= 8)
		{
			if(palChunk.Length() < 0)
			{
				console.printf("this is an indexed PNG but the palette is missing");
				return "", "";
			}
			return ihdrChunk, palChunk;
		}
		return ihdrChunk, idatChunk;
	}
}