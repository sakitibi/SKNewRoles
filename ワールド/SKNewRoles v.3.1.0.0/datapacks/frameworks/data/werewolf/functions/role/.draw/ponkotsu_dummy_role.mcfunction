#ダミー役職候補を召喚
execute if data storage sys: {ponkotsu_mode:0} if score 人狼 Role_count matches 1.. run summon armor_stand ~ ~ ~ {Tags:["ponkotsu_role_dummy","jinrou"],Marker:true,Invisible:true,NoGravity:true}
#execute if data storage sys: {ponkotsu_mode:0} if score 罠師 Role_count matches 1.. run summon armor_stand ~ ~ ~ {Tags:["ponkotsu_role_dummy","wanashi"],Marker:true,Invisible:true,NoGravity:true}
execute if score 占い師 Role_count matches 1.. run summon armor_stand ~ ~ ~ {Tags:["ponkotsu_role_dummy","uranai"],Marker:true,Invisible:true,NoGravity:true}
execute if score 霊能者 Role_count matches 1.. run summon armor_stand ~ ~ ~ {Tags:["ponkotsu_role_dummy","reinou"],Marker:true,Invisible:true,NoGravity:true}
execute if score 騎士 Role_count matches 1.. run summon armor_stand ~ ~ ~ {Tags:["ponkotsu_role_dummy","kishi"],Marker:true,Invisible:true,NoGravity:true}
execute if score シェリフ Role_count matches 1.. run summon armor_stand ~ ~ ~ {Tags:["ponkotsu_role_dummy","hoankan"],Marker:true,Invisible:true,NoGravity:true}
execute if score オポチュニスト Role_count matches 1.. run summon armor_stand ~ ~ ~ {Tags:["ponkotsu_role_dummy","ojousama"],Marker:true,Invisible:true,NoGravity:true}
execute if score 裁判官 Role_count matches 1.. run summon armor_stand ~ ~ ~ {Tags:["ponkotsu_role_dummy","saibankan"],Marker:true,Invisible:true,NoGravity:true}
#役職抽選
execute as @e[type=armor_stand,tag=ponkotsu_role_dummy,sort=random,limit=1] run tag @s add this
#ダミー役職を付与
execute if entity @e[type=armor_stand,tag=ponkotsu_role_dummy,tag=this,tag=jinrou] run tag @s add jinrou_dummy
execute if entity @e[type=armor_stand,tag=ponkotsu_role_dummy,tag=this,tag=wanashi] run tag @s add wanashi_dummy
execute if entity @e[type=armor_stand,tag=ponkotsu_role_dummy,tag=this,tag=uranai] run tag @s add uranai_dummy
execute if entity @e[type=armor_stand,tag=ponkotsu_role_dummy,tag=this,tag=reinou] run tag @s add reinou_dummy
execute if entity @e[type=armor_stand,tag=ponkotsu_role_dummy,tag=this,tag=kishi] run tag @s add kishi_dummy
execute if entity @e[type=armor_stand,tag=ponkotsu_role_dummy,tag=this,tag=hoankan] run tag @s add hoankan_dummy
execute if entity @e[type=armor_stand,tag=ponkotsu_role_dummy,tag=this,tag=ojousama] run tag @s add ojousama_dummy
execute if entity @e[type=armor_stand,tag=ponkotsu_role_dummy,tag=this,tag=saibankan] run tag @s add saibankan_dummy
#ダミー役職候補をキル
kill @e[type=armor_stand,tag=ponkotsu_role_dummy]