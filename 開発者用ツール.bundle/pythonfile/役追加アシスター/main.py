import sys
import os

def ask(prompt: str) -> str:
    """空白を許可せず必ず 1 行値を返す簡易 input ラッパー"""
    while True:
        v = input(prompt).strip()
        if v:
            return v
VERSION:str = "3.2.0.1"
status:int | float = 0
BASE_PATH:str = f"/Applications/13ninTv/function/SKNewRolesv{VERSION}/"
FRAMEWORK_PATH:str = f"ワールド/SKNewRoles v.{VERSION}/datapacks/frameworks/data/werewolf/"
# ANSIエスケープシーケンスを使用した色変更
RED:str = '\033[1;31m' # 赤色
GREEN:str = '\033[1;32m' # 緑色
END:str = '\033[0m' # 色リセット
try:
    jinei_name:str | None = None
    role_color:None | str = None
    tag_role_color = None
    isJinrou:bool = False
    CustomModelData:int = 1
    role_id:str = ask("役職id: ")
    role_name:str = ask("役職名: ")
    jinei_id:str = ask("陣営id(mura|jinrou|other): ")
    team_id:str = ask("チームid: ")
    isJinrou:str = ask("人狼ですか(True|False): ")
    role_unicode:str = ask("役職の\\uExxxのxxx部分を入力: ")
    rolebook_unicode_l:str = ask("役職本の左部分\\uExxxのxxx部分を入力: ")
    rolebook_unicode_r:str = ask("役職本の右部分\\uExxxのxxx部分を入力: ")
    isJinrouSharp:str = "#"
    isJinrouNumber:int = 1
    if isJinrou == "True":
        isJinrouSharp:str = ""
        isJinrouNumber:int = 2
    if jinei_id == "mura":
        jinei_name = "村陣営"
        role_color = "green"
        tag_role_color = "green"
        CustomModelData = 1
    elif jinei_id == "jinrou":
        jinei_name = "狼陣営"
        role_color = "red"
        tag_role_color = "red"
        CustomModelData = 2
    else:
        jinei_name = "第三陣営"
        role_color = "aqua"
        tag_role_color = "pink"
        CustomModelData = 3
    os.makedirs(f"{BASE_PATH}{FRAMEWORK_PATH}functions/.settings/role/count/{role_id}")
    file_texts:dict[str, str] = {
        f"{BASE_PATH}{FRAMEWORK_PATH}functions/.system/result/{jinei_id}.mcfunction": f"\nexecute if entity @a[tag=team_{role_id}] run tellraw @a [{{\"text\":\"<{role_name}>  \",\"color\":\"{role_color}\"}},{{\"selector\":\"@a[tag=team_{role_id}]\",\"color\":\"{role_color}\"}}]",
        f"{BASE_PATH}{FRAMEWORK_PATH}functions/role/.draw/{role_id}.mcfunction": (
            f"""# 村人から{role_name}にシフト(必ず一人選出)
#アーマースタンドから選択
    execute if score {role_name} Role_count matches 1 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=1] add selected
    execute if score {role_name} Role_count matches 2 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=2] add selected
    execute if score {role_name} Role_count matches 3 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=3] add selected
#各アーマースタンドから最も近いプレイヤーを役職変更
    execute as @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!non_player,tag=selected] at @s run team join {team_id} @a[team=Mura,limit=1,sort=nearest]
#使い終わったアーマースタンドをキル
    kill @e[type=armor_stand,tag=player_dummy,tag=selected]

# FFを有効化
    team modify {team_id} friendlyFire true
# ネームタグ不可視
    team modify {team_id} nametagVisibility never
# 透明化不可視
    team modify {team_id} seeFriendlyInvisibles false
# 死亡ログ非表示
    team modify {team_id} deathMessageVisibility never
# 結果出力用の役職タグを付与
    tag @a[team={team_id}] add team_{role_id}
# 陣営タグを付与
    tag @a[team={team_id}] add camp_{tag_role_color}"""
        ),
        f"{BASE_PATH}{FRAMEWORK_PATH}functions/.system/game_end_modules/team_remove/{jinei_id}.mcfunction": f"\nteam remove {team_id}",
        f"{BASE_PATH}{FRAMEWORK_PATH}functions/.system/game_end_modules/team_remove/tags/{jinei_id}.mcfunction": f"\ntag @a remove team_{role_id}",
        f"{BASE_PATH}{FRAMEWORK_PATH}functions/.system/game_start_modules/team_add/{jinei_id}.mcfunction": f"\nteam add {team_id}",
        f"{BASE_PATH}{FRAMEWORK_PATH}functions/.system/game_start_modules/score_add/{jinei_id}.mcfunction": f"\nscoreboard players operation GameManager Role_count += {role_name} Role_count",
        f"{BASE_PATH}{FRAMEWORK_PATH}functions/.settings/role/count/{role_id}/add.mcfunction": (
            f"""\n    execute unless score {role_name} Role_count matches 3 run scoreboard players add {role_name} Role_count 1
    function werewolf:.settings/view_settings_role_mod/2"""
        ),
        f"{BASE_PATH}{FRAMEWORK_PATH}functions/.settings/role/count/{role_id}/remove.mcfunction": (
            f"""\n    execute if score {role_name} Role_count matches 1.. run scoreboard players remove {role_name} Role_count 1
    execute if score {role_name} Role_count matches 0 run scoreboard players reset {role_name} Role_count
    function werewolf:.settings/view_settings_role_mod/2"""
        ),
        f"{BASE_PATH}{FRAMEWORK_PATH}functions/.settings/.debug/change_role/change_{role_id}.mcfunction": (
            f"""#チームに参加
team join {team_id}

#タグをリセット
execute as @s run function werewolf:.settings/.debug/change_role/tag_reset

#タグを付与
tag @s add team_{role_id}
{isJinrouSharp}tag @s add no_jinrou
tag @s add camp_{role_color}

#村/第三陣営=1 人狼陣営(狂人除く)=2
scoreboard players set @s role {isJinrouNumber}

#スキルと役職本リセット
        item replace entity @s hotbar.7 with air
        item replace entity @s hotbar.8 with air
tellraw @s {{"text":"[システムアナウンス] 役職が{role_name}に変更されました"}}"""
        ),
        f"{BASE_PATH}{FRAMEWORK_PATH}functions/.debug_modules/{jinei_id}.mcfunction": f"\ntellraw @s [{{\"text\":\"  {role_name}         \",\"color\":\"white\"}},{{\"text\":\"<変更>\",\"color\":\"{role_color}\",\"clickEvent\":{{\"action\":\"run_command\",\"value\":\"/function werewolf:.settings/.debug/change_role/change_{role_id}\"}}}}]",
        f"{BASE_PATH}{FRAMEWORK_PATH}functions/role/.role_view/{jinei_id}.mcfunction": f"\nexecute as @a[team={team_id}] run title @s title [{{\"text\":\"\\uF811\\uE{role_unicode}\\uF811\",\"font\":\"role\"}}]",
        f"{BASE_PATH}{FRAMEWORK_PATH}functions/role/.set_role_book/{jinei_id}.mcfunction": (
            f"""\n#{role_name}
#execute if entity @s[team={team_id}] run item replace entity @s hotbar.7 with written_book{{CustomModelData:{CustomModelData},Tags:["no_drop","role_book"],pages:['[{{"text":"あなたの役職は…\\n\\n \\u0020"}},{{"text":"{role_name}","bold":true,"color":"green"}},{{"text":" \\u0020です。"}}]'],title:"役職が記された本",author:""}}
execute if entity @s[team={team_id}] run item replace entity @s hotbar.7 with written_book{{CustomModelData:{CustomModelData},resolved:0b,Tags:["no_drop","role_book"],pages:['[[{{"text":"\\uF830\\uE100\\uF826\\uE{rolebook_unicode_l}\\uF832","color":"white","font":"role_book"}}],[{{"text":"\\uE{rolebook_unicode_r}\\uF833","color":"white","font":"role_book"}}]]'],title:"役職が記された本",author:"",HideFlags:32}}"""
        ),
        f"{BASE_PATH}{FRAMEWORK_PATH}functions/role/.ini/scores/{jinei_id}.mcfunction": (
            f"""
#{role_name}
    execute unless score checker Role_count matches 0 run scoreboard players set {role_name} Role_count 1"""
        ),
        f"{BASE_PATH}{FRAMEWORK_PATH}functions/role/.ini/teams/{jinei_id}.mcfunction": f"\n    team join team_{tag_role_color} {role_name}",
        f"{BASE_PATH}{FRAMEWORK_PATH}functions/skill/skill_shinigami/change_role/change_{role_id}.mcfunction": (
            f"""
#チームに参加
team join {team_id}

#タグをリセット
execute as @s run function werewolf:skill/skill_shinigami/change_role/tag_reset

#タグを付与
tag @s add team_{role_id}
{isJinrouSharp}tag @s add no_jinrou
tag @s add camp_{tag_role_color}

#村/第三陣営=1 人狼陣営(狂人除く)=2
scoreboard players set @s role {isJinrouNumber}

#スキルと役職本リセット
item replace entity @s hotbar.7 with air
item replace entity @s hotbar.8 with air"""
        ),
        f"{BASE_PATH}{FRAMEWORK_PATH}functions/skill/skill_shinigami/.shinigami_change_role/{jinei_id}.mcfunction": f"\nexecute if data storage sys: role.shinigami{{stole:{team_id}}} run function werewolf:skill/skill_shinigami/change_role/change_{role_id}",
        f"{BASE_PATH}{FRAMEWORK_PATH}functions/skill/skill_shinigami/.shinigami_store_role/{jinei_id}.mcfunction": f"\nexecute as @s[team={team_id}] run data modify storage sys: role.shinigami.stole set value {team_id}",
        f"{BASE_PATH}{FRAMEWORK_PATH}functions/.system/game_start_modules/role_draw/{jinei_id}.mcfunction": (
            f"""
# 村人から{role_name}にシフト
function werewolf:role/.draw/{role_id}"""
        ),
        f"{BASE_PATH}{FRAMEWORK_PATH}functions/.settings/role/count/reset_count/{jinei_id}.mcfunction": f"\nexecute if score {role_name} Role_count matches 0 run scoreboard players reset {role_name} Role_count",
    }
    for file, text in file_texts.items():
        with open(file, "a", encoding="utf-8") as f:
            try:
                status+= 100 / len(file_texts)
                if(status > 99.999):
                    status = 100
                print(GREEN + f"{file}\nを書き込みします {int(status)}%" + END)
                f.write(text)
            except PermissionError:
                print(RED + f"{file}は権限が無い為書き込み出来ません" + RED)
                sys.exit(1)
            except Exception as e:
                print(RED + "Error:", e + END)
                sys.exit(1)
except KeyboardInterrupt:
    print(RED + "\nスクリプトが中断されました" + END)
    sys.exit(1)