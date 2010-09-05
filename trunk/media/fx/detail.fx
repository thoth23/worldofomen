// THIS IS A COPY OF ALPHAFADE TO CREATE A PLACEHOLDER FX IN THE SYSTEM

//
// Alpha Fade By Distance in Z axis
//

// model info
string XFile = "sphere.x";

// textures
texture DiffuseMap : DiffuseMap < string Name = "default.dds"; string type = "2D"; >;

// transformations
float4x3 WorldView  : WORLDVIEW;
float4x4 Projection : PROJECTION;

// light direction (view space)
float3 L < string UIDirectional = "Light Direction"; > = normalize(float3(-0.397f, -0.397f, 0.827f));

float SolidAtZ = 0.0f;

struct VS_OUTPUT
{
    float4 Position : POSITION;
    float4 Color    : COLOR0;
    float2 Tex      : TEXCOORD0;
    float  Fade     : TEXCOORD1;
};

VS_OUTPUT VS(    
    float3 Position : POSITION,
    float2 TexCoord : TEXCOORD0,
    float3 Normal   : NORMAL)
{
    VS_OUTPUT Out = (VS_OUTPUT)0;

    L = -L;

    float3 P = mul(float4(Position, 1), (float4x3)WorldView);   // position (view space)
    float3 N = normalize(mul(Normal, (float3x3)WorldView));     // normal (view space)

    // position (projected)
    Out.Position = mul(float4(P, 1), Projection);             
                                 
    // environment cube map coordinates
    Out.Tex = TexCoord;
    Out.Color = dot(N, L);
    Out.Fade = 1.0 - (abs(P.z-SolidAtZ)/500.0);
            
    return Out;
}

// samplers
sampler Diffuse = sampler_state
{ 
    Texture = (DiffuseMap);
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};

// pixel shader
float4 PS(VS_OUTPUT In) : COLOR
{   
    float4 Color;
    Color.rgb = tex2D(Diffuse, In.Tex).xyz * In.Color.xyz;
    Color.w   = In.Fade;
    return Color;
}  

// technique
technique TCubeMapGlass
{
    pass P0
    {
        VertexShader = compile vs_1_0 VS();
        PixelShader  = compile ps_1_0 PS();

        // enable alpha blending
        AlphaBlendEnable = TRUE;
        SrcBlend         = SRCALPHA;
        DestBlend        = INVSRCALPHA;
    }
}

