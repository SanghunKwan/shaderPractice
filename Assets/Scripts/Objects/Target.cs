using UnityEngine;

public class Target : MonoBehaviour
{
    MeshRenderer _meshRenderer;

    [SerializeField] Material[] materials;

    public void InitObject()
    {
        _meshRenderer = GetComponent<MeshRenderer>();
    }

    public void OnMouse()
    {
        _meshRenderer.material = materials[0];
    }
    
    public void OffMouse()
    {
        _meshRenderer.material = materials[1];

    }
}
