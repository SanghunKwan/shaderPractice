Shader "Beginning/RiverShader"
{
    Properties
    {
        [Header(firstTex)]
        _MainTex1 ("Albedo (RGB)", 2D) = "white" {}
        _NormalTex1("Normal", 2D) = "bump"{}
        _Color1 ("Color", Color) = (1,1,1,1)
        
        [Header(secondTex)]
        _MainTex2 ("Albedo (RGB)", 2D) = "white" {}
        _NormalTex2("Normal", 2D) = "bump"{}
       _Color2 ("Color", Color) = (1,1,1,1)
        [Header(thirdTex)]
        _MainTex3 ("Albedo (RGB)", 2D) = "white" {}
        _NormalTex3("Normal", 2D) = "bump"{}
        _Color3 ("Color", Color) = (1,1,1,1)
        [Header(fourthTex)]
        _MainTex4("Albedo (RGB)", 2D) = "white" {}
        _NormalTex4("Normal", 2D) = "bump"{}
        _Color4 ("Color", Color) = (1,1,1,1)
        
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        LOD 200

        CGPROGRAM
        
        #pragma surface surf Standard alpha:fade
        #pragma target 4.0

        sampler2D _MainTex1;
        sampler2D _NormalTex1;
         sampler2D _MainTex2;
        sampler2D _NormalTex2;
         sampler2D _MainTex3;
        sampler2D _NormalTex3;
         sampler2D _MainTex4;
        sampler2D _NormalTex4;

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

            float4 color:Color;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color1;
        fixed4 _Color2;
        fixed4 _Color3;
        fixed4 _Color4;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c1 = tex2D (_MainTex1, IN.uv_MainTex1) * _Color1;
            fixed4 c2 = tex2D (_MainTex2, IN.uv_MainTex2) * _Color2;
            fixed4 c3 = tex2D (_MainTex3, IN.uv_MainTex3) * _Color3;
            fixed4 c4 = tex2D (_MainTex4, IN.uv_MainTex4- _Time.x) * _Color4;

            fixed3 n1 = UnpackNormal(tex2D(_NormalTex1, IN.uv_NormalTex1));
            fixed3 n2 = UnpackNormal(tex2D(_NormalTex2, IN.uv_NormalTex2));
            fixed3 n3 = UnpackNormal(tex2D(_NormalTex3, IN.uv_NormalTex3));
            fixed3 n4 = UnpackNormal(tex2D(_NormalTex4, IN.uv_NormalTex4- _Time.x));

            fixed4 returnColor = lerp(c4,c3,IN.color.r);
            returnColor = lerp(returnColor,c2,IN.color.g);
            returnColor = lerp(returnColor,c1,IN.color.b);
           

            fixed3 returnNormal = lerp(n4,n3, IN.color.r);
            returnNormal = lerp(returnNormal,n2, IN.color.g);
            returnNormal = lerp(returnNormal,n1, IN.color.b);


            o.Albedo=   lerp(returnColor,c1,IN.color.b);
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = returnColor.a;
            o.Normal = returnNormal;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
