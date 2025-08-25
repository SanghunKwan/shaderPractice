Shader "Applying/HoloStandardShader"
{
    Properties
    {
        [Header(Main Map)]
       _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalTex("Bump Map", 2D) = "bump"{}

        [Header(Lim Light Param)]
        _LimColor("Limlight Color", Color) = (1,1,1,1)
        _LimPower("LimPower",Range(1,10)) = 1
        _MixingRatio("Mixing Ratio", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert noambient alpha:fade
        #pragma target 3.0


        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalTex;
            float2 viewDir;
        };

        sampler2D _MainTex;
        sampler2D _NormalTex;

        fixed4 _LimColor;
        float _LimPower;
        float _MixingRatio;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 base = tex2D (_MainTex, IN.uv_MainTex);
            fixed3 nor = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
            o.Normal = nor;
            o.Albedo = base.rgb;
             //LimLight °è»ê
            float lim =  dot(IN.viewDir,nor);
            lim = pow(1 - lim, _LimPower);
            o.Emission = lerp( base.rgb, _LimColor.rgb, _MixingRatio) ;
            /* pow(1 - lim, _LimPower) * _LimColor.rgb; */
            o.Alpha = lim;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
