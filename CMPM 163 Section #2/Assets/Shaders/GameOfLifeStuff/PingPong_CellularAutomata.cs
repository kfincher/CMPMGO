using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PingPong_CellularAutomata : MonoBehaviour
{
    Texture2D texA;
    Texture2D texB;
    Texture2D inputTex;
    Texture2D outputTex;
    RenderTexture rt1;

    Shader cellularAutomataShader;
    Shader ouputTextureShader;

    int width;
    int height;

    Renderer rend;
    int count = 0;

    void Start()
    {
        //print(SystemInfo.copyTextureSupport);

        width = 64;
        height = 64;

        texA = new Texture2D(width, height, TextureFormat.RGBA32, false);
        texB = new Texture2D(width, height, TextureFormat.RGBA32, false);

        texA.filterMode = FilterMode.Point;
        texB.filterMode = FilterMode.Point;
        float boo;
        float states = 5;
        for (int i = 0; i < height; i++) {
            for (int j = 0; j < width; j++) {
                boo = Random.Range(0.0f, 1.0f);
                float inc = 1;
                if (boo >= 0 && boo <= inc/states) {
                    texA.SetPixel(i, j, Color.black);
                    Debug.Log("black");
                } else if (boo > inc/states && boo <= ++inc/states) {
                    texA.SetPixel(i, j, Color.red);
                    Debug.Log("red");
                } else if (boo > inc/states && boo <= ++inc/states) {
                    texA.SetPixel(i, j, Color.blue);
                    Debug.Log("blue");
                } else if (boo > inc/states && boo <= ++inc/states) {
                    texA.SetPixel(i, j, Color.magenta);
                    Debug.Log("magenta");
                }else if (boo > inc/states && boo <= ++inc/states) {
                    texA.SetPixel(i, j, Color.yellow);
                    Debug.Log("yellow");
                }else if (boo > inc/states && boo <= ++inc/states) {
                    texA.SetPixel(i, j, Color.cyan);
                    Debug.Log("cyan");
                }else if (boo > inc/states && boo <= ++inc/states) {
                    texA.SetPixel(i, j, Color.white);
                    Debug.Log("white");
                } else {
                    texA.SetPixel(i, j, Color.green);
                    Debug.Log("green");
                }
            }
        }
        // two colors
        //for (int i = 0; i < height; i++) {
        //    for (int j = 0; j < width; j++) {
        //        if (Random.Range(0.0f, 1.0f)<0.5) {
        //            texA.SetPixel(i, j, Color.red);
        //        } else {
        //            texA.SetPixel(i, j, Color.blue);
        //        }
        //    }
        //}

        texA.Apply(); //copy changes to the GPU


        rt1 = new RenderTexture(width, height, 0, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear);
   

        rend = GetComponent<Renderer>();

        cellularAutomataShader = Shader.Find("Custom/RenderToTexture_CA");
        ouputTextureShader = Shader.Find("Custom/OutputTexture");

    }

   
    void Update()
    {
        //set active shader to be a shader that computes the next timestep
        //of the Cellular Automata system
        rend.material.shader = cellularAutomataShader;
        
        if (count % 2 == 0)
        {
            inputTex = texA;
            outputTex = texB;
        }
        else
        {
            inputTex = texB;
            outputTex = texA;
        }
        
        
        rend.material.SetTexture("_MainTex", inputTex);
        
        //source, destination, material
        Graphics.Blit(inputTex, rt1, rend.material);
        Graphics.CopyTexture(rt1, outputTex);
        
        
        //set the active shader to be a regular shader that maps the current
        //output texture onto a game object
        rend.material.shader = ouputTextureShader;
        rend.material.SetTexture("_MainTex", outputTex);
        
        
        count++;
    }
}
