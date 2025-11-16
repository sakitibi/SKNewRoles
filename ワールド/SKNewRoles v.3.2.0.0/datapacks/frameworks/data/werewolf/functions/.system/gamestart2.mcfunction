#乱数の偏り防止のための処理-2
execute store result score GameManager member_count if entity @e[team=Sanka,type=armor_stand,tag=player_dummy]

execute if score GameManager member_count < GameManager Role_count run summon armor_stand ~ ~ ~ {Team:"Sanka",Tags:["player_dummy","non_player"],Marker:true,Invisible:true,NoGravity:true}
execute if score GameManager member_count >= GameManager Role_count run schedule function werewolf:.system/gamestart3 1t append true

execute if score GameManager member_count < GameManager Role_count run schedule function werewolf:.system/gamestart2 1t append true