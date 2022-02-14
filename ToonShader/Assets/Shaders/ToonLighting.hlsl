#ifndef TOON_LIGHTING_INCLUDED
#define TOON_LIGHTING_INCLUDED

#include "ToonSurface.hlsl"
#include "ToonBRDF.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

float3 HalfLambertLighting(Surface surface, Light light)
{
    float halfLambert = saturate(dot(surface.normal, light.direction)) * 0.5 + 0.5;
    return halfLambert * light.shadowAttenuation * light.color;
    
}

float3 GetLighting(Surface surface, BRDF brdf, Light light)
{
    float3 directColor = HalfLambertLighting(surface, light) * DirectBRDF(surface, brdf, light);
    return directColor;
}

float3 GetLighting(Surface surface, BRDF brdf)
{
    Light light = GetMainLight();
    float3 color = 0;
    color += GetLighting(surface, brdf, light);
    return color;
}

#endif