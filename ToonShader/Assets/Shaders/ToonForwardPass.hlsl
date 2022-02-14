#ifndef TOON_FORWARD_PASS_INCLUDED
#define TOON_FORWARD_PASS_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "ToonInput.hlsl"
#include "ToonSurface.hlsl"
#include "ToonBRDF.hlsl"
#include "ToonLighting.hlsl"

struct Attributes
{
    float4 vertex: POSITION;    //模型空间顶点坐标
    float3 normal: NORMAL;      //模型空间法向量
    float2 uv: TEXCOORD0;       //第一套 uv
};

struct Varyings
{
    float4 pos: SV_POSITION;    //齐次裁剪空间顶点坐标
    float2 uv: TEXCOORD0;           //纹理坐标
    float3 normalWS: TEXCOORD1;     //世界空间法线
    float3 posWS: TEXCOORD3;        //世界空间顶点位置
};

Varyings ToonForwardPassVertex(Attributes v)
{
    Varyings o = (Varyings)0;
    o.pos = TransformObjectToHClip(v.vertex.xyz);
    o.posWS = TransformObjectToWorld(v.vertex.xyz);
    o.uv = TransformBaseUV(v.uv);
    o.normalWS = TransformObjectToWorldNormal(v.normal);
    return o;
}

half4 ToonForwardPassFragment(Varyings i) : SV_Target
{
    float4 color = GetBaseColor(i.uv);

    Surface surface;
    surface.baseColor = color.rgb;
    surface.alpha = color.a;
    surface.normal = normalize(i.normalWS);
    surface.posWS = i.posWS;
    surface.viewDir = GetCameraPositionWS() - i.posWS;

    BRDF brdf = GetBRDF(surface);

    float3 finalColor = GetLighting(surface, brdf);
    return float4(finalColor, surface.alpha);
}
#endif