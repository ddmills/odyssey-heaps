package ecs.components;

import ecs.Entity;

typedef IsInventoriedOpts =
{
	var owner:Entity;
}

class IsInventoried extends Component
{
	var ownerRef:EntityRef;

	public var owner(get, set):Entity;
	public var display(get, never):String;

	public function new(opts:IsInventoriedOpts)
	{
		ownerRef = new EntityRef(opts.owner.id);
	}

	function get_owner():Entity
	{
		return ownerRef.entity;
	}

	function set_owner(value:Entity):Entity
	{
		ownerRef.entity = value;

		return value;
	}

	function get_display():String
	{
		var name = entity.get(Moniker).displayName;
		var stackable = entity.get(Stackable);
		var quantity = stackable == null ? '' : ' x ${stackable.quantity}';

		return '${name}${quantity}';
	}
}
