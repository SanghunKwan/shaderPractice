using UnityEngine;

public class Bullet : MonoBehaviour
{
    Vector3 _velocity;
    float _speed;
    public void InitObject( Vector3 velocity, float speed)
    {
        _velocity = velocity;
        Vector3 direction = velocity.normalized;
        _speed = speed;
    }
    private void Update()
    {
        transform.position += _velocity * Time.deltaTime * _speed;
    }
}
