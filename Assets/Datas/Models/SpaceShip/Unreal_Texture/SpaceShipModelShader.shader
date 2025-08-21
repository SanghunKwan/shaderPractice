Shader "Model/SpaceShipModelShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalTex("Bump Map", 2D) = "bump"{}
        _EmissiveTex("Emissive Map", 2D) = "black"{}
        _OccNRoughNMet("Multy Map(Occlusion, Roughness, Metallic", 2D) = "gray"{}

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0


        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalTex;
            float2 uv_EmissiveTex;
            float2 uv_OccNRoughNMet;
        };

        sampler2D _MainTex;
        sampler2D _NormalTex;
        sampler2D _EmissiveTex;
        sampler2D _OccNRoughNMet;


        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 baseColor = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 emiColor = tex2D(_EmissiveTex, IN.uv_EmissiveTex);
            fixed4 multyColor = tex2D(_OccNRoughNMet, IN.uv_OccNRoughNMet);
            o.Normal = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
            
            o.Albedo = baseColor.rgb;
            o.Emission = emiColor.rgb;
            o.Metallic = multyColor.b;
            o.Smoothness = 1 - multyColor.g;
            o.Occlusion = multyColor.r;
            o.Alpha = baseColor.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
