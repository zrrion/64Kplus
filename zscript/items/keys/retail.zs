class skp_BlueCard : BlueCard replaces BlueCard
{
	Default
	{
		Dropitem "$vend_BlueCard", VEND_DESC;
		Tag "Blue key card";
		species "BlueCard";
		Inventory.Pickupmessage "$GOTBLUECARD";
	}
	Override void AttachToOwner(Actor other)
	{
		if(other)
		{
			other.A_GiveInventory(self.GetSpecies());
			self.Destroy();
		}
	}
	Override void PostBeginPlay()
	{
		super.PostBeginPlay();
		self.A_GiveInventory(self.GetSpecies());
		if(Inv)
		{
			SetState(Inv.ResolveState("spawn"));
			Inv.Destroy();
			Inv = NULL;
		}
	}
}
class skp_BlueSkull : skp_BlueCard replaces BlueSkull
{
	Default
	{
		Dropitem "$vend_BlueSkull", VEND_DESC;
		Tag "Blue skull key";
		species "BlueSkull";
		Inventory.PickupMessage "$GOTBLUESKUL";
	}
}
class skp_RedCard : skp_BlueCard replaces RedCard
{
	Default
	{
		Dropitem "$vend_RedCard", VEND_DESC;
		Tag "Red key card";
		species "RedCard";
		Inventory.Pickupmessage "$GOTREDCARD";
	}
}
class skp_RedSkull : skp_BlueCard replaces RedSkull
{
	Default
	{
		Dropitem "$vend_RedSkull", VEND_DESC;
		Tag "Red skull key";
		species "RedSkull";
		Inventory.Pickupmessage "$GOTREDSKUL";
	}
}
class skp_YellowCard : skp_BlueCard replaces YellowCard
{
	Default
	{
		Dropitem "$vend_YellowCard", VEND_DESC;
		Tag "Yellow key card";
		species "YellowCard";
		Inventory.Pickupmessage "$GOTYELWCARD";
	}
}
class skp_YellowSkull : skp_BlueCard replaces YellowSkull
{
	Default
	{
		Dropitem "$vend_YellowSkull", VEND_DESC;
		Tag "Yellow skull key";
		species "YellowSkull";
		Inventory.Pickupmessage "$GOTYELWSKUL";
	}
}