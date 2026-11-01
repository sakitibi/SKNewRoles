using Godot;
using System;
using System.Threading.Tasks;
using System.Collections.Generic;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Lobby
{
    public class LobbyRemotePlayerManager(Node3D owner, PackedScene dummyPlayerPrefab, Dictionary<string, Node3D> otherPlayers)
    {
        public void HandleTransformReceived(
            string playerId, 
            float px, float py, float pz, 
            float rx, float ry, float rz, 
            Func<string, float, float, float, float, float, float, Task> onSpawnNeeded)
        {
            string myId = SessionManager.Instance.CurrentSession?.User?.Id;

            if (!string.IsNullOrEmpty(myId) && playerId == myId)
            {
                return;
            }

            if (otherPlayers.TryGetValue(playerId, out Node3D remotePlayerNode))
            {
                if (GodotObject.IsInstanceValid(remotePlayerNode))
                {
                    if (remotePlayerNode.HasMethod("set_target_transform"))
                    {
                        remotePlayerNode.Call("set_target_transform", px, py, pz, rx, ry, rz);
                    }
                    else
                    {
                        remotePlayerNode.Position = new Vector3(px, py, pz);
                        remotePlayerNode.Rotation = new Vector3(rx, ry, rz);
                    }
                }
            }
            else
            {
                // プレイヤーが存在しない場合はスポーン用のコールバックを実行
                _ = onSpawnNeeded(playerId, px, py, pz, rx, ry, rz);
            }
        }

        public async Task SpawnRemotePlayerAsync(
            string playerId, 
            float px, float py, float pz, 
            float rx, float ry, float rz, 
            Dictionary<string, Dictionary<string, string>> remotePlayerSkins, 
            Node3D myPlayerInstance)
        {
            if (dummyPlayerPrefab == null)
            {
                GD.PrintErr($"❌ [LobbyRemotePlayerManager] 相手プレイヤー(ID: {playerId})を生成しようとしましたが, dummyPlayerPrefab が null です！");
                return;
            }

            if (otherPlayers.ContainsKey(playerId)) return;

            GD.Print($"✨ [LobbyRemotePlayerManager] 新しいリモートプレイヤーを検知・生成します！ ID: {playerId}");
            
            Node3D remotePlayer = dummyPlayerPrefab.Instantiate<Node3D>();
            remotePlayer.Position = new Vector3(px, py, pz);
            remotePlayer.Rotation = new Vector3(rx, ry, rz);
            remotePlayer.Name = $"RemotePlayer_{playerId}";

            if (remotePlayer.HasMethod("set_target_transform"))
            {
                remotePlayer.Call("set_target_transform", px, py, pz, rx, ry, rz);
            }

            owner.AddChild(remotePlayer);
            otherPlayers[playerId] = remotePlayer;

            if (remotePlayerSkins.TryGetValue(playerId, out var skinPresets))
            {
                GD.Print($"🎨 [LobbyRemotePlayerManager] プレハブ生成完了。キャッシュされたスキンを遅延適用します: ID={playerId}, Count={skinPresets?.Count ?? 0}");
                
                Callable.From(() => {
                    if (GodotObject.IsInstanceValid(remotePlayer))
                    {
                        LobbySkinManager.ApplySkinPresets(remotePlayer, skinPresets);
                        GD.Print($"🎨 [LobbyRemotePlayerManager] Deferred application of skin completed for: {playerId}");
                    }
                }).CallDeferred();
            }
            else
            {
                GD.Print($"⚠️ [LobbyRemotePlayerManager] 生成時、ID={playerId} のスキンキャッシュはまだありません。");
            }

            if (myPlayerInstance != null && GodotObject.IsInstanceValid(myPlayerInstance))
            {
                _ = JOIN.Services.Realtime.RealtimeLobbySender.LobbySendTransformBroadcastAll(
                    myPlayerInstance.Position.X,
                    myPlayerInstance.Position.Y,
                    myPlayerInstance.Position.Z,
                    myPlayerInstance.Rotation.X,
                    myPlayerInstance.Rotation.Y,
                    myPlayerInstance.Rotation.Z
                );
            }
        }
    }
}