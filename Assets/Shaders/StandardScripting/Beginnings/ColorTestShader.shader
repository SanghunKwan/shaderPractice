Shader "Beginning/ColorTestShader"
{
    Properties
    {
        _GrayScale("Gray Scale Value", Float) = 1
        _Red("Red Color", Range(0,1)) = 1
        _Green("Green Color", Range(0,1)) = 1
        _Blue("Blue Color", Range(0,1)) = 1
        [HDR]_BaseColor("Base Color", Color) = (1,1,1,1)
        [HDR]_SubColor("Sub Color", Color) = (1,1,1)
        _BrightDark("Bright & Darkness", Range(-1,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        //#pragma target 3.0


        struct Input
        {
            float2 uv_MainTex;
        };

        float _GrayScale;
        float _Red;
        float _Green;
        float _Blue;
        fixed4 _BaseColor;
        fixed4 _SubColor;
        float _BrightDark;

        //fixed, half, float


        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = _BaseColor.rgb * _SubColor.rgb + _BrightDark;
            //o.Albedo = _BaseColor;
            // o.Emission = _BaseColor.rgb;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
