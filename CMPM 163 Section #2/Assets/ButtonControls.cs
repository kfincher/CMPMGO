using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class ButtonControls : MonoBehaviour
{
    public Button PartA;
    public Button PartB;
    public Button PartC;
    // Start is called before the first frame update
    void Start()
    {
        PartA.onClick.AddListener(PartAStart);
        PartB.onClick.AddListener(PartBStart);
        PartC.onClick.AddListener(PartCStart);
    }
    void PartAStart()
    {
        SceneManager.LoadScene("SampleScene");
    }
    void PartBStart()
    {
        SceneManager.LoadScene("Test");
    }
    void PartCStart()
    {
        SceneManager.LoadScene("GameOfLife");
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
