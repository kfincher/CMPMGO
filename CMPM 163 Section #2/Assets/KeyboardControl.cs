using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class KeyboardControl : MonoBehaviour
{
    float _LookUpDistance = 1f;
    public GameObject work;
    //Shader.SetGlobalFloat("_LookUpDistance", _LookUpDistance);
    // Start is called before the first frame update
    void Start()
    {
        work.GetComponent<Renderer>().material.SetFloat("_LookUpDistance",_LookUpDistance);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.RightArrow)) {
            _LookUpDistance += 0.2f;
            work.GetComponent<Renderer>().material.SetFloat("_LookUpDistance", _LookUpDistance);
        }
        if (Input.GetKey(KeyCode.LeftArrow)) {
            _LookUpDistance -= 0.2f;
            work.GetComponent<Renderer>().material.SetFloat("_LookUpDistance", _LookUpDistance);
        }
    }
}
