Shader "Beginning/UVTestShader"
{
    Properties
    {
        _MainTex("Albedo (RGB)",2D) = ""{}
        [intRange]_TillingX("Tilling X Value", Range(1, 8)) = 1
        [intRange]_TillingY("Tilling Y Value", Range(1, 8)) = 1
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
        };
        
        sampler2D _MainTex; 
        half _TillingX;
        half _TillingY;


        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 uv = float2(IN.uv_MainTex.x * _TillingX, IN.uv_MainTex.y* _TillingY);
            //fixed4 baseColor = tex2D(_MainTex, uv);
            fixed4 baseColor = tex2D(_MainTex, IN.uv_MainTex + _Time.x);
            //o.Albedo = 1;
            //o.Emission = fixed3(IN.uv_MainTex.x, IN.uv_MainTex.y,0);
            o.Emission = baseColor.rgb;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
