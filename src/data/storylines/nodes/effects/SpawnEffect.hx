package data.storylines.nodes.effects;

import core.Game;
import data.storylines.nodes.effects.StoryEffect.StoryEffct;
import domain.storylines.Storyline;
import ecs.spawnables.Spawnable;
import ecs.spawnables.SpawnableType;
import ecs.spawnables.Spawner;
import haxe.EnumTools;

typedef SpawnEffectArgs =
{
	var type:String;
	var spawnable:SpawnableType;
	// var position:"???";
	var outVar:String;
}

class SpawnEffect extends StoryEffct
{
	public var params:SpawnEffectArgs;

	public function new(params:SpawnEffectArgs)
	{
		super(params.type);
		this.params = params;
	}

	override function applyToStoryline(storyline:Storyline)
	{
		var entity = Spawner.Spawn(params.spawnable);
		storyline.setVariable(params.outVar, {
			key: params.outVar,
			entityId: entity.id,
			display: 'TEST',
		});

		entity.pos = Game.instance.world.player.pos.toWorld().floor();
		Game.instance.world.add(entity);
	}

	public static function FromJson(json:Dynamic):SpawnEffect
	{
		var spawnable = EnumTools.createByName(SpawnableType, json.spawnable);

		return new SpawnEffect({
			type: json.type,
			spawnable: spawnable,
			// position: "???",
			outVar: json.outVar,
		});
	}
}
