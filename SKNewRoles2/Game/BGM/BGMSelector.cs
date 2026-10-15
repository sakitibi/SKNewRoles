using Godot;
using System;
using System.Collections.Generic;

namespace SKNewRoles2.Game.BGM
{
    public static class BGMSelector
    {
        /// <summary>
        /// 指定された条件 (直指定 / 候補リスト / 全体) に基づいてインデックスを選出する
        /// </summary>
        public static int SelectIndex(List<string> bgmPaths, int index = -1, uint[] candidates = null)
        {
            if (bgmPaths == null || bgmPaths.Count == 0) return -1;

            // 指定されたインデックスが有効範囲内ならそのまま返す
            if (index >= 0 && index < bgmPaths.Count)
            {
                return index;
            }

            // 候補が指定されている場合
            if (candidates != null && candidates.Length > 0)
            {
                uint[] validCandidates = Array.FindAll(candidates, i => i < (uint)bgmPaths.Count);
                
                if (validCandidates.Length > 0)
                {
                    uint randPos = GD.Randi() % (uint)validCandidates.Length;
                    return (int)validCandidates[randPos];
                }
            }

            // 候補がない、または有効な候補が1つもない場合は全体からランダム選択
            return (int)(GD.Randi() % (uint)bgmPaths.Count);
        }
    }
}