Shader "Toon/ToonLit"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _BaseColor("BaseColor", Color) = (1,1,1,1)
        [KeywordEnum(Base, Skin, Hair, Cloth)] _Kind("物体类型", Float) = 0
        [NoScaleOffset] _Ramp("Ramp", 2D) = "white" {}
        [NoScaleOffset] _TintRamp("TintRamp", 2D) = "white" {}
        _TintColor1("TintColor1", Color) = (1,1,1,1)
        _TintColor2("TintColor2", Color) = (1,1,1,1)
        _TintColor3("TintColor3", Color) = (1,1,1,1)
        _TintBaseColor("TintBaseColor", Color) = (1,1,1,1)
        _RimColor("RimColor", Color) = (1,1,1,1)
        _RimPower("RimPower", Range(1,10)) = 1 
        _RimStrength("RimStrength", Range(0.1, 5)) = 1 
        [NoScaleOffset] _RimRamp("RimRamp", 2D) = "white" {}
        _HairSphTex("HairSphTex", 2D) = "white" {}
        _HairSphStrength("HairSphStrength", Range(0, 2)) = 1
        _HairSphGloss("HairSphGloss", Range(0.1, 5)) = 1
//        _Outline("Outline", Range(0,0.1)) = 0.02
//        _OutlineFactor("Outline Factor", Range(0,1)) = 0.5
//        _OutlineColor("Outline Color", Color) = (1,1,1,1)
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

            #pragma shader_feature _ _KIND_SKIN _KIND_HAIR _KIND_CLOTH
            
            #pragma vertex ToonForwardPassVertex
            #pragma fragment ToonForwardPassFragment
            #include "ToonForwardPass.hlsl"
            ENDHLSL
        }
    }
}
