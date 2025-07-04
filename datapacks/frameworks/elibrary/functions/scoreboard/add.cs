using System;

public class ScoreboardSetup
{
    public void AddObjectives()
    {
        // タスク用のブロック破壊検知用スコアボード
        AddObjective("mined.oak_log", "mined:oak_log");
        AddObjective("mined.iron_ore", "mined:iron_ore");
        AddObjective("mined.wheat", "mined:wheat");
        AddObjective("mined.red_mushroom", "mined:red_mushroom");
        AddObjective("mined.brown_mushroom", "mined:brown_mushroom");

        // タスク用スイッチャー
        AddObjective("can_mining", "dummy");
        AddObjective("skill_jinrou_slash_limit", "dummy");
        AddObjective("skill_jinrou_slash_frequency", "dummy");
        AddObjective("RimokonOperationTimes", "dummy");
        AddObjective("skill_mode", "dummy");
        AddObjective("skill_jinrou_slash_cooltime", "dummy");

        // 人狼の咆哮設定
        AddObjective("charge_roar", "dummy");
        AddObjective("skill_jinrou_roar_cooltime", "dummy");
        AddObjective("skill_witch_slash_cooltime", "dummy");
        AddObjective("skill_witch_roar_cooltime", "dummy");

        // クールタイム可視化用
        for (int i = 1; i <= 10; i++)
        {
            AddObjective($"cooltime_jinrou_roar_{i}", "dummy");
            AddObjective($"cooltime_sniper_{i}", "dummy");
        }

        // シーアのフラッシュ用
        AddObjective("seer_flash", "dummy");

        // Warlock用
        AddObjective("warlock_curse", "dummy");

        // GuesserPlugins連携
        AddObjective("meeting", "dummy");

        // 社長用
        AddObjective("emerald_give", "dummy");

        // さつまといも用 0-c/1-m
        AddObjective("satsumatoimo_role", "dummy");
    }

    private void AddObjective(string name, string criteria)
    {
        Console.WriteLine($"Adding scoreboard objective: {name} ({criteria})");
    }
}