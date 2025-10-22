#確率で食あたり
execute if entity @a[team=!Witch] as @s[predicate=werewolf:random_chance/eat_event_salmon] run effect give @s[team=!Witch] hunger 15 2 true
execute if entity @a[team=!Witch] as @s[predicate=werewolf:random_chance/eat_event_salmon] run effect give @s[team=!Witch] poison 15 0 true
execute if entity @a[team=!Witch] as @s[predicate=werewolf:random_chance/eat_event_salmon] run effect give @s[team=!Witch] nausea 15 1 true

execute if entity @a[team=Witch] as @s[predicate=werewolf:random_chance/eat_event_salmon] run effect give @s[team=!Witch] hunger 30 2 true
execute if entity @a[team=Witch] as @s[predicate=werewolf:random_chance/eat_event_salmon] run effect give @s[team=!Witch] poison 30 2 true
execute if entity @a[team=Witch] as @s[predicate=werewolf:random_chance/eat_event_salmon] run effect give @s[team=!Witch] nausea 30 2 true
execute if entity @a[team=Witch] as @s[predicate=werewolf:random_chance/eat_event_salmon] run effect give @s[team=!Witch] blindness 30 255 true
execute if entity @a[team=Witch] as @s[predicate=werewolf:random_chance/eat_event_salmon] run scoreboard players add @s[team=!Witch,scores={warlock_curse=0..3000}] warlock_curse 500

advancement revoke @s only werewolf:random_event/event_3/eat_event_salmon