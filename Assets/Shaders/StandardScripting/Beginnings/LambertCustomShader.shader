Shader "Beginning/LambertCustomShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalTex ("Bump Map", 2D) = "bump"{}
        _Glossiness ("Gloss Value", Range(0,1)) = 0.5

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf CustomLambert 
        #pragma target 3.0


        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalTex;
        };

        sampler2D _MainTex;
        sampler2D _NormalTex;
        half _Glossiness;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed3 nor = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
            o.Albedo = c.rgb;
            o.Gloss = _Glossiness;
            o.Alpha = c.a;
            o.Normal = nor;
        }

        float4 LightingCustomLambert(SurfaceOutput s, float3 lightDir, float atten)
        {
            float4 final;
            float ndotl = saturate(dot(s.Normal, lightDir));
            final.rgb =  s.Albedo * ndotl * _LightColor0.rgb * atten;
            final.a = s.Alpha;

            return final;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
