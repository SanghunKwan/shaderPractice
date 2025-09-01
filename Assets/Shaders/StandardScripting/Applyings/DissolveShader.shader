Shader "Applying/DissolveShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NoiseTex("Noise Map", 2D) = "white"{}
        _CutValue("Alpha Cut", Range(0,1)) = 0
        [HDR] _OutColor("OutLine Color", Color) = (1,1,1,1)
        _OutThickness("OutLine Thickness", Range(1,1.15)) = 1.15
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade
        #pragma target 3.0


        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NoiseTex;
        };

        sampler2D _MainTex;
        sampler2D _NoiseTex;
        float _CutValue;
        float4 _OutColor;
        float _OutThickness;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 baseColor = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 noise = tex2D (_NoiseTex, IN.uv_NoiseTex);
            o.Albedo = baseColor.rgb;
            
            float alpha = 0;
            if(noise.r >= _CutValue)
                alpha = 1;

            float outLine = 0;
            if(noise.r < _CutValue * _OutThickness)
            outLine = 1;

            o.Emission = outLine * _OutColor.rgb;
            o.Alpha = alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
