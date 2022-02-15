Shader "Unlit/MatCap"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Tags{"LightMode" = "UniversalForward"}
            
            HLSLPROGRAM
            #pragma target 3.5      //级别越高，功能越新，默认是2.5
            #pragma multi_compile_instancing    //允许 GPU Instancing（多例化）

           
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            
            struct Attributes
            {
                float4 vertex: POSITION;    //模型空间顶点坐标
                float3 normal: NORMAL;      //模型空间法向量
            };

            struct Varyings
            {
                float4 pos: SV_POSITION;    //齐次裁剪空间顶点坐标
                float2 uv: TEXCOORD0;           //纹理坐标
                float3 normalWS: TEXCOORD1;     //世界空间法线
                float3 normalVS: TEXCOORD2;     //观察空间法线
                float3 posWS: TEXCOORD3;        //世界空间顶点位置
            };

            UNITY_INSTANCING_BUFFER_START(UnityPerMaterial)
                UNITY_DEFINE_INSTANCED_PROP(float4, _MainTex_ST)
            UNITY_INSTANCING_BUFFER_END(UnityPerMaterial)
            
            TEXTURE2D(_MainTex);    SAMPLER(sampler_MainTex);
            
            Varyings vert(Attributes v)
            {
                Varyings o = (Varyings)0;
                o.pos = TransformObjectToHClip(v.vertex.xyz);
                o.posWS = TransformObjectToWorld(v.vertex.xyz);
                o.normalWS = TransformObjectToWorldNormal(v.normal);
                o.normalVS = normalize(mul((float3x3)UNITY_MATRIX_MV, v.normal));
                return o;
            }

            half4 frag(Varyings i) : SV_Target
            {
                float3 N = i.normalVS;
                float2 baseUV = float2(N.x, N.y) * 0.5 + 0.5;
                float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, baseUV);
                return color;
            }

            ENDHLSL
        }
    }
}
