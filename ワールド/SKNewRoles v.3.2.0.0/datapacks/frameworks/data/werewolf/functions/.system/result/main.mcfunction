    # 今回の役職配分を出力
        tellraw @a {"text":"[Result]"}
        execute if data storage sys: win run tellraw @a [{"text":"勝利陣営: "},{"interpret":true,"nbt":"win.camp","storage":"sys:"},{"text":"\n勝利要因: "},{"interpret":true,"nbt":"win.cause","storage":"sys:"}]
        execute if data storage sys: win if entity @a[team=Ojousama] unless data storage sys: win{camp:'[{"text":"村陣営 (","color":"green"},{"selector":"@a[tag=camp_green]","color":"green"},{"text":")","color":"green"}]'} run tellraw @a [{"text":"追加勝利: ","color":"white"},{"selector":"@a[tag=team_ojousama]","color":"green"},{"text":"(オポチュニスト)","color":"green"}]
        execute if data storage sys: win run tellraw @a [{"text":"--------------------------------------","color":"white"}]
        function werewolf:.system/result/jinrou
        function werewolf:.system/result/mura
        function werewolf:.system/result/other
        execute if entity @a[tag=team_haitoku] run tellraw @a [{"text":"背徳者になったプレイヤー ","color":"aqua"},{"selector":"@a[tag=team_haitoku]","color":"aqua"}]
        execute if entity @a[tag=ex_shinigami] run tellraw @a [{"text":"死神だったプレイヤー: ","color":"aqua"},{"selector":"@a[tag=ex_shinigami]","color":"aqua"}]
        execute if entity @a[tag=lovers] run tellraw @a [{"text":"ラバーズになったプレイヤー: ","color":"aqua"},{"selector":"@a[tag=lovers]","color":"aqua"}]
        execute if entity @a[tag=team_sidekick] run tellraw @a [{"text":"サイドキックになったプレイヤー ","color":"aqua"},{"selector":"@a[tag=team_sidekick]","color":"aqua"}]
        execute if entity @a[tag=team_enchant_kyoujin] run tellraw @a [{"text":"魅惑的な魔女に魅了されたプレイヤー","color":"red"},{"selector":"@a[tag=team_kyoujin]","color":"red"}]

        data remove storage sys: win