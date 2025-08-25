Shader "Applying/ToonTest"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalTex("Bump Map",2D) = "bump"{}
        [IntRange]_LevelNumber("Level Count", Range(1,10)) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        
        #pragma surface surf Toon noambient
        #pragma target 3.0


        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalTex;
        };

        sampler2D _MainTex;
        sampler2D _NormalTex;

        float _LevelNumber;

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

        float4 LightingToon(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float4 final;
            float NdotL = saturate(dot(s.Normal, lightDir) * 0.5 + 0.5);
            
            NdotL = ceil(NdotL  * _LevelNumber) /_LevelNumber ;
            
            final.rgb = NdotL * s.Albedo * _LightColor0.rgb * atten;


            final.a = s.Alpha;

            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
