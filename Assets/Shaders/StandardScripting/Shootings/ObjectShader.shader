Shader "Shootings/ObjectShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalTex ("Bump Map", 2D) = "bump"{}
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
        };

        sampler2D _MainTex;
        sampler2D _NormalTex;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed3 nor = UnpackNormal(tex2D (_NormalTex, IN.uv_NormalTex));
            o.Normal = nor;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
