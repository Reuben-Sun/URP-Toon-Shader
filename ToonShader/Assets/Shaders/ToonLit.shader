Shader "Toon/ToonLit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BaseColor("BaseColor", Color) = (1,1,1,1)
        [NoScaleOffset]_Ramp("Ramp", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            HLSLPROGRAM
            #pragma target 3.5      //级别越高，功能越新，默认是2.5
            #pragma multi_compile_instancing    //允许 GPU Instancing（多例化）
            
            #pragma vertex ToonForwardPassVertex
            #pragma fragment ToonForwardPassFragment
            #include "ToonForwardPass.hlsl"
            ENDHLSL
        }
    }
}
