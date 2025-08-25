Shader "Applying/OutLineFresnelShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalTex("Bump Map",2D) = "bump"{}
        _OutLineColor ("OutLine Color", Color) = (0,0,0,1)
        [IntRange]_OutLineThickness("OutLine Weght", Range(1,20)) = 5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        
        #pragma surface surf OutLine noambient
        #pragma target 3.0


        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalTex;
        };

        sampler2D _MainTex;
        sampler2D _NormalTex;

        fixed4 _OutLineColor;
        float _OutLineThickness;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed3 n = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
            o.Normal = n;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        float4 LightingOutLine(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float4 final;
            float NdotL = dot(s.Normal, lightDir) * 0.5 + 0.5;
            fixed3 color;
            float lim = saturate(dot(s.Normal, viewDir));
            //lim = pow(1 - lim, _OutLineThickness) * _OutLineColor.rgb;
            if(lim > _OutLineThickness * 0.01)
            {
                //lim = 1;
                color = fixed3(1,1,1);
            }    
            else
            {
                //lim = -1;
                color = _OutLineColor.rgb;
            }
            final.rgb = s.Albedo * NdotL * _LightColor0.rgb * color;
            final.a = s.Alpha;

            return final;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
