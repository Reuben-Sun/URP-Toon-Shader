#ifndef TOON_INPUT_INCLUDED
#define TOON_INPUT_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

UNITY_INSTANCING_BUFFER_START(UnityPerMaterial)
UNITY_DEFINE_INSTANCED_PROP(float4, _BaseColor)
UNITY_DEFINE_INSTANCED_PROP(float4, _MainTex_ST)
UNITY_INSTANCING_BUFFER_END(UnityPerMaterial)

TEXTURE2D(_MainTex);    SAMPLER(sampler_MainTex);
TEXTURE2D(_Ramp);       SAMPLER(sampler_Ramp);

float2 TransformBaseUV(float2 baseUV)   //主帖图 UV转换
{
    float4 baseST = UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _MainTex_ST);
    return baseUV * baseST.xy + baseST.zw;
}

float4 GetBaseColor(float2 baseUV)      //返回 主帖图颜色 * baseColor
{
    float4 map = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, baseUV);
    float4 color = UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _BaseColor);
    return map * color;
}

float4 GetRamp(float2 sampleUV)
{
    float4 ramp = SAMPLE_TEXTURE2D(_Ramp, sampler_Ramp, sampleUV);
    return ramp;
}
#endif