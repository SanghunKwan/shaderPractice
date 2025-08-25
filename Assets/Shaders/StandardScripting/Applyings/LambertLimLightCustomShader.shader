Shader "Applying/LambertLimLightCustomShader"
{
    Properties
    {
        [Header(Main Map)]
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalTex("Bump Map", 2D) = "bump"{}
        _Glossness("Gloss Value", Range(0,1)) = 0.5
        [Header(Lim Light Param)]
        _LimColor("Limlight Color", Color) = (1,1,1,1)
        _LimPower("LimPower",Range(1,10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        
        #pragma surface surf CustomLambertLimLight
        #pragma target 3.0


        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalTex;
            float3 viewDir;
        };

        sampler2D _MainTex;
        sampler2D _NormalTex;
        float _Glossness;
        fixed4 _LimColor;
        float _LimPower;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 base = tex2D (_MainTex, IN.uv_MainTex);
            fixed3 nor = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
            o.Normal = nor;
            o.Albedo = base.rgb;
            o.Gloss = _Glossness;

            float lim = saturate(dot(nor, IN.viewDir));
            o.Alpha = lim;
            o.Emission = pow(1 - lim, _LimPower) * _LimColor.rgb;

        }

        float4 LightingCustomLambertLimLight(SurfaceOutput s, float3 lightDir, float atten)
        {
            float4 final;
            float NdotL = saturate(dot(s.Normal, lightDir));
            
            final.rgb = s.Albedo * NdotL * _LightColor0.rgb * atten;
            final.a = s.Alpha;
            return final;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
