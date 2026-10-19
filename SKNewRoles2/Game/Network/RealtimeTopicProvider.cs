using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Game.Network
{
    public static class RealtimeTopicProvider
    {
        public static string GetCurrentTopic()
        {
            string roomCode = SessionManager.Instance?.CurrentRoomCode;
            if (string.IsNullOrEmpty(roomCode))
            {
                return "realtime:public:lobbies";
            }
            return $"realtime:public:lobbies:{roomCode}";
        }
    }
}