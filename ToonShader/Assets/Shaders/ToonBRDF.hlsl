#ifndef TOON_BRDF_INCLUDED
#define TOON_BRDF_INCLUDED

#include "ToonSurface.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

struct BRDF
{
    float3 diffuse;
};

BRDF GetBRDF(Surface surface)     //获取BRDF
{
    BRDF brdf = (BRDF)0;
    brdf.diffuse = surface.baseColor;

    return brdf;
}

float3 DirectBRDF(Surface surface, BRDF brdf, Light light)
{
    float3 L = normalize(light.direction);
    float Kd = saturate(dot(surface.normal, L));
    Kd = Kd * 0.5 + 0.4;
    float3 diff = GetRamp(float2(Kd, Kd)).rgb;
    return brdf.diffuse * diff;
}

#endif