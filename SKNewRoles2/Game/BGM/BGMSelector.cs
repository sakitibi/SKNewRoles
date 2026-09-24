using Godot;
using System.Collections.Generic;

namespace SKNewRoles2.Game.BGM
{
    public static class BGMSelector
    {
        /// <summary>
        /// 指定された条件 (直指定 / 候補リスト / 全体) に基づいてインデックスを選出する
        /// </summary>
        public static int SelectIndex(List<string> bgmPaths, int index = -1, List<int> candidates = null)
        {
            if (bgmPaths == null || bgmPaths.Count == 0) return -1;

            if (index >= 0 && index < bgmPaths.Count)
            {
                return index;
            }

            if (candidates != null && candidates.Count > 0)
            {
                List<int> validCandidates = candidates.FindAll(i => i >= 0 && i < bgmPaths.Count);
                if (validCandidates.Count > 0)
                {
                    int randPos = (int)(GD.Randi() % (uint)validCandidates.Count);
                    return validCandidates[randPos];
                }
            }

            return (int)(GD.Randi() % (uint)bgmPaths.Count);
        }
    }
}