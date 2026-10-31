using Godot;
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
            if (playerInstance == null || !GodotObject.IsInstanceValid(playerInstance))
            {
                GD.PrintErr("[LobbySkinManager] Error: playerInstance is null or invalid.");
                return new(DefaultPresets);
            }

            ConfigFile config = new();
            Error err = config.Load("user://player_skin.cfg");
            
            Dictionary<string, string> equippedPresets = new(DefaultPresets);

            if (err == Error.Ok)
            {
                GD.Print("[LobbySkinManager] Successfully loaded user://player_skin.cfg");
                foreach (string partName in equippedPresets.Keys)
                {
                    if (config.HasSectionKey("PlayerSkin", partName))
                    {
                        equippedPresets[partName] = (string)config.GetValue("PlayerSkin", partName);
                        GD.Print($"[LobbySkinManager] Loaded preset for '{partName}': {equippedPresets[partName]}");
                    }
                }
            }
            else
            {
                GD.Print("[LobbySkinManager] Warning: Saved skin config not found, using default presets.");
            }

            ApplySkinPresets(playerInstance, equippedPresets);
            return equippedPresets;
        }

        /// <summary>
        /// 指定されたスキンのプリセット情報を任意のプレイヤー（リモート含む）に適用します。
        /// </summary>
        public static void ApplySkinPresets(Node3D playerInstance, Dictionary<string, string> skinPresets)
        {
            if (playerInstance == null || !GodotObject.IsInstanceValid(playerInstance))
            {
                GD.PrintErr("[LobbySkinManager] Error: ApplySkinPresets failed because playerInstance is null or invalid.");
                return;
            }
            if (skinPresets == null || skinPresets.Count == 0)
            {
                GD.PrintErr("[LobbySkinManager] Error: ApplySkinPresets failed because skinPresets is null or empty.");
                return;
            }

            GD.Print($"[LobbySkinManager] Applying skin presets to player: {playerInstance.Name}, Total presets: {skinPresets.Count}");

            Node painter = playerInstance.GetNodeOrNull("SkinPainter");
            if (painter == null)
            {
                GD.Print("[LobbySkinManager] SkinPainter not found in player instance. Instantiating via ClassDB...");
                Variant variant = ClassDB.Instantiate("SkinPainter");
                if (variant.Obj is Node nodeInstance)
                {
                    painter = nodeInstance;
                    painter.Name = "SkinPainter";
                    playerInstance.AddChild(painter);
                    GD.Print("[LobbySkinManager] Successfully instantiated and added SkinPainter.");
                }
                else
                {
                    GD.PrintErr("[LobbySkinManager] Error: Failed to instantiate 'SkinPainter' via ClassDB.");
                }
            }
            else
            {
                GD.Print("[LobbySkinManager] Found existing SkinPainter node.");
            }

            if (painter != null && GodotObject.IsInstanceValid(painter))
            {
                GD.Print("[LobbySkinManager] Initializing SkinPainter and applying presets...");
                painter.Call("initialize", playerInstance);

                var godotDict = new Godot.Collections.Dictionary<string, string>();
                foreach (var kvp in skinPresets)
                {
                    godotDict[kvp.Key] = kvp.Value;
                    GD.Print($"[LobbySkinManager] Preset mapping -> Part: {kvp.Key}, Preset: {kvp.Value}");
                }
                
                painter.Call("apply_preset_to_all_parts", godotDict);
                GD.Print("[LobbySkinManager] Successfully called apply_preset_to_all_parts on SkinPainter.");
            }
            else
            {
                GD.PrintErr("[LobbySkinManager] Error: painter node is invalid, cannot apply skin presets.");
            }
        }
    }
}