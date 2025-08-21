Shader "Beginning/FireEffectShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SubTex("Sub Albedo", 2D) = "white"{}
        _NoiseTex("Noise Map", 2D) = "gray"{}
        _SlingValue("Sling Value" , Range(1,5)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard alpha:fade
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _SubTex;
        sampler2D _NoiseTex;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_SubTex;
            float2 uv_NoiseTex;
        };
        
        float _SlingValue;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 uvSub = float2(IN.uv_SubTex.x, IN.uv_SubTex.y - _Time.y);
            float2 uvNoise = float2(IN.uv_NoiseTex.x + _CosTime.x, IN.uv_NoiseTex.y - _Time.y);
            fixed4 noise = tex2D(_NoiseTex, uvNoise);
            fixed4 main = tex2D (_MainTex, IN.uv_MainTex + noise.r * _SlingValue);
            fixed4 sub  = tex2D (_SubTex, uvSub + noise.r * _SlingValue);

            o.Emission = main.rgb * sub.rgb;
            o.Alpha = main.a * sub.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
