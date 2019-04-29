using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveRotateGo : MonoBehaviour
{
    float speed = 0.01f;
    float rotation = 0.01f;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (transform.position.x >= 5) {
            speed *= -1;
        }
        if (transform.position.x <= -5) {
            speed *= -1;
        }
        Vector3 temp = transform.position;
        temp.x += speed;
        transform.position = temp;

        transform.Rotate(0, 1, 0);

    }
}
