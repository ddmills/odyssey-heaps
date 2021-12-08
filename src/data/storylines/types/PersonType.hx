package data.storylines.types;

import data.DiceCategory;
import domain.storylines.Storyline;
import ecs.Query;
import ecs.components.Combatant;
import ecs.components.CrewMember;
import ecs.components.Level;
import ecs.components.Person;
import haxe.EnumTools;

typedef PersonTypeArgs =
{
	var key:String;
	var type:String;
	var ?inCrew:Bool;
	var ?diceCategory:DiceCategory;
}

class PersonType extends StoryType
{
	var params:PersonTypeArgs;

	public function new(params:PersonTypeArgs)
	{
		super(params.type, params.key);
		this.params = params;
	}

	public static function FromJson(json:Dynamic):StoryType
	{
		var diceCategory = json.diceCategory != null ? EnumTools.createByName(DiceCategory, json.diceCategory) : null;

		return new PersonType({
			key: json.key,
			type: json.type,
			inCrew: json.inCrew,
			diceCategory: diceCategory,
		});
	}

	override function tryPopulate(storyline:Storyline):Bool
	{
		var filter:QueryFilter = {
			all: [Person],
			none: [],
		};

		if (params.inCrew != null)
		{
			if (params.inCrew)
			{
				filter.all.push(CrewMember);
			}
			else
			{
				filter.none.push(CrewMember);
			}
		}

		if (params.diceCategory != null)
		{
			filter.all.push(Combatant);
			filter.all.push(Level);
		}

		var query = new Query(filter);
		var entities = query.toArray();
		query.dispose();

		// remove any that are already as params
		entities = entities.filter((e) ->
		{
			return !storyline.parameters.exists((p) -> p.entityId == e.id);
		});

		if (params.diceCategory != null)
		{
			entities = entities.filter((e) ->
			{
				var lvl = e.get(Level).lvl;
				var dice = e.get(Combatant).dice.getSet(lvl);
				return dice.exists((d) -> d.category == params.diceCategory);
			});
		}

		if (entities.count() <= 0)
		{
			return false;
		}

		var entity = storyline.rand.pick(entities);

		storyline.parameters.push({
			key: this.key,
			entityId: entity.id,
			display: entity.get(Person).name,
		});

		return true;
	}
}
