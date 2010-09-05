float tile = 1;
float depth = 0.1;
float3 ambient = {0.2,0.2,0.2};
float3 diffuse = {1,1,1};
float3 specular = {0.75,0.75,0.75};
float shine = 128.0;
float3 lightpos : POSITION = { -150.0, 200.0, -125.0 };
float U = 1.0f; 
float V = 1.0f; 
float repeatScale3 = 1.0f;
float repeatScale4 = 1.0f;


float4x4 modelviewproj : WorldViewProjection;
float4x4 modelview : WorldView;
float4x4 modelinv : WorldInverse;
float4x4 view : View;

texture normalmap : NORMAL<string ResourceName = ""; string ResourceType = "2D";>;
sampler2D samplenormal = sampler_state
{
	Texture = <normalmap>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};

texture mixermap <string ResourceName = "";>;
sampler2D samplemixer = sampler_state {
	texture = (mixermap);
	minfilter = linear;
	magfilter = linear;
	mipfilter = linear;
	addressU  = wrap;
	addressV  = wrap;
};


texture colorbase <string ResourceName = "";>;
sampler2D samplebase = sampler_state {
	texture = (colorbase);
	minfilter = linear;
	magfilter = linear;
	mipfilter = linear;
	addressU  = wrap;
	addressV  = wrap;
};

texture coloroverlay <string ResourceName = "";>;
sampler2D sampleoverlay = sampler_state { 
	texture = (coloroverlay);
	minfilter = linear;
	magfilter = linear;
	mipfilter = linear;
	addressU  = wrap;
	addressV  = wrap;
};

struct a2v 
{
    float4 pos	: POSITION;
    float4 color	: COLOR0;
    float3 normal	: NORMAL;
    float2 txcoord	: TEXCOORD0;
    float3 tangent	: TANGENT0;
    float3 binormal	: BINORMAL0;
};

struct v2f
{
    float4 hpos	: POSITION;
    float4 color	: COLOR0;
    float2 txcoord	: TEXCOORD0;
    float3 vpos	: TEXCOORD1;
    float3 tangent	: TEXCOORD2;
    float3 binormal	: TEXCOORD3;
    float3 normal	: TEXCOORD4;
    float4 lightpos	: TEXCOORD5;
};

v2f view_space(a2v IN)
{
	v2f OUT;

	// vertex position in object space
	float4 pos=float4(IN.pos.x,IN.pos.y,IN.pos.z,1.0);

	// compute modelview rotation only part
	float3x3 modelviewrot;
	modelviewrot[0]=modelview[0].xyz;
	modelviewrot[1]=modelview[1].xyz;
	modelviewrot[2]=modelview[2].xyz;

	// vertex position in clip space
	OUT.hpos=mul(pos,modelviewproj);

	// vertex position in view space (with model transformations)
	OUT.vpos=mul(pos,modelview).xyz;

	// light position in view space
	float4 lp=float4(lightpos.x,lightpos.y,lightpos.z,1);
	OUT.lightpos=mul(lp,view);

	// tangent space vectors in view space (with model transformations)
	OUT.tangent=mul(IN.tangent,modelviewrot);
	OUT.binormal=mul(IN.binormal,modelviewrot);
	OUT.normal=mul(IN.normal,modelviewrot);
	
	// copy color and texture coordinates
	OUT.color=IN.color;
	OUT.txcoord=IN.txcoord.xy;

	return OUT;
}

float4 normal_map(
	v2f IN,
	uniform sampler2D normalmap,
	uniform sampler2D mixermap,
	uniform sampler2D colorbase,
	uniform sampler2D coloroverlay) : COLOR
{
	float4 normal=tex2D(normalmap,IN.txcoord*tile);
	normal.xy=normal.xy*2.0-1.0; // trafsform to [-1,1] range
	normal.z=sqrt(1.0-dot(normal.xy,normal.xy)); // compute z component
	
	// transform normal to world space
	normal.xyz=normalize(normal.x*IN.tangent-normal.y*IN.binormal+normal.z*IN.normal);
	
	// color map
	float4 rgbColors1 = tex2D(samplemixer, IN.txcoord);
	float4 texColors3 = tex2D(samplebase, float2(repeatScale3,repeatScale3) * IN.txcoord);
	float4 texColors4 = tex2D(sampleoverlay, float2(repeatScale4,repeatScale4) * IN.txcoord);
	float4 color;
	color = (texColors3 * rgbColors1);
	color += (texColors4 * (1.0f - rgbColors1));

	// view and light directions
	float3 v = normalize(IN.vpos);
	float3 l = normalize(IN.lightpos.xyz-IN.vpos);

	// compute diffuse and specular terms
	float att=saturate(dot(l,IN.normal.xyz));
	float diff=saturate(dot(l,normal.xyz));
	float spec=saturate(dot(normalize(l-v),normal.xyz));

	// compute final color
	float4 finalcolor;
	finalcolor.xyz=ambient*color.xyz+
		att*(color.xyz*diffuse.xyz*diff+specular.xyz*pow(spec,shine));
	finalcolor.w=1.0;

	return finalcolor;
}


technique normal_blend
{
    pass p0 
    {
    	CullMode = CCW;
		VertexShader = compile vs_1_1 view_space();
		PixelShader  = compile ps_2_0 normal_map(samplenormal,samplemixer,samplebase,sampleoverlay);
    }
}


