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
            // 1. UIノードのルート参照を安全に取得
            _loadingScene = GetNodeOrNull<Control>("UILayer/LoadingScene");
            _roleRevealScene = GetNodeOrNull<Control>("UILayer/RoleRevealScene");

            if (_roleRevealScene != null)
            {
                _factionLabel = _roleRevealScene.GetNodeOrNull<Label>("MainContainer/VBoxContainer/FactionLabel");
                _roleTitleLabel = _roleRevealScene.GetNodeOrNull<Label>("MainContainer/VBoxContainer/RoleTitleLabel");
                _descriptionLabel = _roleRevealScene.GetNodeOrNull<Label>("MainContainer/VBoxContainer/DescriptionLabel");
                _roleRevealScene.Visible = false;
            }

            // 2. ChunkManager (C++) の参照取得とパラメータ初期化
            _chunkManagerCpp = GetNodeOrNull<Node3D>("ChunkManager");
            if (_chunkManagerCpp != null)
            {
                _chunkManagerCpp.Set("region_folder_path", "res://regions/");
                _chunkManagerCpp.Set("render_distance", 2);
                _chunkManagerCpp.Set("chunk_size", 16.0f);
            }
            else
            {
                GD.PushWarning("⚠️ [MainGameScene] ChunkManager ノードが見つかりません。");
            }

            // 3. RoleManager (C++) の参照取得
            _roleManagerCpp = GetNodeOrNull<Node>("RoleManager");

            // 4. ネットワークイベントの受信登録
            Realtime.OnRoleAssignedReceived += OnRoleAssignedReceived;
            Realtime.OnPlayerTransformReceivedAll += OnPlayerTransformReceivedAll;

            bool isConnected = await Realtime.EnsureConnectedAsync();
            if (!isConnected)
            {
                GD.PrintErr("❌ [MainGameScene] WebSocket接続に失敗しました。");
            }

            // 5. ローカルプレイヤーの生成
            SpawnMyPlayer();

            // 6. ホスト権限の場合は役職を全員に分配
            if (SessionManager.Instance.IsHost)
            {
                await Task.Delay(1000);
                AssignRolesToAllPlayers();
            }
        }

        public override void _Process(double delta)
        {
            Realtime.PollRealtimeEvents();

            // 毎フレーム自分の位置情報を同期送信
            SendMyTransform();
        }

        /// <summary>
        /// 自分のプレイヤー実体を生成し、ChunkManager 連携とグループ設定を行う
        /// </summary>
        private void SpawnMyPlayer()
        {
            if (_playerScene == null)
            {
                GD.PrintErr("❌ [MainGameScene] Player.tscn プレハブが読み込めませんでした。");
                return;
            }

            _myPlayerInstance = _playerScene.Instantiate<Node3D>();
            _myPlayerInstance.Name = "MyPlayer";
            
            // ChunkManager が追従検索できるようにグループ登録
            _myPlayerInstance.AddToGroup("LocalPlayer");

            AddChild(_myPlayerInstance);
            _myPlayerInstance.GlobalPosition = new Vector3(0, 90, 0);

            // ChunkManager に直接プレイヤーノードのパスを設定
            if (_chunkManagerCpp != null)
            {
                _chunkManagerCpp.Set("player_path", _myPlayerInstance.GetPath());
            }

            GD.Print("👤 [MainGame] ローカルプレイヤーを生成しました。");
        }

        /// <summary>
        /// 参加者全員にランダムに役職を割り当ててブロードキャスト
        /// </summary>
        private void AssignRolesToAllPlayers()
        {
            List<string> players = SessionManager.Instance.CurrentRoomPlayerIds;
            if (players.Count == 0) return;

            GD.Print($"🎲 役職配分を開始します。対象人数: {players.Count}");

            // C++ 側に役職配分を計算させる
            if (_roleManagerCpp != null && _roleManagerCpp.HasMethod("assign_roles"))
            {
                _roleManagerCpp.Call("assign_roles", players.Count);

                for (int i = 0; i < players.Count; i++)
                {
                    string targetUserId = players[i];

                    int roleId = (int)_roleManagerCpp.Call("get_assigned_role", i);
                    int factionId = (int)_roleManagerCpp.Call("get_assigned_faction", i);

                    GD.Print($"📡 [Host] 役職送信 -> Target: {targetUserId}, Role: {roleId}, Faction: {factionId}");

                    Realtime.SendRoleBroadcast(targetUserId, roleId, factionId);
                }
            }
            else
            {
                GD.PrintErr("❌ RoleManager (C++) が見つからないか、assign_roles メソッドが存在しません。");
            }
        }

        /// <summary>
        /// サーバー/ホストから自分宛ての役職通知を受信したときの処理
        /// </summary>
        private async void OnRoleAssignedReceived(string targetUserId, int roleId, int factionId)
        {
            string myUserId = SessionManager.Instance.CurrentSession?.User?.Id;
            if (string.IsNullOrEmpty(myUserId))
            {
                myUserId = $"Guest_{SessionManager.Instance.CurrentRoomCode}";
            }

            if (targetUserId != myUserId) return;

            if (_hasRoleReceived) return;
            _hasRoleReceived = true;

            MyRole = roleId;
            MyFaction = factionId;

            GD.Print($"🎉 [Client] 自分の役職を受信しました！ Faction: {MyFaction}, Role: {MyRole}");

            if (_loadingScene != null) _loadingScene.Visible = false;

            if (_roleRevealScene != null)
            {
                _roleRevealScene.Visible = true;

                if (_factionLabel != null) _factionLabel.Text = GetFactionName(factionId);
                if (_roleTitleLabel != null) _roleTitleLabel.Text = GetRoleName(roleId);
                if (_descriptionLabel != null) _descriptionLabel.Text = GetRoleDescription(roleId);

                await Task.Delay(3000);
                _roleRevealScene.Visible = false;
            }
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

        /// <summary>
        /// 全他プレイヤーの位置情報受信（WebSocketブロードキャスト）
        /// </summary>
        private void OnPlayerTransformReceivedAll(string senderId, float px, float py, float pz, float rx, float ry, float rz)
        {
            string myUserId = SessionManager.Instance.CurrentSession?.User?.Id;
            if (string.IsNullOrEmpty(myUserId))
            {
                myUserId = $"Guest_{SessionManager.Instance.CurrentRoomCode}";
            }

            // 自分の通信データは生成不要
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

            // 生成された相手プレイヤーの座標・回転を更新
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

        /// <summary>
        /// 毎フレーム自分の位置情報を WebSocket 送信
        /// </summary>
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