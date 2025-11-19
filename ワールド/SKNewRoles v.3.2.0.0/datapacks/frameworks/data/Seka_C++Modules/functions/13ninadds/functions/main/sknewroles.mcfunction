# 基本的なテキスト表示処理
    #本データパック関連
        execute if score 13ninAddManager add_random matches 1400 run tellraw @a "SKNewRolesは超大手ゲーム実況者13ninTV(さきちび)によって開発されたゲームです、ぜひシェアしてみて下さい!"
        execute if score 13ninAddManager add_random matches 1500 run tellraw @a[team=Witch,tag=!Sorceress,tag=!Enchantress,tag=!Warlock] {"text":"相手に魔法をかけましょう","color":"red"}
        execute if score 13ninAddManager add_random matches 1500 run tellraw @a[team=Witch,tag=Sorceress,tag=!Enchantress,tag=!Warlock] {"text":"相手に魔法をかけて、時間差キルをしましょう","color":"red"}
        execute if score 13ninAddManager add_random matches 1500 run tellraw @a[team=Witch,tag=!Sorceress,tag=Enchantress,tag=!Warlock] {"text":"相手を魅了する魔法をかけましょう\n相手を魅了する魔法をかけて心を奪い、\n仲間にしましょう","color":"red"}
        execute if score 13ninAddManager add_random matches 1500 run tellraw @a[team=Witch,tag=!Sorceress,tag=!Enchantress,tag=Warlock] {"text":"相手を呪う魔法をかけてみましょう\n相手を魔法で呪って徐々に弱らせていきましょう","color":"red"}
        execute if score 13ninAddManager add_random matches 1500 run tellraw @a[team=Satsumatoimo,scores={satsumatoimo_role=0}] {"text":"毎朝、陣営が変わるので気を付けて下さい","color":"green"}
        execute if score 13ninAddManager add_random matches 1500 run tellraw @a[team=Satsumatoimo,scores={satsumatoimo_role=1}] {"text":"毎朝、陣営が変わるので気を付けて下さい","color":"red"}
        execute unless data storage sys: {witch_weakness:true} if score 13ninAddManager add_random matches 1600 run tellraw @a[team=Witch] {text:"魔女は魔法が得意だ","color":"red"}
        execute if data storage sys: {witch_weakness:true} if score 13ninAddManager add_random matches 1600 run tellraw @a[team=Witch] {text:"魔女は魔法が得意で近接攻撃が苦手だ","color":"red"}