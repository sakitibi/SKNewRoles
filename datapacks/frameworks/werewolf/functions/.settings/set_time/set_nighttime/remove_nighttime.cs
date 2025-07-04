using System;
using werewolf.data.werewolf.functions..settings;

public class RemoveNightTime
{
    static void Main()
    {
        if(set_nighttime == null)
        {
            public static int set_nighttime = 1200;
        }

        if(set_nighttime_minutes == null)
        {
            public static int set_nighttime_minutes = 0;
        }

        set_nighttime -= 1200;
        Console.WriteLine($"set_nighttime: {set_nighttime}");

        set_nighttime_minutes = set_nighttime;
        Console.WriteLine($"set_nighttime_minutes (before division): {set_nighttime_minutes}");

        set_nighttime_minutes /= tick_minute;
        Console.WriteLine($"set_nighttime_minutes (after division): {set_nighttime_minutes}");

        Console.WriteLine("[INFO] Call function: werewolf:.settings/view_settings_others (simulated)");
    }
}
