Shader "Custom/RenderToTexture_CA"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {} 
    }
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		
		Pass
		{

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
            
            uniform float4 _MainTex_TexelSize;
           
            
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv: TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv: TEXCOORD0;
			};
   
			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
            
			float4 blueColor = float4(0.0, 0.0, 1.0, 0.0);


            sampler2D _MainTex;
            
			fixed4 frag(v2f i) : SV_Target
			{
            
                float2 texel = float2(
                    _MainTex_TexelSize.x, 
                    _MainTex_TexelSize.y 
                );
                
                float cx = i.uv.x;
                float cy = i.uv.y;
                
                float4 C = tex2D( _MainTex, float2( cx, cy ));   
                
                float up = i.uv.y + texel.y * 1;
                float down = i.uv.y + texel.y * -1;
                float right = i.uv.x + texel.x * 1;
                float left = i.uv.x + texel.x * -1;
                
                float4 arr[8];
                
                arr[0] = tex2D(  _MainTex, float2( cx   , up ));   //N
                arr[1] = tex2D(  _MainTex, float2( right, up ));   //NE
                arr[2] = tex2D(  _MainTex, float2( right, cy ));   //E
                arr[3] = tex2D(  _MainTex, float2( right, down )); //SE
                arr[4] = tex2D(  _MainTex, float2( cx   , down )); //S
                arr[5] = tex2D(  _MainTex, float2( left , down )); //SW
                arr[6] = tex2D(  _MainTex, float2( left , cy ));   //W
				arr[7] = tex2D(  _MainTex, float2( left , up ));   //NW
				//undo til here
				int cnt[7] = { 0,0,0,0,0,0,0 };
				
				for (int i = 0; i < 8; i++) {
					if (arr[i].b > 0.5&&arr[i].r<0.5&&arr[i].g < 0.5) {
						cnt[0]++;
					}
					if (arr[i].r > 0.5&&arr[i].b < 0.5&&arr[i].g < 0.5) {
						cnt[1]++;
					}
					if (arr[i].g > 0.5&&arr[i].r < 0.5&&arr[i].b < 0.5) {
						cnt[2]++;
					}
					if (arr[i].b>0.5&&arr[i].r> 0.5&&arr[i].g < 0.5) {
						cnt[3]++;
					}
					if (arr[i].r>0.5 && arr[i].g> 0.5&&arr[i].b < 0.5) {
						cnt[4]++;
					}
					if (arr[i].g>0.5 && arr[i].b> 0.5&&arr[i].r < 0.5) {
						cnt[5]++;
					}
					if (arr[i].g>0.5 && arr[i].b> 0.5&& arr[i].r>0.5){
						cnt[6]++;
					}
				}

				// undo til here
				// YELLOW HERE
				if (C.b >= 0.5&&C.r >= 0.5&&cnt[3] > cnt[4] && cnt[3] > cnt[5]) {
					if (cnt[3] == 2 || cnt[3] == 3) {
						//Any live cell with two or three live neighbours lives on to the next generation.
						//return blueColor;
						return float4(1.0, 0.0, 1.0, 0.0);
					}
					else {
						//Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
						//Any live cell with more than three live neighbours dies, as if by overpopulation.

						return float4(0.0, 0.0, 0.0, 1.0);
					}
				}else if (cnt[3] == 3) {
					return float4(1.0, 0.0, 1.0, 0.0);
					// MAGENTA HERE
				}else if (C.g >= 0.5&&C.r >= 0.5&&cnt[4] > cnt[3] && cnt[4] > cnt[5]) {
					if (cnt[4] == 2 || cnt[4] == 3) {
						//Any live cell with two or three live neighbours lives on to the next generation.
						//return blueColor;
						return float4(1.0, 1.0, 0.0, 0.0);
					}
					else {
						//Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
						//Any live cell with more than three live neighbours dies, as if by overpopulation.

						return float4(0.0, 0.0, 0.0, 1.0);
					}
				}else if (cnt[4] == 3) {
					return float4(1.0, 1.0, 0.0, 0.0);
					// YELLOW HERE
				}else if (C.b >= 0.5&&C.g >= 0.5&&cnt[5] >= cnt[4] && cnt[5] >= cnt[3]) {
					if (cnt[5] == 2 || cnt[5] == 3) {
						//Any live cell with two or three live neighbours lives on to the next generation.
						//return blueColor;
						return float4(0.0, 1.0, 1.0, 0.0);
					}
					else {
						//Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
						//Any live cell with more than three live neighbours dies, as if by overpopulation.

						return float4(0.0, 0.0, 0.0, 1.0);
					}
				}else if (cnt[5] == 3) {
					return float4(0.0, 1.0, 1.0, 0.0);
					// BLUE HERE
				}else if (C.b >= 0.5&& cnt[0] > cnt[1] && cnt[0] > cnt[2]&&C.r<0.5&&C.g<0.5) { //cell is alive
					if (cnt[0] == 2 || cnt[0] == 3) {
						//Any live cell with two or three live neighbours lives on to the next generation.
						//return blueColor;
						return float4(0.0, 0.0, 1.0, 0.0);
					}
					else {
						//Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
						//Any live cell with more than three live neighbours dies, as if by overpopulation.

						return float4(0.0, 0.0, 0.0, 1.0);
					}
				}else if(cnt[0] == 3) { //cell is dead
						//Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
					//return blueColor;
					return float4(0.0, 0.0, 1.0, 0.0);
					// RED HERE
				}else if (C.r >= 0.5&& cnt[1] > cnt[0] && cnt[1] > cnt[2] && C.b < 0.5&&C.g<0.5) { //cell is alive
					if (cnt[1] == 2 || cnt[1] == 3) {
						//Any live cell with two or three live neighbours lives on to the next generation.
						return float4(1.0, 0.0, 0.0, 0.0);
					}
					else {
						//Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
						//Any live cell with more than three live neighbours dies, as if by overpopulation.
						return float4(1.0, 1.0, 0.0, 1.0);
					}
				}else if (cnt[1] == 3) {
					//Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
					return float4(1.0, 0.0, 0.0, 0.0);
					// GREEN HERE
				}else if (C.g >= 0.5&& cnt[2] >= cnt[1] && cnt[2] >= cnt[0] && C.r < 0.5&&C.r<0.5) { //cell is alive
					if (cnt[2] == 2 || cnt[2] == 3) {
						//Any live cell with two or three live neighbours lives on to the next generation.

						return float4(0.0, 1.0, 0.0, 0.0);
					}
					else {
						//Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
						//Any live cell with more than three live neighbours dies, as if by overpopulation.

						return float4(0.0, 0.0, 0.0, 1.0);
					}
				}
				else if(cnt[2] == 3) {
					//Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

					return float4(0.0, 1.0, 0.0, 0.0);
				}
				else {
					return float4(0.0, 0.0, 0.0, 1.0);

				}

				

				////green code
                //if (C.g >= 0.5) { //cell is alive
                //    if (cntThree == 2 || cntThree == 3) {
                //        //Any live cell with two or three live neighbours lives on to the next generation.
                //
				//		return float4(1.0, 1.0, 1.0, 1.0);
                //    } else {
                //        //Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
                //        //Any live cell with more than three live neighbours dies, as if by overpopulation.
				//
                //        return float4(0.0,0.0,0.0,1.0);
                //    }
                //} else { //cell is dead
                //    if (cntThree == 3) {
                //        //Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
				//
				//		return float4(1.0, 1.0, 1.0, 1.0);
                //    } else {
                //        return float4(0.0,0.0,0.0,1.0);
				//
                //    }
                //}
                
            }

			ENDCG
		}

	}
	FallBack "Blur"
}