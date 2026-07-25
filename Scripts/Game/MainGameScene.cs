using Godot;
using System.Collections.Generic;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Game
{
    public partial class MainGameScene : Node3D
    {
        private Node _roleManagerCpp;
        private Node3D _chunkManagerCpp;

        public int MyRole { get; private set; } = -1;
        public int MyFaction { get; private set; } = -1;

        private PackedScene _playerScene = GD.Load<PackedScene>("res://Scenes/Prefabs/Player.tscn");
        private PackedScene _opponentScene = GD.Load<PackedScene>("res://Scenes/Prefabs/LobbyPlayerDummy.tscn");

        // 自分およびリモートプレイヤーのインスタンス管理
        private Node3D _myPlayerInstance;
        private Dictionary<string, Node3D> _otherPlayers = new Dictionary<string, Node3D>();

        // UIノード参照
        private Control _loadingScene;
        private Control _roleRevealScene;
        private Label _factionLabel;
        private Label _roleTitleLabel;
        private Label _descriptionLabel;

        private bool _hasRoleReceived = false;

        public override async void _Ready()
        {
            // UIノードの参照取得
            _loadingScene = GetNodeOrNull<Control>("UILayer/LoadingScene");
            _roleRevealScene = GetNodeOrNull<Control>("UILayer/RoleRevealScene");

            if (_roleRevealScene != null)
            {
                _factionLabel = _roleRevealScene.GetNodeOrNull<Label>("MainContainer/VBoxContainer/FactionLabel");
                _roleTitleLabel = _roleRevealScene.GetNodeOrNull<Label>("MainContainer/VBoxContainer/RoleTitleLabel");
                _descriptionLabel = _roleRevealScene.GetNodeOrNull<Label>("MainContainer/VBoxContainer/DescriptionLabel");
                _roleRevealScene.Visible = false;
            }

            // ロード画面を表示
            if (_loadingScene != null)
            {
                _loadingScene.Visible = true;
            }

            _roleManagerCpp = GetNodeOrNull<Node>("RoleManager");
            _chunkManagerCpp = GetNodeOrNull<Node3D>("ChunkManager");

            // WebSocket イベントリスナー登録
            Realtime.OnRoleAssignedReceived += OnRoleAssignedReceived;
            Realtime.OnPlayerTransformReceivedAll += OnPlayerTransformReceivedAll;

            await WaitForInitialChunksLoaded();

            if (SessionManager.Instance != null && SessionManager.Instance.IsHost)
            {
                AssignRolesToAllPlayers();
            }

            int waitTimeoutCounter = 0;
            while (!_hasRoleReceived)
            {
                await Task.Delay(100);
                waitTimeoutCounter++;
                if (waitTimeoutCounter % 30 == 0) // 3秒ごとにログ出力
                {
                    GD.Print("⏳ [MainGame] 役職データの受信を待機中...");
                }
            }

            if (_myPlayerInstance == null)
            {
                SpawnMyPlayer();
            }

            if (_roleRevealScene != null)
            {
                _roleRevealScene.Visible = true;
                if (_factionLabel != null) _factionLabel.Text = GetFactionName(MyFaction);
                if (_roleTitleLabel != null) _roleTitleLabel.Text = GetRoleName(MyRole);
                if (_descriptionLabel != null) _descriptionLabel.Text = GetRoleDescription(MyRole);

                // ロード画面を非表示化
                if (_loadingScene != null) _loadingScene.Visible = false;

                // 3秒間演出を表示
                await Task.Delay(3000);

                if (IsInstanceValid(_roleRevealScene))
                {
                    _roleRevealScene.Visible = false;
                }
            }
            else
            {
                if (_loadingScene != null) _loadingScene.Visible = false;
            }
        }

        /// <summary>
        /// ChunkManager の初期チャンク読み込みが完了するまで待機する
        /// </summary>
        private async Task WaitForInitialChunksLoaded()
        {
            if (_chunkManagerCpp == null)
            {
                GD.PrintErr("⚠️ ChunkManager が見つかりません。チャンク読み込み待機をスキップします。");
                return;
            }

            GD.Print("⏳ [MainGame] 初期チャンクの生成完了を待機中...");

            while (true)
            {
                bool isComplete = false;
                if (_chunkManagerCpp.HasMethod("is_initial_load_complete"))
                {
                    isComplete = (bool)_chunkManagerCpp.Call("is_initial_load_complete");
                }

                if (isComplete) break;

                await Task.Delay(100);
            }

            GD.Print("✅ [MainGame] 初期チャンクの生成が完了しました！");
        }

        public override void _Process(double delta)
        {
            Realtime.PollRealtimeEvents();
            SendMyTransform();
        }

        private void SpawnMyPlayer()
        {
            if (_playerScene == null)
            {
                GD.PrintErr("❌ [MainGameScene] Player.tscn プレハブが読み込めませんでした。");
                return;
            }

            _myPlayerInstance = _playerScene.Instantiate<Node3D>();
            _myPlayerInstance.Name = "MyPlayer";
            _myPlayerInstance.AddToGroup("LocalPlayer");

            AddChild(_myPlayerInstance);
            _myPlayerInstance.GlobalPosition = new Vector3(0, 90, 0);

            if (_chunkManagerCpp != null)
            {
                _chunkManagerCpp.Set("player_path", _myPlayerInstance.GetPath());
            }

            GD.Print("👤 [MainGame] ローカルプレイヤーを生成しました。");
        }

        /// <summary>
        /// 参加者全員に役職を割り当ててブロードキャスト
        /// </summary>
        private void AssignRolesToAllPlayers()
        {
            List<string> players = SessionManager.Instance.CurrentRoomPlayerIds;
            if (players == null || players.Count == 0)
            {
                GD.PrintErr("⚠️ プレイヤーリストが空です。");
                return;
            }

            GD.Print($"🎲 役職配分を開始します。対象人数: {players.Count}");

            if (_roleManagerCpp != null && _roleManagerCpp.HasMethod("assign_roles"))
            {
                _roleManagerCpp.Call("assign_roles", players.Count);

                string myUserId = GetMyUserId();

                for (int i = 0; i < players.Count; i++)
                {
                    string targetUserId = players[i];
                    int roleId = (int)_roleManagerCpp.Call("get_assigned_role", i);
                    int factionId = (int)_roleManagerCpp.Call("get_assigned_faction", i);

                    GD.Print($"📡 [Host] 役職送信 -> Target: {targetUserId}, Role: {roleId}, Faction: {factionId}");

                    // 自分自身への割り当ての場合は通信を通さず直接処理
                    if (targetUserId == myUserId)
                    {
                        OnRoleAssignedReceived(targetUserId, roleId, factionId);
                    }
                    else
                    {
                        Realtime.SendRoleBroadcast(targetUserId, roleId, factionId);
                    }
                }
            }
            else
            {
                GD.PrintErr("❌ RoleManager (C++) が見つからないか、assign_roles メソッドが存在しません。");
            }
        }

        private void OnRoleAssignedReceived(string targetUserId, int roleId, int factionId)
        {
            string myUserId = GetMyUserId();

            // ログを出力してIDチェック
            GD.Print($"📩 役職通知受諾確認: Target={targetUserId}, Mine={myUserId}");

            if (targetUserId != myUserId) return;
            if (_hasRoleReceived) return;

            MyRole = roleId;
            MyFaction = factionId;
            _hasRoleReceived = true;

            GD.Print($"🎉 [Client] 自分の役職を適用しました！ Faction: {MyFaction}, Role: {MyRole}");
        }

        private string GetMyUserId()
        {
            string myUserId = SessionManager.Instance.CurrentSession?.User?.Id;
            if (string.IsNullOrEmpty(myUserId))
            {
                myUserId = $"Guest_{SessionManager.Instance.CurrentRoomCode}";
            }
            return myUserId;
        }

        private string GetFactionName(int factionId)
        {
            return factionId switch
            {
                0 => "村陣営",
                1 => "人狼陣営",
                2 => "第三陣営",
                _ => "不明な陣営"
            };
        }

        private string GetRoleName(int roleId)
        {
            return roleId switch
            {
                0 => "村人",
                1 => "人狼",
                _ => $"役職ID: {roleId}"
            };
        }

        private string GetRoleDescription(int roleId)
        {
            return roleId switch
            {
                0 => "議論によって人狼を追放せよ。",
                1 => "村人に扮し、怪しまれずに全員を排除せよ。",
                _ => "割り当てられた目的を達成してください。"
            };
        }

        private void OnPlayerTransformReceivedAll(string senderId, float px, float py, float pz, float rx, float ry, float rz)
        {
            string myUserId = GetMyUserId();
            if (senderId == myUserId) return;

            if (!_otherPlayers.ContainsKey(senderId))
            {
                if (_opponentScene == null) return;

                Node3D remotePlayer = _opponentScene.Instantiate<Node3D>();
                remotePlayer.Name = $"RemotePlayer_{senderId}";
                AddChild(remotePlayer);
                _otherPlayers[senderId] = remotePlayer;
                GD.Print($"👤 [MainGame] リモートプレイヤープレハブを生成しました: {senderId}");
            }

            Node3D targetPlayer = _otherPlayers[senderId];
            if (targetPlayer != null)
            {
                if (targetPlayer.HasMethod("set_target_transform"))
                {
                    targetPlayer.Call("set_target_transform", px, py, pz, rx, ry, rz);
                }
                else
                {
                    targetPlayer.GlobalPosition = new Vector3(px, py, pz);
                    targetPlayer.Rotation = new Vector3(rx, ry, rz);
                }
            }
        }

        private void SendMyTransform()
        {
            if (_myPlayerInstance == null) return;

            Vector3 pos = _myPlayerInstance.GlobalPosition;
            Vector3 rot = _myPlayerInstance.Rotation;

            Realtime.SendTransformBroadcastAll(pos.X, pos.Y, pos.Z, rot.X, rot.Y, rot.Z);
        }

        public override void _ExitTree()
        {
            Realtime.OnRoleAssignedReceived -= OnRoleAssignedReceived;
            Realtime.OnPlayerTransformReceivedAll -= OnPlayerTransformReceivedAll;
        }
    }
}