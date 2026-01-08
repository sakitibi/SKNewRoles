#罠の位置にtp用マーカー設置
execute at @e[type=marker,tag=pitfall,tag=!inactive,limit=1,sort=nearest] positioned ~ ~-1 ~ run summon marker ~ ~ ~ {Tags:["pitfall_tp"]}
data modify entity @e[type=marker,tag=pitfall_tp,limit=1,sort=nearest] Rotation[0] set from entity @s Rotation[0]

#罠に落ちた時のtp用判定
scoreboard players set @s fall_into_a_pitfall 100

#落とし穴アニメーションを召喚
execute at @e[type=marker,tag=pitfall,tag=!inactive,limit=1,sort=nearest] run function Adv_Map_Creator_data:animated_java/pitfall/summon
execute at @e[type=marker,tag=pitfall,tag=!inactive,limit=1,sort=nearest] as @e[type=#Adv_Map_Creator_data:animated_java/root,tag=aj.pitfall.root,limit=1,sort=nearest] run function Adv_Map_Creator_data:animated_java/pitfall/animations/genarate/play
data modify entity @e[type=#Adv_Map_Creator_data:animated_java/root,tag=aj.pitfall.root,limit=1,sort=nearest] Rotation[1] set value 0f

#演出
execute at @e[type=marker,tag=pitfall,tag=!inactive,limit=1,sort=nearest] run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a
execute at @e[type=marker,tag=pitfall,tag=!inactive,limit=1,sort=nearest] run particle minecraft:explosion ~ ~ ~
execute at @e[type=marker,tag=pitfall,tag=!inactive,limit=1,sort=nearest] run playsound minecraft:fall_in_a_hole master @a[distance=..5]

#最も近くにある罠を削除
kill @e[type=marker,tag=pitfall,tag=!inactive,limit=1,sort=nearest]

#自身にデバフ
tellraw @s[team=!Witch] "あなたは落とし穴に落ちてしまった…!"
effect give @s[team=!Witch] jump_boost 20 250 true
effect give @s[team=!Witch] slowness 20 255 true
effect give @s[team=!Witch] blindness 20 255 true
effect give @s[team=!Witch] darkness 20 255 true
execute if entity @a[team=Witch] run effect give @s[team=!Witch] wither 20 0 true
execute if entity @a[team=Wanashi] run tellraw @s[team=Witch] [{"text":"今回の罠師は… "},{"selector":"@a[team=Wanashi]"},{"text":" のようだ。"}]
execute unless entity @a[team=Wanashi] run tellraw @s[team=Witch] [{"text":"今回罠師は居ないようだ…"}]