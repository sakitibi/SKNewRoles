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

        private Node3D _myPlayerInstance;
        private Dictionary<string, Node3D> _otherPlayers = new Dictionary<string, Node3D>();

        private Control _loadingScene;
        private Control _roleRevealScene;
        private ProgressBar _hpBar;
        private Label _hpLabel;
        private Label _factionLabel;
        private Label _roleTitleLabel;
        private Label _descriptionLabel;

        private bool _hasRoleReceived = false;

        public override async void _Ready()
        {
            GD.Print("1️⃣ [_Ready] 開始");

            _loadingScene = GetNodeOrNull<Control>("UILayer/LoadingScene");
            _roleRevealScene = GetNodeOrNull<Control>("UILayer/RoleRevealScene");
            _hpBar = GetNodeOrNull<ProgressBar>("UILayer/HPBar");
            _hpLabel = GetNodeOrNull<Label>("UILayer/HPBar/HPLabel");

            if (_roleRevealScene != null)
            {
                _factionLabel = _roleRevealScene.GetNodeOrNull<Label>("MainContainer/VBoxContainer/FactionLabel");
                _roleTitleLabel = _roleRevealScene.GetNodeOrNull<Label>("MainContainer/VBoxContainer/RoleTitleLabel");
                _descriptionLabel = _roleRevealScene.GetNodeOrNull<Label>("MainContainer/VBoxContainer/DescriptionLabel");
                _roleRevealScene.Visible = false;
            }

            if (_loadingScene != null)
            {
                _loadingScene.Visible = true;
            }

            _roleManagerCpp = GetNodeOrNull<Node>("RoleManager");
            _chunkManagerCpp = GetNodeOrNull<Node3D>("ChunkManager");

            Realtime.OnRoleAssignedReceived += OnRoleAssignedReceived;
            Realtime.OnPlayerTransformReceivedAll += OnPlayerTransformReceivedAll;
            Realtime.OnPlayerHpReceived += OnOtherPlayerHpReceived;

            // プレイヤーを生成
            if (_myPlayerInstance == null)
            {
                SpawnMyPlayer();
                SetPlayerPhysicsEnabled(false);
            }

            GD.Print("2️⃣ [_Ready] チャンク読み込み待機開始");
            await WaitForInitialChunksLoaded();

            if (SessionManager.Instance != null && SessionManager.Instance.IsHost)
            {
                GD.Print("3️⃣ [_Ready] ホストとして役職割り当てを実行");
                AssignRolesToAllPlayers();
            }

            GD.Print("4️⃣ [_Ready] 役職受諾のループ待機開始");
            int loopCheck = 0;
            while (!_hasRoleReceived && loopCheck < 50)
            {
                await Task.Delay(100);
                loopCheck++;
            }

            if (!_hasRoleReceived)
            {
                GD.PrintErr("⚠️ 役職受信タイムアウトのため、デフォルト(村人)を適用します");
                ApplyRole(0, 0);
            }

            GD.Print("5️⃣ [_Ready] 役職データ確認完了");
            GD.Print("6️⃣ [_Ready] ロード画面を非表示にして役職画面を表示します");

            if (_loadingScene != null)
            {
                _loadingScene.Visible = false;
            }

            if (_roleRevealScene != null)
            {
                if (_factionLabel != null) _factionLabel.Text = GetFactionName(MyFaction);
                if (_roleTitleLabel != null) _roleTitleLabel.Text = GetRoleName(MyRole);
                if (_descriptionLabel != null) _descriptionLabel.Text = GetRoleDescription(MyRole);

                _roleRevealScene.Visible = true;
                _roleRevealScene.MoveToFront();

                GD.Print("7️⃣ [_Ready] 役職画面を表示しました (5秒カウント開始)");
                await Task.Delay(5000);

                if (IsInstanceValid(_roleRevealScene))
                {
                    _roleRevealScene.Visible = false;
                    GD.Print("8️⃣ [_Ready] 役職画面を非表示にしました (ゲームスタート)");
                }
            }

            SetPlayerPhysicsEnabled(true);
        }

        private async Task WaitForInitialChunksLoaded()
        {
            if (_chunkManagerCpp == null) return;

            int timeoutCounter = 0;
            while (timeoutCounter < 150)
            {
                bool isComplete = false;
                if (_chunkManagerCpp.HasMethod("is_initial_load_complete"))
                {
                    isComplete = (bool)_chunkManagerCpp.Call("is_initial_load_complete");
                }

                if (isComplete)
                {
                    GD.Print("✅ 初期チャンク読み込み完了");
                    return;
                }

                await Task.Delay(100);
                timeoutCounter++;
            }

            GD.PrintErr("⚠️ チャンク読み込み待機がタイムアウト(15秒)しました。強制続行します。");
        }

        public override void _Process(double delta)
        {
            Realtime.PollRealtimeEvents();
            SendMyTransform();
        }

        private void SpawnMyPlayer()
        {
            if (_playerScene == null) return;

            _myPlayerInstance = _playerScene.Instantiate<Node3D>();
            _myPlayerInstance.Name = "MyPlayer";
            _myPlayerInstance.AddToGroup("LocalPlayer");

            AddChild(_myPlayerInstance);
            
            _myPlayerInstance.GlobalPosition = new Vector3(0, 100, 0);

            _myPlayerInstance.Connect("hp_changed", Callable.From<int, int>(OnMyPlayerHpChanged));

            // 初期表示用に取得
            if (_myPlayerInstance.HasMethod("get_current_hp") && _myPlayerInstance.HasMethod("get_max_hp"))
            {
                int curHp = (int)_myPlayerInstance.Call("get_current_hp");
                int maxHp = (int)_myPlayerInstance.Call("get_max_hp");
                OnMyPlayerHpChanged(curHp, maxHp);
            }

            if (_chunkManagerCpp != null)
            {
                _chunkManagerCpp.Set("player_path", _myPlayerInstance.GetPath());
            }
        }

        private void SetPlayerPhysicsEnabled(bool enabled)
        {
            if (_myPlayerInstance == null) return;

            _myPlayerInstance.SetPhysicsProcess(enabled);
            _myPlayerInstance.SetProcess(enabled);

            if (_myPlayerInstance is CharacterBody3D body)
            {
                body.Velocity = Vector3.Zero;
            }
        }

        private void AssignRolesToAllPlayers()
        {
            if (_roleManagerCpp == null || !_roleManagerCpp.HasMethod("assign_roles"))
            {
                GD.PrintErr("❌ [AssignRoles] RoleManager が正しく設定されていません");
                return;
            }

            var playerIdsArray = new Godot.Collections.Array();
            string myUserId = GetMyUserId();

            if (SessionManager.Instance?.CurrentRoomPlayerIds != null && SessionManager.Instance.CurrentRoomPlayerIds.Count > 0)
            {
                foreach (var id in SessionManager.Instance.CurrentRoomPlayerIds)
                {
                    playerIdsArray.Add(id);
                }
            }
            else
            {
                playerIdsArray.Add(myUserId);
            }

            var roleCountsDict = new Godot.Collections.Dictionary();
            roleCountsDict[1] = 1; // 役職ID 1 (人狼) を 1人

            GD.Print($"🎲 [AssignRoles] {playerIdsArray.Count} 人のプレイヤーに役職を割り当てます");

            var rawResult = _roleManagerCpp.Call("assign_roles", playerIdsArray, roleCountsDict);
            var assignmentResult = rawResult.AsGodotDictionary();

            foreach (Variant key in assignmentResult.Keys)
            {
                string targetUserId = key.AsString();
                var roleData = assignmentResult[key].AsGodotDictionary();

                int assignedRole = roleData["role"].AsInt32();
                int assignedFaction = roleData["faction"].AsInt32();

                GD.Print($"🎭 割り当て完了: Player={targetUserId}, Role={assignedRole}, Faction={assignedFaction}");

                if (targetUserId == myUserId)
                {
                    ApplyRole(assignedRole, assignedFaction);
                }
                else
                {
                    Realtime.SendRoleBroadcast(targetUserId, assignedRole, assignedFaction);
                }
            }
        }

        private void OnRoleAssignedReceived(string targetUserId, int roleId, int factionId)
        {
            string myUserId = GetMyUserId();
            if (targetUserId != myUserId && !string.IsNullOrEmpty(targetUserId)) return;

            if (_hasRoleReceived) return;

            ApplyRole(roleId, factionId);
            GD.Print($"📩 [OnRoleAssignedReceived] 役職データを受信しました: Faction={MyFaction}, Role={MyRole}");
        }

        public void ApplyRole(int roleId, int factionId)
        {
            MyRole = roleId;
            MyFaction = factionId;
            _hasRoleReceived = true;
            GD.Print($"✨ 自分の役職が適用されました: Role={MyRole}, Faction={MyFaction}");
        }

        private string GetMyUserId()
        {
            string myUserId = SessionManager.Instance?.CurrentSession?.User?.Id;
            if (string.IsNullOrEmpty(myUserId))
            {
                myUserId = $"Guest_{SessionManager.Instance?.CurrentRoomCode ?? "SingleTest"}";
            }
            return myUserId;
        }

        private string GetFactionName(int factionId)
        {
            return factionId switch
            {
                0 => "村人陣営",
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

        private void OnMyPlayerHpChanged(int currentHp, int maxHp)
        {
            if (_hpBar != null)
            {
                _hpBar.MaxValue = maxHp;
                _hpBar.Value = currentHp;
            }
            if (_hpLabel != null)
            {
                _hpLabel.Text = $"{currentHp} / {maxHp}";
            }

            string myUserId = GetMyUserId();
            Realtime.SendHpBroadcast(myUserId, currentHp, maxHp);
        }

        private void OnOtherPlayerHpReceived(string senderId, int currentHp, int maxHp)
        {
            string myUserId = GetMyUserId();
            if (senderId == myUserId) return;

            if (_otherPlayers.ContainsKey(senderId))
            {
                Node3D remotePlayer = _otherPlayers[senderId];
                if (IsInstanceValid(remotePlayer) && remotePlayer.HasMethod("set_current_hp"))
                {
                    remotePlayer.Call("set_current_hp", currentHp);
                }
            }
        }

        public override void _ExitTree()
        {
            Realtime.OnRoleAssignedReceived -= OnRoleAssignedReceived;
            Realtime.OnPlayerTransformReceivedAll -= OnPlayerTransformReceivedAll;
            Realtime.OnPlayerHpReceived -= OnOtherPlayerHpReceived;
        }
    }
}