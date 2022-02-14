#ifndef TOON_SURFACE_INCLUDED
#define TOON_SURFACE_INCLUDED

struct Surface
{
    float3 normal;
    float3 baseColor;
    float alpha;
    float3 viewDir;
    float3 posWS;
};

#endif