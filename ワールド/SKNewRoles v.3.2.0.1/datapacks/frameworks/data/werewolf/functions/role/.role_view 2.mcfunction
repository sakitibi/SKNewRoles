execute as @a[tag=player] as @s run summon marker ~ ~ ~ {Tags:["player_lock"]}
execute as @a[tag=player] as @s run tp @e[type=marker,sort=nearest,limit=1] @s
effect give @s blindness 3 255 true

stopsound @a

execute as @a[tag=camp_green,team=!Ponkotsu] at @s run playsound minecraft:game_start_1 master @s
execute as @a[tag=camp_red] at @s run playsound minecraft:game_start_2 master @s
execute as @a[tag=camp_pink] at @s run playsound minecraft:game_start_3 master @s

execute as @a run title @s subtitle {"text":"\uE001","font":"role"}

execute as @a[tag=!player] run title @s title [{"text":"\uF811\uE000\uF811","font":"role"}]

function werewolf:role/.role_view/mura
function werewolf:role/.role_view/jinrou
function werewolf:role/.role_view/other

#ポンコツ用
execute as @a[team=Ponkotsu,tag=jinrou_dummy] at @s run playsound minecraft:game_start_2 master @s
execute as @a[team=Ponkotsu,tag=jinrou_dummy] run title @s title [{"text":"\uF811\uE101\uF811","font":"role"}]
execute as @a[team=Ponkotsu,tag=wanashi_dummy] at @s run playsound minecraft:game__2 master @s
execute as @a[team=Ponkotsu,tag=wanashi_dummy] run title @s title [{"text":"\uF811\uE104\uF811","font":"role"}]
execute as @a[team=Ponkotsu,tag=uranai_dummy] at @s run playsound minecraft:game__1 master @s
execute as @a[team=Ponkotsu,tag=uranai_dummy] run title @s title [{"text":"\uF811\uE003\uF811","font":"role"}]
execute as @a[team=Ponkotsu,tag=reinou_dummy] at @s run playsound minecraft:game__1 master @s
execute as @a[team=Ponkotsu,tag=reinou_dummy] run title @s title [{"text":"\uF811\uE004\uF811","font":"role"}]
execute as @a[team=Ponkotsu,tag=kishi_dummy] at @s run playsound minecraft:game__1 master @s
execute as @a[team=Ponkotsu,tag=kishi_dummy] run title @s title [{"text":"\uF811\uE005\uF811","font":"role"}]
execute as @a[team=Ponkotsu,tag=hoankan_dummy] at @s run playsound minecraft:game__1 master @s
execute as @a[team=Ponkotsu,tag=hoankan_dummy] run title @s title [{"text":"\uF811\uE007\uF811","font":"role"}]
execute as @a[team=Ponkotsu,tag=ojousama_dummy] at @s run playsound minecraft:game__1 master @s
execute as @a[team=Ponkotsu,tag=ojousama_dummy] run title @s title [{"text":"\uF811\uE009\uF811","font":"role"}]
execute as @a[team=Ponkotsu,tag=saibankan_dummy] at @s run playsound minecraft:game__1 master @s
execute as @a[team=Ponkotsu,tag=saibankan_dummy] run title @s title [{"text":"\uF811\uE00A\uF811","font":"role"}]

effect give @a[tag=player] luck 4 0 true
function werewolf:role/.role_view_lock