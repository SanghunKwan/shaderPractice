Shader "Shootings/ObjectSelectShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalTex ("Bump Map", 2D) = "bump"{}

        _OutLineColor ("OutLine Color", Color) = (0,0,0,1)
        [IntRange]_OutLineThickness("OutLine Weght", Range(1,20)) = 5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        cull front
        LOD 200
        CGPROGRAM

        #pragma surface surf Nolight vertex:vert noshadow noambient
        #pragma target 3.0


        struct Input
        {
            float2 uv_MainTex;
        };

        float4 _OutLineColor;
        float _OutLineThickness;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void vert(inout appdata_full v)
        {
            v.vertex.xyz = v.vertex.xyz +v.normal.xyz * (_OutLineThickness * 0.001);
        }
        void surf (Input IN, inout SurfaceOutput o)
        {
            
        }
        float4 LightingNolight(SurfaceOutput s, float lightDir, float atten)
        {
            return _OutLineColor;
            }
        ENDCG
        cull back
        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0


        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalTex;
        };

        sampler2D _MainTex;
        sampler2D _NormalTex;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed3 nor = UnpackNormal(tex2D (_NormalTex, IN.uv_NormalTex));
            o.Normal = nor;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
