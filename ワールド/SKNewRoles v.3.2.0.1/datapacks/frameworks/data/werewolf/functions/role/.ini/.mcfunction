    # 役職表示リスト関連
        #役職人数管理のスコアボード作成
            scoreboard objectives add Role_count dummy "役職一覧"

            function werewolf:role/.ini/scores/mura
            function werewolf:role/.ini/scores/jinrou
            function werewolf:role/.ini/scores/other

        function werewolf:.settings/role/count/reset_count

        #これまでに役職一覧を読み込んだことがあるか判定するたのスコア
            scoreboard players set checker Role_count 0

        #役職の表示色変更
            function werewolf:role/.ini/teams/mura
            function werewolf:role/.ini/teams/jinrou
            function werewolf:role/.ini/teams/other

        #役職をサイドバーに表示
                scoreboard objectives setdisplay sidebar Role_count


    # 役職関連
        #人狼判定の追加/ゲーム開始前:0 人狼でない:1 人狼:2
            scoreboard objectives add role dummy
    
    # 同数モード用の人数カウント
        scoreboard objectives add red_count dummy
        scoreboard objectives add green_count dummy
        scoreboard objectives add blue_count dummy
        scoreboard objectives add pink_count dummy