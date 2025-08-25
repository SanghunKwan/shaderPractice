Shader "Applying/InnerShader"
{
    Properties
    {
        _MainTex1 ("Albedo (RGB)", 2D) = "white" {}
        _NormalTex1 ("Bump Map", 2D) = "bump"{}
        _MainTex2 ("Albedo (RGB)", 2D) = "black" {}
        _NormalTex2 ("Bump Map", 2D) = "bump"{}
        _MainTex3 ("Albedo (RGB)", 2D) = "black" {}
        _NormalTex3 ("Bump Map", 2D) = "bump"{}
        _MainTex4 ("Albedo (RGB)", 2D) = "black" {}
        _NormalTex4 ("Bump Map", 2D) = "bump"{}

        _Glossiness ("Gloss Value", Range(0,1)) = 0.5
        _Alpha("Alpha", Range(0,5)) = 0.5
        _Turning("turnOnOff", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent""Queue"="Transparent" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Lambert alpha:fade
        #pragma target 4.0


        struct Input
        {
            float2 uv_MainTex1;
            float2 uv_NormalTex1;
            float2 uv_MainTex2;
            float2 uv_NormalTex2;
            float2 uv_MainTex3;
            float2 uv_NormalTex3;
            float2 uv_MainTex4;
            float2 uv_NormalTex4;

            float3 color:Color;
            float3 viewDir;
        };

        sampler2D _MainTex1;
        sampler2D _NormalTex1;
        sampler2D _MainTex2;
        sampler2D _NormalTex2;
        sampler2D _MainTex3;
        sampler2D _NormalTex3;
        sampler2D _MainTex4;
        sampler2D _NormalTex4;
        half _Glossiness;
        float _Alpha;
        float _Turning;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            float turningVector = _Turning * _Time.x;
            fixed4 c1 = tex2D (_MainTex1, IN.uv_MainTex1 + turningVector);
            fixed4 c2 = tex2D (_MainTex2, IN.uv_MainTex2 + turningVector);
            fixed4 c3 = tex2D (_MainTex3, IN.uv_MainTex3 + turningVector);
            fixed4 c4 = tex2D (_MainTex4, IN.uv_MainTex4 + turningVector);

            fixed3 n1 = UnpackNormal(tex2D(_NormalTex1, IN.uv_NormalTex1 + turningVector));
            fixed3 n2 = UnpackNormal(tex2D(_NormalTex2, IN.uv_NormalTex2 + turningVector));
            fixed3 n3 = UnpackNormal(tex2D(_NormalTex3, IN.uv_NormalTex3 + turningVector));
            fixed3 n4 = UnpackNormal(tex2D(_NormalTex4, IN.uv_NormalTex4 + turningVector));

            fixed4 mixedC = lerp( c1,c2, IN.color.r);
            mixedC = lerp( mixedC,c3, IN.color.g);
            mixedC = lerp( mixedC,c4, IN.color.b);

            fixed3 mixedN= lerp(  n1,n2,IN.color.r);
            mixedN= lerp( mixedN,n3, IN.color.g);
            mixedN= lerp( mixedN,n4, IN.color.b);

            o.Albedo = mixedC.rgb;
            o.Gloss = _Glossiness;
            o.Alpha =  pow(1-dot(IN.viewDir, mixedN), _Alpha);
            o.Normal = mixedN;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
