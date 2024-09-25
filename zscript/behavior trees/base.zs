enum ETreeStatus
{
	TREE_IDLE = 0,//nothing has happened yet, waiting to start
	TREE_READY = 1,//tree has started but not this node
	TREE_ACTIVATED = 2,//this node has started doing whatever it does
	TREE_DONE = 3//this node is done, it is not waiting for anything, it cannot do anything
}

class BehaviorTree : actor
{
	bool user_wave;
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
}