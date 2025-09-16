execute if score result login_check matches 0 run function elibrary:auth_token/login
execute if score result login_check matches 1 run tellraw @a {"text":"すでにログインしています!"}