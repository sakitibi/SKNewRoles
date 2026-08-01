using Godot;

namespace SKNewRoles2.Lobby
{
    /// <summary>
    /// メッシュやマテリアルの Triplanar 設定を行うユーティリティクラス
    /// </summary>
    public static class LobbyMeshUtility
    {
        /// <summary>
        /// 指定したノード配下の全 MeshInstance3D に対して Triplanar を適用します
        /// </summary>
        public static void ApplyTriplanarToAllMeshes(Node parent)
        {
            if (parent == null) return;

            foreach (Node child in parent.GetChildren())
            {
                if (child is MeshInstance3D meshInstance)
                {
                    EnableTriplanarForMesh(meshInstance);
                }

                if (child.GetChildCount() > 0)
                {
                    ApplyTriplanarToAllMeshes(child);
                }
            }
        }

        /// <summary>
        /// 単一の MeshInstance3D のマテリアルに Triplanar を適用します
        /// </summary>
        public static void EnableTriplanarForMesh(MeshInstance3D meshInstance)
        {
            if (meshInstance == null) return;

            if (meshInstance.MaterialOverride is BaseMaterial3D overrideMat)
            {
                BaseMaterial3D newMat = (BaseMaterial3D)overrideMat.Duplicate();
                newMat.Uv1Triplanar = true;
                newMat.Uv1WorldTriplanar = true;
                meshInstance.MaterialOverride = newMat;
            }

            if (meshInstance.Mesh != null)
            {
                int surfaceCount = meshInstance.Mesh.GetSurfaceCount();
                for (int i = 0; i < surfaceCount; i++)
                {
                    Material activeMat = meshInstance.GetActiveMaterial(i);
                    if (activeMat is BaseMaterial3D baseMat)
                    {
                        BaseMaterial3D newMat = (BaseMaterial3D)baseMat.Duplicate();
                        newMat.Uv1Triplanar = true;
                        newMat.Uv1WorldTriplanar = true;
                        meshInstance.SetSurfaceOverrideMaterial(i, newMat);
                    }
                }
            }
        }
    }
}