#ifndef OUTLINE_PASS_INCLUDED
#define OUTLINE_PASS_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "ToonInput.hlsl"
#include "ToonSurface.hlsl"
#include "ToonBRDF.hlsl"
#include "ToonLighting.hlsl"

struct Attributes
{
    float4 vertex: POSITION;    //模型空间顶点坐标
    float3 normal: NORMAL;      //模型空间法向量
};

struct Varyings
{
    float4 pos: SV_POSITION;    //齐次裁剪空间顶点坐标
};

Varyings OutlinePassVertex(Attributes v)
{
    Varyings o = (Varyings)0;
    // float3 pos = normalize(v.vertex.xyz);
    // float3 normal = normalize(v.normal);
    //
    // float D = dot(pos, normal);
    // pos *= sign(D);
    // pos = lerp(normal, pos, GetOutlineFactor());
    // v.vertex.xyz += pos * GetOutline();
    o.pos = TransformObjectToHClip(v.vertex);
    return o;
}

half4 OutlinePassFragment(Varyings i) : SV_Target
{
    
    return float4(GetOutlineColor(),1);
}
#endif