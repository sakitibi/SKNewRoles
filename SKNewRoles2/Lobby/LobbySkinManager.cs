using Godot;
using SKNewRoles2.Game;
using System.Collections.Generic;

namespace SKNewRoles2.Lobby
{
    public static class LobbySkinManager
    {
        private static readonly Dictionary<string, string> DefaultPresets = new()
        {
            { "Head",     "preset_1" },
            { "Body",     "preset_1" },
            { "RightArm", "preset_1" },
            { "LeftArm",  "preset_1" },
            { "RightLeg", "preset_1" },
            { "LeftLeg",  "preset_1" }
        };

        /// <summary>
        /// 保存されたスキン設定を読み込んでプレイヤーに適用し、その設定辞書を返します。
        /// </summary>
        public static Dictionary<string, string> ApplySavedSkinAndGetPresets(Node3D playerInstance)
        {
            if (playerInstance == null || !GodotObject.IsInstanceValid(playerInstance)) return new(DefaultPresets);

            var config = new ConfigFile();
            Error err = config.Load("user://player_skin.cfg");
            
            Dictionary<string, string> equippedPresets = new(DefaultPresets);

            if (err == Error.Ok)
            {
                foreach (string partName in equippedPresets.Keys)
                {
                    if (config.HasSectionKey("PlayerSkin", partName))
                    {
                        equippedPresets[partName] = (string)config.GetValue("PlayerSkin", partName);
                    }
                }
            }
            else
            {
                GD.Print("[LobbySkinManager] 保存されたスキン設定が見つからないため、デフォルトを使用します。");
            }

            ApplySkinPresets(playerInstance, equippedPresets);
            return equippedPresets;
        }

        /// <summary>
        /// 指定されたスキンのプリセット情報を任意のプレイヤー（リモート含む）に適用します。
        /// </summary>
        public static void ApplySkinPresets(Node3D playerInstance, Dictionary<string, string> skinPresets)
        {
            if (playerInstance == null || !GodotObject.IsInstanceValid(playerInstance)) return;
            if (skinPresets == null || skinPresets.Count == 0) return;

            var painter = playerInstance.GetNodeOrNull<SkinPainter>("SkinPainter");
            if (painter == null)
            {
                painter = new SkinPainter();
                playerInstance.AddChild(painter);
                painter.Name = "SkinPainter";
            }

            painter.Initialize(playerInstance);
            painter.ApplyPresetToAllParts(skinPresets);
        }
    }
}