using UnityEngine;

public class Shield : MonoBehaviour
{
    int _hp;
    [SerializeField] Material _lastMat;

    SphereCollider _collider;
    MeshRenderer _meshRenderer;


    public void InitObject(int hp)
    {
        _hp = hp;
        _collider = GetComponent<SphereCollider>();
        _meshRenderer = GetComponent<MeshRenderer>();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Bullet")
        {
            Destroy(other.gameObject);
            _hp--;

            if (_hp <= 0)
                MaterialChange();
        }
    }
    void MaterialChange()
    {
        Debug.Log(_meshRenderer.material.GetFloat("_UV"));
        Debug.Log(_meshRenderer.material.GetTextureOffset("_MainTex"));
        _collider.enabled = false;
        _meshRenderer.material = _lastMat;
    }

}
