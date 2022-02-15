#ifndef TOON_INPUT_INCLUDED
#define TOON_INPUT_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

UNITY_INSTANCING_BUFFER_START(UnityPerMaterial)
UNITY_DEFINE_INSTANCED_PROP(float4, _BaseColor)
UNITY_DEFINE_INSTANCED_PROP(float4, _MainTex_ST)

UNITY_DEFINE_INSTANCED_PROP(float4, _TintColor1)
UNITY_DEFINE_INSTANCED_PROP(float4, _TintColor2)
UNITY_DEFINE_INSTANCED_PROP(float4, _TintColor3)
UNITY_DEFINE_INSTANCED_PROP(float4, _TintBaseColor)

// UNITY_DEFINE_INSTANCED_PROP(float, _Outline)
// UNITY_DEFINE_INSTANCED_PROP(float, _OutlineFactor)
// UNITY_DEFINE_INSTANCED_PROP(float4, _OutlineColor)

UNITY_DEFINE_INSTANCED_PROP(float4, _RimColor)
UNITY_DEFINE_INSTANCED_PROP(float, _RimPower)
UNITY_DEFINE_INSTANCED_PROP(float, _RimStrength)

UNITY_DEFINE_INSTANCED_PROP(float4, _HairSphTex_ST)
UNITY_DEFINE_INSTANCED_PROP(float, _HairSphStrength)
UNITY_DEFINE_INSTANCED_PROP(float, _HairSphGloss)


UNITY_INSTANCING_BUFFER_END(UnityPerMaterial)

TEXTURE2D(_MainTex);    SAMPLER(sampler_MainTex);
TEXTURE2D(_Ramp);       SAMPLER(sampler_Ramp);
TEXTURE2D(_TintRamp);  SAMPLER(sampler_TintRamp);
TEXTURE2D(_RimRamp);  SAMPLER(sampler_RimRamp);
TEXTURE2D(_HairSphTex);  SAMPLER(sampler_HairSphTex);

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

float4 GetSphColor(float2 baseUV)
{
    float4 map = SAMPLE_TEXTURE2D(_HairSphTex, sampler_HairSphTex, baseUV);
    float4 color = UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _BaseColor);
    return map * color * _HairSphStrength;
}

float4 GetRamp(float2 sampleUV)
{
    float4 ramp = SAMPLE_TEXTURE2D(_Ramp, sampler_Ramp, sampleUV);
    return ramp;
}

float3 GetTintLayer(float2 sampleUV)
{
    float4 tintRamp = SAMPLE_TEXTURE2D(_TintRamp, sampler_TintRamp, sampleUV);
    return tintRamp.rgb;
}

// float3 GetOutlineColor()
// {
//     return UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _OutlineColor);
// }
//
// float GetOutlineFactor()
// {
//     return UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _OutlineFactor);
// }
//
// float GetOutline()
// {
//     return UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _Outline);
// }

float GetRimColor(float NoV, float2 sampleUV)
{
    float3 mask = SAMPLE_TEXTURE2D(_RimRamp, sampler_RimRamp, sampleUV);
    float powerTime = UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _RimPower);
    float strength = UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _RimStrength);
    float c = pow(1-NoV, powerTime) * strength;
    return _RimColor.rgb * c * mask;; 
}

float GetSphGloss()
{
    return UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, _HairSphGloss);
}
#endif