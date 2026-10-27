namespace SKNewRoles2.Game.Network
{
    public struct RealtimePayload
    {
        public string topic { get; set; }
        public string @event { get; set; }
        public object payload { get; set; }
        public string @ref { get; set; }
    }
}