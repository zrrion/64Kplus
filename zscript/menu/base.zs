class VendSpawnerMenu : OptionMenu
{	
	DropItem di;
	array<DropItem> List;
	static const string TypeList[] = { "", "Ammo", "Health", "Armor", "Powerups", "Keys", "LoR Items", "64K+ Items", "Weapons", "LoR Weapons", "64K+ Weapons", "Enemies", "LoR Enemies", "64K+ Enemies", "Misc"	};
	int CurType;
	int CurSelect;
	int FntHeight;
	font fnt;

	TextureID menubg;
	TextureID menuselect;

	override void Init(Menu parent, OptionMenuDescriptor desc)
	{
		menuactive = Menu.OnNoPause;
		MenuSound("switches/normbutn");
		di = GetDefaultByType("skp_SpawnVend").GetDropItems();
		CurType = 1;
		ChangeType(CurType);

		fnt = Font.GetFont("tinyfont");
		FntHeight = fnt.GetHeight();

		menubg = TexMan.CheckForTexture("graphics/HUD/Vending Machine/background5.png", TexMan.Type_MiscPatch);
		menuselect = TexMan.CheckForTexture("graphics/HUD/Vending Machine/selection.png", TexMan.Type_MiscPatch);

		super.Init(parent,desc);
	}
	override void Ticker()
	{
		Super.Ticker();
	}
	
	override bool MenuEvent(int mkey, bool fromcontroller)
	{
		int TypeChange;
		int SelectChange;
		switch(mkey)
		{
			case 2:
				MenuSound("plats/pt1_mid");
				CurSelect = 0;
				TypeChange--;
				break;
			case 3:
				MenuSound("plats/pt1_mid");
				CurSelect = 0;
				TypeChange++;
				break;
			case 0:
				MenuSound("plats/pt1_mid");
				SelectChange--;
				break;
			case 1:
				MenuSound("plats/pt1_mid");
				SelectChange++;
				break;
			case 6:
				MenuSound("switches/normbutn");
				SpawnSelected();
				break;

		}
		if(SelectChange != 0)
		{
			CurSelect += SelectChange;
			CurSelect %= List.Size();
			if(CurSelect < 0)
				CurSelect += List.Size();
		}
		if(TypeChange != 0)
		{
			do
			{
				CurType += TypeChange;
				CurType %= 15;
				if(CurType == 0)
					CurType += TypeChange;
				if(CurType < 0)
					CurType += 15;
				ChangeType(CurType);
			}
			while(List.Size() == 0)
		}

		return Super.MenuEvent(mkey, fromcontroller);
	}
	void ChangeType(int type = -1)
	{
		list.Clear();
		di = GetDefaultByType("skp_SpawnVend").GetDropItems();
		while(di)
		{
			if(di.Probability == -1 * abs(Type))
			{
				List.Push(di);
			}
			di = di.next;
		}
	}

	void SpawnSelected()
	{
		string SpawnName = "\r";
		int Spot;
		for(int i = 0; i < List.Size(); i++)
			if(i == CurSelect)
			{
				DropItem di = List[i];
				class<Actor> mo = di.name;
				if(mo && GetDefaultByType(mo).bSHOOTABLE == false)
					Spot = 1;
				SpawnName.AppendFormat("%s", di.Name);
			}
		EventHandler.SendNetworkEvent(SpawnName, Spot, 0, 0);
	}
	
	override void Drawer () 
	{
			int NormalColor = Font.CR_OLIVE;
			int SelectColor = Font.CR_GREEN;
			int LineHeight = fnt.GetHeight() + 1;
			vector2 InfoFramePos = (132, 35);
			vector2 InfoFrameXY = (148, 130);
			vector2 SpritePos = (InfoFramePos.X + (InfoFrameXY.X /2), InfoFramePos.Y + (InfoFrameXY.Y -(LineHeight*3) -3));
			[InfoFramePos, InfoFrameXY] = screen.VirtualToRealCoords(InfoFramePos, InfoFrameXY, (320, 200));

			if(TypeList[CurType].IndexOf("LoR") != -1)
			{
				NormalColor = Font.CR_DARKBROWN;
				SelectColor = Font.CR_ORANGE;
			}
			screen.DrawTexture(menubg, true, 0, 0, DTA_320x200, true);
			screen.DrawText(fnt, NormalColor, 42, 36, "<", DTA_320x200, 1);
			screen.DrawText(fnt, SelectColor, 42 + fnt.StringWidth("<"), 36, TypeList[CurType], DTA_320x200, 1);
			screen.DrawText(fnt, NormalColor, 120, 36, ">", DTA_320x200, 1);
			screen.DrawText(fnt, Font.CR_BLACK, 133, 36, "Press ENTER to spawn", DTA_320x200, 1);
			for(int i = 0; i < List.Size(); i++)
			{
				class<Actor> Lclass = List[i].Name;

				if(i == CurSelect)
				{
					screen.DrawTexture(menuselect, true, 41, 50 + i * (FntHeight + 1), DTA_320x200, true);
					state SelState = GetDefaultByType(Lclass).FindState("Spawn");
					TextureID SelSprite;
					if(SelState.ValidateSpriteFrame())
						SelSprite = SelState.GetSpriteTexture(0);
					else
						SelSprite = TexMan.CheckForTexture("UNKNA0", TexMan.Type_Sprite);
					screen.SetClipRect(InfoFramePos.X, InfoFramePos.Y, InfoFrameXY.X, InfoFrameXY.Y);
					screen.DrawTexture(SelSprite, true, SpritePos.X, SpritePos.Y, DTA_320x200, true, DTA_LegacyRenderStyle, GetDefaultByType(Lclass).GetRenderStyle());

					Dropitem DescriptionDi = GetDefaultByType(Lclass).GetDropItems();
					string Description;
					while(DescriptionDi)
					{
						if(DescriptionDi.Probability == VEND_DESC)
						{
							Description = StringTable.Localize(DescriptionDi.Name);
							DescriptionDi = NULL;
						}
						else
							DescriptionDi = DescriptionDi.next;
					}
					if(Description == "")
						Description = "Spawn one and find out :3c";
					DescriptionDi = NULL;
					

					BrokenLines lines = fnt.BreakLines(Description, 146);
					Description = "";
					int LineCount = lines.Count();
					vector2 DesPos = (133, 165);
        			for (int i = 0; i < LineCount; i++)
						Description.AppendFormat("%s\n", lines.stringAt(i));
					lines.destroy();
					screen.DrawText(fnt, SelectColor, DesPos.X, DesPos.Y - (LineHeight * LineCount), Description, DTA_320x200, 1);
					
					screen.ClearClipRect();
				}

				screen.DrawText(fnt, i == CurSelect ? SelectColor : NormalColor, 42, 51 + i * (FntHeight + 1), string.Format(" %s", (StringTable.Localize(GetDefaultByType(Lclass).GetTag()))), DTA_320x200, 1);
			}
			OptionMenu.Drawer();
	}
}