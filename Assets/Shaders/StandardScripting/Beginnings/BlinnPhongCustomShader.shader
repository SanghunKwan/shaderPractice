Shader "Beginning/BlinnPhongCustomShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
         _NormalTex ("Bump Map", 2D) = "bump"{}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _HighlightColor("Specular Color", Color) = (1,1,1,1)
        _SpecPower("Specular Power", Range(10, 100)) = 60
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf BlinnPhongCustom
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _NormalTex;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalTex;
        };

        half _Glossiness;
        float4 _HighlightColor;
        float _SpecPower;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed3 nor = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
            o.Albedo = c.rgb;
            o.Normal = nor;
            o.Gloss = _Glossiness;
            o.Specular = _SpecPower;
            o.Alpha = c.a;
        }

        float4 LightingBlinnPhongCustom(SurfaceOutput s, float lightDir, float3 viewDir, float atten){
            float4 final;
            float4 diffuseColor;

            //Lambert 계산
            float ndotl = saturate(dot(s.Normal, lightDir));
            diffuseColor.rgb = ndotl * s.Albedo * _LightColor0.rgb * atten;

            //Specular 계산
            float3 halfVec = normalize(viewDir + lightDir);
            float spec = saturate(dot(s.Normal, halfVec));
            spec = pow(spec, s.Specular) * s.Gloss;
            float3 specFinal =  spec * _LightColor0.rgb * _HighlightColor.rgb;

            //최종 계산
            final.rgb = saturate(diffuseColor.rgb + specFinal);
            final.a =  s.Alpha;
            return final;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
