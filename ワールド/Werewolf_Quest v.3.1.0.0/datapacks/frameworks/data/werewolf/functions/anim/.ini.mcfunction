# 風車のアニメーション設定
execute unless data storage anim: windmill run data modify storage anim: windmill set value 1
execute if data storage anim: {windmill:1} run execute as @e[type=#Adv_Map_Creator_data:animated_java/root,tag=aj.windmill.root] run function Adv_Map_Creator_data:animated_java/windmill/animations/rotation/stop