Shader "Applying/OuterShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalTex ("Bump Map", 2D) = "bump"{}
        _Glossiness ("Gloss Value", Range(0,1)) = 0.5
        _Alpha("Alpha", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent""Queue"="Transparent" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Lambert alpha:fade
        #pragma target 3.0


        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalTex;
        };

        sampler2D _MainTex;
        sampler2D _NormalTex;
        half _Glossiness;
        float _Alpha;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Gloss = _Glossiness;
            o.Alpha = _Alpha;
            o.Normal = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
