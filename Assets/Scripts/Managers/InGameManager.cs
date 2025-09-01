using UnityEngine;

public class InGameManager : MonoBehaviour
{
    public static InGameManager _Instance { get; private set; }

    [SerializeField] GameObject _prefabBullet;
    [SerializeField] Target _target;
    [SerializeField] Shield _shield;



    private void Awake()
    {
        _Instance = this;
        _target.InitObject();
        _shield.InitObject(1);
    }

    public void Update()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        if (Input.GetMouseButtonDown(1))
        {
            GameObject bulletObj = Instantiate(_prefabBullet, ray.origin, Quaternion.identity);
            bulletObj.transform.rotation = Quaternion.FromToRotation(Vector3.up, ray.direction);
            Bullet bullet = bulletObj.GetComponent<Bullet>();
            Debug.Log(ray.direction);
            bullet.InitObject(ray.direction, 10);
        }

        if (Input.mousePositionDelta != Vector3.zero)
        {
            if(Physics.Raycast(ray, out RaycastHit hit, 100, ~ (1 <<LayerMask.NameToLayer("Shield"))) && hit.collider.gameObject == _target.gameObject)
            {
                _target.OnMouse();
            }
            else
                _target.OffMouse();
        }
    }




}
