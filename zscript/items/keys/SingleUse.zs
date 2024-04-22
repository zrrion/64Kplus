Class SingelUseKeyBase : Key //this is different from a puzzle item
{
	Default
	{
		Inventory.MaxAmount 2;//IDK why you would have more than 5 honestly, but any more than 2 and I'd need more room on the hud
		Inventory.InterHubAmount 2;
	}
	override bool HandlePickup (Inventory item)//this is the same as the inventory class
	{
		if (item.GetClass() == GetClass())
		{
			if (Amount < MaxAmount)
			{
				if (Amount > 0 && Amount + item.Amount < 0)
				{
					Amount = 0x7fffffff;
				}
				else
				{
					Amount += item.Amount;
				}
			
				if (Amount > MaxAmount && !sv_unlimited_pickup)
				{
					Amount = MaxAmount;
				}
				item.bPickupGood = true;
			}
			return true;
		}
		return false;
	}
}