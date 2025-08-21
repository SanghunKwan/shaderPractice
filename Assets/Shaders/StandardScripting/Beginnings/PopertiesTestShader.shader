Shader "Beginning/PopertiesTestShader"
{
    Properties
    {
        [Header(parameter)]
        //float을 받는 인터페이스
        //_Name("Display name", int) = number
        //_Name("Display name", Float) = number
        //_Name("Display name", Range(min, max)) = number
        [Toggle]_Number("Integer Number", int) = 1
        _Single("Float Number", Float) = 0.5
        [IntRange]_Rate("Rate Value", Range(0, 1))= 0.5
        // float4를 받는 인터페이스
        //_Name("Display name", Color) = (Number, Number, Number)
        //_Name("Display name", Vector) = (Number, Number, Number)
        [HDR]_BaseColor("Main Color", Color) = (1,1,1)
        _Direction("DirVector", Vector) = (0,0,0)
        [Space(10)]
        [Header(ETC)]
        [Enum(Off, 0, On, 1)]
        _Switch("Switch", Float) = 1

        //기타 Sampler를 받는 인터페이스
        //_Name("Display name", 2D) = "name"{option}
        //_Name("Display name", Rect) = "name"{option}
        //_Name("Display name", Cube) = "name"{option}
        //_Name("Display name", 3D) = "name"{option}
        _MainTex("Main Texture", 2D) = "white"{}
        _CubeTex("Cube Map", Cube) = ""{}   //뒤 내용 생략 필요.


        //float를 받지만 Range로 범위 설정 인터페이스

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows
        

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0


        struct Input
        {
            float2 uv_MainTex;
        };


        float _Number;
        float _Single;
        float _Rate;
        float4 _BaseColor;
        float4 _Direction;
        sampler2D _MainTex;
        samplerCUBE _CubeTex;


        
        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = tex.rgb;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
