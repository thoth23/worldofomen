//-----------------
// un-tweaks
//-----------------
matrix WorldVP:WorldViewProjection; 

//-----------------
// tweaks
//-----------------
float2 InvViewSize;
float blurWidth = 0.015f;
float Brightness = 1.80f;

texture background < string Name=""; >;	

sampler2D background_smp = sampler_state 
{
	Texture = <background>;
	AddressU = Clamp; AddressV = Clamp;
	MinFilter = Linear; MagFilter = Linear; MipFilter = None;
};

//-----------------
// structs 
//-----------------
struct input
 {
 	float4 pos:POSITION; 
 	float2 UV:TEXCOORD; 
};

struct output
{
	float4 opos    : POSITION;  
 	float2 uv      : TEXCOORD0;  
};

output VS(float4 pos : POSITION)
{
	output OUT;

	OUT.uv = pos.xy * float2(0.5,-0.5) + 0.5;
	pos.xy = pos.xy + float2( -InvViewSize.x, InvViewSize.y );
	OUT.opos = pos;

	return OUT;	
}

float4 PS(output IN) : COLOR
{
	float4 color=tex2D(background_smp,IN.uv);
	color=pow(color,2);
	color=color*Brightness;
	return color;
}
  
technique screenquad
{
	pass p0
	{		
		VertexShader = compile vs_1_1 VS();
		PixelShader  = compile ps_1_1 PS();	
	}
}

