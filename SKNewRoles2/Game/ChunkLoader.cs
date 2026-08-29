using Godot;
using System.Threading.Tasks;

namespace SKNewRoles2.Game
{
    public class ChunkLoader
    {
        public async Task WaitForInitialChunksLoadedAsync(Node3D chunkManagerCpp)
        {
            int timeoutMs = 10000;
            int elapsedMs = 0;
            int checkIntervalMs = 100;

            if (chunkManagerCpp == null)
            {
                GD.PrintErr("❌ [ChunkLoader] ChunkManager ノードが見つかりません。");
                return;
            }

            if (!chunkManagerCpp.HasMethod("is_initial_load_complete"))
            {
                GD.PrintErr("❌ [ChunkLoader] ChunkManager に 'is_initial_load_complete' メソッドがバインドされていません。");
                return;
            }

            while (elapsedMs < timeoutMs)
            {
                Variant res = chunkManagerCpp.Call("is_initial_load_complete");

                if (res.VariantType == Variant.Type.Bool && (bool)res)
                {
                    GD.Print($"✅ [ChunkLoader] チャンクの初期読込が完了しました ({elapsedMs}ms経過)。");
                    return;
                }

                await Task.Delay(checkIntervalMs);
                elapsedMs += checkIntervalMs;
            }

            GD.PrintErr("⚠️ [ChunkLoader] チャンク初期読込がタイムアウトしました。処理を続行します。");
        }
    }
}