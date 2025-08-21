Shader "Beginning/VertexColorTestShader"
{
    Properties
    {
        [Header(Texuture Map)]
        _MainTex1 ("Texture1", 2D) = "white" {}
        _MainTex2 ("Texture2", 2D) = "white" {}
        _MainTex3 ("Texture3", 2D) = "white" {}
        _MainTex4 ("Texture4", 2D) = "white" {}
        _Normal1("Normal Texure1", 2D) = "bump"{}
        _Normal2("Normal Texure2", 2D) = "bump"{}
        _Normal3("Normal Texure3", 2D) = "bump"{}
        _Normal4("Normal Texure4", 2D) = "bump"{}

        [Header(Parameter)]
        Metallic("Metalic Value", Range(0,1)) = 0
        _Smoothness("Smoothness Value", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 4.0

        sampler2D _MainTex1;
        sampler2D _MainTex2;
        sampler2D _MainTex3;
        sampler2D _MainTex4;
        sampler2D _Normal1;
        sampler2D _Normal2;
        sampler2D _Normal3;
        sampler2D _Normal4;

        struct Input
        {
            float2 uv_MainTex1;
            float2 uv_MainTex2;
            float2 uv_MainTex3;
            float2 uv_MainTex4;
            float2 uv_Normal1;
            float2 uv_Normal2;
            float2 uv_Normal3;
            float2 uv_Normal4;
            float4 color:Color;
        };

        float Metallic;
        float _Smoothness;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 tex1 = tex2D (_MainTex1, IN.uv_MainTex1);
            fixed4 tex2 = tex2D (_MainTex2, IN.uv_MainTex2 );
            fixed4 tex3 = tex2D (_MainTex3, IN.uv_MainTex3);
            fixed4 tex4 = tex2D (_MainTex4, IN.uv_MainTex4 + _Time.x);
            fixed3 nor1 = UnpackNormal(tex2D(_Normal1, IN.uv_Normal1));
            fixed3 nor2 = UnpackNormal(tex2D(_Normal2, IN.uv_Normal2));
            fixed3 nor3 = UnpackNormal(tex2D(_Normal3, IN.uv_Normal3));
            fixed3 nor4 = UnpackNormal(tex2D(_Normal4, IN.uv_Normal4 + _Time.x));

            fixed4 first = lerp(tex1, tex2, IN.color.r);
            fixed4 second = lerp(first, tex3, IN.color.g);

            fixed3 third = lerp(nor1, nor2, IN.color.r);
            fixed3 fourth = lerp(third, nor3, IN.color.g);

            o.Emission= lerp(second, tex4, IN.color.b);//tex1.rgb;//IN.color;
            o.Metallic = Metallic;
            o.Smoothness = _Smoothness;
            o.Normal = lerp( fourth, nor4, IN.color.b);
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
