Shader "Applying/BlinnPhongLimLightCustomShader"
{
    Properties
    {
        [Header(Main Map)]
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalTex("Bump Map", 2D) = "bump"{}
        _Glossness("Glossness", Range(0,1)) = 0.5
        _HighlightColor("Highlight Color", Color) = (1,1,1,1)
        _SpecularPower("Specular Power", Range(10,100)) = 60
        [Header(Lim Light Param)]
        _LimColor("Limlight Color", Color) = (1,1,1,1)
        _LimPower("LimPower",Range(1,10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        
        #pragma surface surf BlinnPhongLimLightCustom
        #pragma target 3.0


        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalTex;
            float2 viewDir;
        };

        sampler2D _MainTex;
        sampler2D _NormalTex;
        float _Glossness;
        fixed4 _HighlightColor;
        float _SpecularPower;
        fixed4 _LimColor;
        float _LimPower;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 base = tex2D (_MainTex, IN.uv_MainTex);
            fixed3 nor = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
            o.Albedo = base.rgb;
            o.Normal = nor;
            o.Gloss = _Glossness;
            o.Specular = _SpecularPower;
            o.Alpha = base.a;
        }

        float4 LightingBlinnPhongLimLightCustom(SurfaceOutput s, float3 lightDir, float3 viewDir,float atten)
        {
            float4 final;
            float4 diffuseColor;
            float4 limColor;

            //Lambert 계산
            float ndotl = saturate(dot(s.Normal, lightDir));
            diffuseColor.rgb = ndotl * s.Albedo * _LightColor0.rgb * atten;

            //Specular 계산
            float3 halfVec = normalize(viewDir + lightDir);
            float spec = saturate(dot(s.Normal,halfVec));
            float3 speFinal = (pow(spec, s.Specular) * s.Gloss) * _LightColor0.rgb * _HighlightColor.rgb;

            //LimLight 계산
            float lim = saturate( dot(s.Normal, viewDir));
            limColor = pow(1 - lim, _LimPower) * _LimColor;

            final.rgb = saturate(diffuseColor  + (speFinal + limColor)/2);
            final.a = s.Alpha;

            return final;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
