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
    float3 V = normalize(surface.viewDir);
    float3 H = normalize(L + V);

    float NoV = saturate(dot(surface.normal, V));
    float NoH = saturate(dot(surface.normal, H));
    
    float Kd = saturate(dot(surface.normal, L));
    Kd = Kd * 0.5 + 0.49;
    float3 diffuseColor = 0;
    float3 specularColor = 0;
    float3 rimColor = GetRimColor(NoV, surface.matcapUV);
    
    #if defined(_KIND_CLOTH)
        float3 control = GetRamp(float2(Kd, Kd)).rgb;
        diffuseColor = brdf.diffuse * control;
    #elif defined(_KIND_SKIN)
        float3 control = GetTintLayer(float2(Kd, Kd));
        float3 layer1 = (1.0f - control.r * _TintColor1.a) * _TintBaseColor + control.r * _TintColor1.rgb;
        float3 layer2 = (1.0f - control.g * _TintColor2.a) * layer1 + control.g * _TintColor2.rgb;
        float3 layer3 = (1.0f - control.b * _TintColor3.a) * layer2 + control.b * _TintColor3.rgb;
        diffuseColor = brdf.diffuse * layer3;
    #elif defined(_KIND_HAIR)
        float3 control = GetRamp(float2(Kd, Kd)).rgb;   
        diffuseColor = brdf.diffuse * control;
        float specControl = pow(max(0, NoH), GetSphGloss());
        specularColor = surface.hairSpecular * specControl;
    #else
        diffuseColor = brdf.diffuse;
    #endif
    
    return diffuseColor + rimColor + specularColor;
}

#endif