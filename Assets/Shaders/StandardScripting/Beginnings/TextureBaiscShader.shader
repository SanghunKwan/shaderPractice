Shader "Beginning/TextureBaiscShader"
{
    Properties
    {
        [Header(Main Map)]
        _MainTex("Albedo (RGB)", 2D) = "white"{}
        _MainColor("Main Color", Color) = (1,1,1,1)

        [space(10)]
        [Header(Sub Map)]
        _SubTex("Second Albedo", 2D) = "white"{}
        _SubColor("Sub Color", Color) = (1,1,1,1)

        [space(10)]
        [Header(Parameter)]
        _Ratio("MainMap Ratio", Range(0, 1)) = 0.5
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
            float2 uv_SubTex;
        };

        sampler2D _MainTex;
        fixed4 _MainColor;
        sampler2D _SubTex;
        fixed4 _SubColor;
        half _Ratio;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 baseColor = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 secondColor = tex2D(_SubTex, IN.uv_SubTex);
            fixed3 mainColor = baseColor.rgb * _MainColor;
            fixed3 subColor = secondColor.rgb * _SubColor;
            //o.Albedo = (color.r*0.299 + color.g * 0.587 + color.b* 0.114) 
            //o.Emission = color * _Ratio + secondColor * (1-_Ratio);
            o.Emission = lerp(mainColor, subColor, 1-_Ratio);
            //o.Albedo =  color.rgb+ secondColor.rgb;
            o.Alpha = baseColor.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
