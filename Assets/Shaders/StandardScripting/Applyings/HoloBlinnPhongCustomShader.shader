Shader "Applying/HoloBlinnPhongCustomShader"
{
    Properties
    {
        [Header(Main Map)]
       _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalTex("Bump Map", 2D) = "bump"{}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _HighlightColor("Specular Color", Color) = (1,1,1,1)
        _SpecPower("Specular Power", Range(10, 100)) = 60

        [Header(Lim Light Param)]
        _LimColor("Limlight Color", Color) = (1,1,1,1)
        _LimPower("LimPower",Range(1,10)) = 1
        _MixingRatio("Mixing Ratio", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        LOD 200

        CGPROGRAM
        #pragma surface surf BlinnPhongCustom noambient alpha:fade
        #pragma target 3.0


        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalTex;
            float2 viewDir;
        };

        sampler2D _MainTex;
        sampler2D _NormalTex;
        float _Glossiness;
        fixed4 _HighlightColor;
        float _SpecPower;

        fixed4 _LimColor;
        float _LimPower;
        float _MixingRatio;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 base = tex2D (_MainTex, IN.uv_MainTex);
            fixed3 nor = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
            o.Normal = nor;
            o.Albedo = base.rgb;
             //LimLight °è»ê
            float lim =  saturate(dot(IN.viewDir,nor));
            lim = pow(1 -lim, _LimPower);
            o.Gloss = _Glossiness;
            o.Specular = _SpecPower;
            o.Alpha = lim;
        }

        float4 LightingBlinnPhongCustom(SurfaceOutput s, float3 lightDir,float3 viewDir,  float atten)
        {
            float4 final;
            float NdotL = saturate(dot(s.Normal, lightDir));

            float3 halfVec = normalize(viewDir + lightDir);
            float spec = saturate(dot(s.Normal, halfVec));
            spec = pow(spec, s.Specular) * s.Gloss;
            float3 specFinal =  spec * _LightColor0.rgb * _HighlightColor.rgb;
            
            final.rgb =  lerp( s.Albedo, _LimColor.rgb, _MixingRatio)
                        + (s.Albedo * NdotL * _LightColor0.rgb * atten
                        + specFinal)/2;
            final.a = s.Alpha;
            return final;
        }



        ENDCG
    }
    FallBack "Diffuse"
}
