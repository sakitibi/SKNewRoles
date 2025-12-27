# ここから属性付与
effect give @a[tag=1] speed 1 1 true
effect give @a[tag=2] strength 1 1 true
effect give @a[tag=3] night_vision 1 255 true
effect give @a[tag=4] health_boost 1 3 true
# tag=5〜7と11と12の処理は多いのでそれ用のスクリプト呼び出し
execute if entity @a[tag=5,scores={randomattribute=0}] run function werewolf:.system/anattribute/tag5
execute if entity @a[tag=6,scores={randomattribute=1}] run function werewolf:.system/anattribute/tag6
execute if entity @a[tag=7,scores={randomattribute=2}] run function werewolf:.system/anattribute/tag7
effect give @a[tag=8] jump_boost 1 2 true
effect give @a[tag=!9] slowness 1 0 true
effect give @a[tag=!10] weakness 1 1 true
execute if entity @a[tag=11,scores={randomattribute=3}] at @s run function werewolf:.system/anattribute/tag11
execute if entity @a[tag=12,team=Witch] at @s run function werewolf:.system/anattribute/tag12
# 13は未実装