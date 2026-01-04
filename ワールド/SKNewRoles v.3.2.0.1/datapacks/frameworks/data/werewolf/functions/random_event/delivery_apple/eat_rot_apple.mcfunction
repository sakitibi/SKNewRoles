execute as @s[predicate=werewolf:random_chance/eat_rot_apple] run tag @s add stomachache

effect give @s[tag=stomachache] hunger 10 20
effect give @s[tag=stomachache] poison 5 0

tag @s remove stomachache

advancement revoke @s only werewolf:random_event/event_8/eat_rot_apple