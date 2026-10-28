using Godot;
using System.Collections.Generic;
using SKNewRoles2.Lobby.JOIN.Services.Realtime;

namespace SKNewRoles2.Lobby
{
    public partial class LobbyBridge : Node
    {
        private GodotObject _cppLobbyManager;
        private float _broadcastTimer = 0.0f;
        private const float BroadcastInterval = 0.1f;

        public override async void _Ready()
        {
            _cppLobbyManager = GetParent(); 

            // イベントの購読登録
            RealtimeEvents.OnPlayerTransformReceivedAll += OnPlayerTransformReceivedAll;
            RealtimeEvents.OnPlayerSkinReceived += OnPlayerSkinReceived;
            
            GD.Print("🌁 LobbyBridge: C++へのフル3Dトランスフォーム・スキン仲介システムが正常に起動しました。");

            await RealtimeConnectionService.EnsureConnectedAsync(5000);
            SendMySkin();
        }

        public override void _ExitTree()
        {
            // イベントの解除
            RealtimeEvents.OnPlayerTransformReceivedAll -= OnPlayerTransformReceivedAll;
            RealtimeEvents.OnPlayerSkinReceived -= OnPlayerSkinReceived;
        }

        /// <summary>
        /// 保存された自分のスキンを読み込み、サーバーへブロードキャスト送信します。
        /// </summary>
        private void SendMySkin()
        {
            if (_cppLobbyManager is Node3D lobbyNode3D)
            {
                var myPlayer = lobbyNode3D.GetNodeOrNull<Node3D>("MyPlayer");
                if (myPlayer != null && IsInstanceValid(myPlayer))
                {
                    var mySkins = LobbySkinManager.ApplySavedSkinAndGetPresets(myPlayer);
                    RealtimeLobbySender.LobbySendSkinBroadcast(mySkins);
                }
                else
                {
                    var defaultSkins = LobbySkinManager.ApplySavedSkinAndGetPresets(new Node3D());
                    RealtimeLobbySender.LobbySendSkinBroadcast(defaultSkins);
                }
            }
        }

        public override void _Process(double delta)
        {
            RealtimeLobbyReceiver.PollRealtimeEvents();

            if (_cppLobbyManager is Node3D lobbyNode3D)
            {
                var myPlayer = lobbyNode3D.GetNodeOrNull<Node3D>("MyPlayer");
                if (myPlayer != null && IsInstanceValid(myPlayer))
                {
                    LobbyRealtimeHelper.UpdatePlayerTransformBroadcast(
                        myPlayer, 
                        ref _broadcastTimer, 
                        (float)delta, 
                        BroadcastInterval
                    );
                }
            }
        }

        private void OnPlayerTransformReceivedAll(string playerId, float px, float py, float pz, float rx, float ry, float rz)
        {
            if (_cppLobbyManager != null && IsInstanceValid(_cppLobbyManager))
            {
                if (_cppLobbyManager.HasMethod("update_remote_player_transform"))
                {
                    _cppLobbyManager.Call("update_remote_player_transform", playerId, px, py, pz, rx, ry, rz);
                }
            }
        }

        /// <summary>
        /// 他プレイヤーのスキン情報を受信した際の処理
        /// </summary>
        private void OnPlayerSkinReceived(string playerId, Dictionary<string, string> skinPresets)
        {
            if (_cppLobbyManager != null && IsInstanceValid(_cppLobbyManager))
            {
                if (_cppLobbyManager.HasMethod("update_remote_player_skin"))
                {
                    var godotDict = new Godot.Collections.Dictionary<string, string>();
                    foreach (var kvp in skinPresets)
                    {
                        godotDict[kvp.Key] = kvp.Value;
                    }

                    _cppLobbyManager.Call("update_remote_player_skin", playerId, godotDict);
                    GD.Print($"🎨 [LobbyBridge] C++側へリモートプレイヤー ({playerId}) のスキン適用を要求しました。");
                }
            }
        }
    }
}