enum ETreeStatus
{
	TREE_IDLE = 0,//nothing has happened yet, waiting to start
	TREE_READY = 1,//tree has started but not this node
	TREE_ACTIVATED = 2,//this node has started doing whatever it does
	TREE_DONE = 3//this node is done, it is not waiting for anything, it cannot do anything
}

class BehaviorTree : actor abstract
{
	BehaviorTree root;
	BehaviorTree parent;
	array<BehaviorTree> children;
	ETreeStatus TreeStatus;
	default
	{
		//$Category "Behavior Trees"
		//$Color 8
		+NOBLOCKMAP;
        +NOGRAVITY;
		+NOINTERACTION;
        -SOLID;
	}
	virtual void GetChildren()
    {
		if(special)
			return;
        for (int i = 0; i < 5; i++)
            if (self.args[i] != 0)
				GetChildrenByTag(args[i]);
    }
	virtual void GetChildrenByTag(int childtag)
    {
        ActorIterator it = Level.CreateActorIterator(childtag, "BehaviorTree");
        BehaviorTree mo;
        while ( mo = BehaviorTree(it.Next()) )
        {
            if (mo && !children.find(mo))
            {
                mo.root = self.root;
                mo.parent = self;
                children.push(mo);
            }
        }
    }
	override void PostBeginPlay()
	{
		super.PostBeginPlay();
		GetChildren();
	}
	void ReadyChildren()
	{
		if(children.size())
			for(int i = 0; i < children.size(); i++)
			{
				children[i].TreeStatus = TREE_READY;
			}
	}
	virtual bool ActivateChildren(bool group = false)
	{
		if(!group && children.size())
		{
			int FavChild = children.size()-1;
			if(children[FavChild].TreeStatus == TREE_READY)
				children[FavChild].Activate(self);
			else if(children[FavChild].TreeStatus == TREE_DONE)
				children.Pop();
		}
		else if(!group && !children.size())
		{
			GetChildren();
			return true;
		}
		if(group)
		{
			for(int i = 0; i < children.size(); i++)
				children[i].Activate(self);
			return true;
		}
		return false;
	}
	override void Activate(actor Activator)
	{
		if(special)
		{
			A_CallSpecial(special, args[0], args[1], args[2], args[3], args[4]);
			return;
		}
		if(BehaviorTree(Activator))
		{
			parent = BehaviorTree(Activator);
			root = parent.root;
			TreeStatus = TREE_ACTIVATED;
		}
		else
		{
			root = self;
			TreeStatus = TREE_ACTIVATED;
			ReadyChildren();
		}
	}
	override void Deactivate(actor Activator)
	{
		if(BehaviorTree(Activator))
			TreeStatus = TREE_DONE;
	}
	override void Tick()
	{
		super.Tick();
		if(TreeStatus == TREE_ACTIVATED)
			if(ActivateChildren())
				TreeStatus = TREE_DONE;
		if(TreeStatus == TREE_DONE)
		{
			if(root == self)
				TreeStatus = TREE_IDLE;
			DeactivateChildren();
		}
	}
	bool DeactivateChildren()
	{
		if(children.size())
		{
			for(int i = 0; i < children.size(); i++)
				children[i].Deactivate(self);
			return true;
		}
		return false;
	}
}