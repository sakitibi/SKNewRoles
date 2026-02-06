#ヒットタグを削除
tag @s remove hit_roar
#ダメージ元を召喚
summon area_effect_cloud ~ ~ ~ {Tags:["roar"]}
#ダメージ処理
damage @s[type=!player] 50 fall
effect give @s wither infinite 0 true
effect give @s slowness infinite 0 true
effect give @s blindness infinite 0 true
effect give @s nausea infinite 0 true
effect give @a[tag=Sorceress,limit=1] invisibility 30 255 true
effect give @a[tag=Sorceress,limit=1] speed 30 4 true
title @a[tag=Sorceress,limit=1] title [{text:"あなたは","color":"red"},{"selector":"@s","color":"red"},{"text":"に魔法をかけた!","color":"red"}]
title @s title {"text":"あなたは魔女に魔法をかけられた!","color":"red"}
playsound minecraft:sorceress-curse master @s ~ ~ ~