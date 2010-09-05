//-----------------
// un-tweaks
//-----------------
  
matrix WorldVP:WorldViewProjection; 
matrix World:World;    

//-----------------
// tweaks
//-----------------
float4 LightPosition = {2000.0f, 1000.0f, 2000.0f, 1.0f};    
float4 LightColor = {1.0f, 1.0f, 1.0f, 1.0f};    
float LightRange = 4000.0f;      
float4 Ambient = {0.4f, 0.4f, 0.4f, 1.0f};     
float U = 1.0f; 
float V = 1.0f; 

float repeatScale3 = 1.0f;
float repeatScale4 = 1.0f;

//-----------------
// Textures
//-----------------
  
texture detailMap1 <string ResourceName = "";>;
sampler2D detailSample1 = sampler_state {
	texture = (detailMap1);
	minfilter = linear;
	magfilter = linear;
	mipfilter = linear;
	addressU  = wrap;
	addressV  = wrap;
};


texture detailMap3 <string ResourceName = "";>;
sampler2D detailSample3 = sampler_state {
	texture = (detailMap3);
	minfilter = linear;
	magfilter = linear;
	mipfilter = linear;
	addressU  = wrap;
	addressV  = wrap;
};

texture detailMap4 <string ResourceName = "";>;
sampler2D detailSample4 = sampler_state { 
	texture = (detailMap4);
	minfilter = linear;
	magfilter = linear;
	mipfilter = linear;
	addressU  = wrap;
	addressV  = wrap;
};

//-----------------
// structs 
//-----------------
struct input {
	float4 Pos:POSITION; 
	float2 UV:TEXCOORD; 
	float3 Normal : NORMAL;
};
struct output {
	float4 OPos:POSITION; 
	float2 Tex:TEXCOORD0;  
	float3 Attenuation:TEXCOORD1;
	float Diffuse:TEXCOORD2;
};

//-----------------
// vertex shader
//-----------------
output VS(input IN) {
	output OUT;
	OUT.OPos=mul(IN.Pos,WorldVP); 
	OUT.Tex=IN.UV*float2(U,V);
	float3 Wnor=mul(IN.Normal,World); Wnor=normalize(Wnor);
	float3 WPos=mul(IN.Pos,World);  
	float3 LightPos=LightPosition-WPos; 
	OUT.Attenuation=-LightPos/LightRange;
	OUT.Diffuse=saturate(0.02f+mul(Wnor,LightPos)*0.02f); 
	return OUT;
}

//-----------------
// pixel shader
//-----------------
float4 PS(output IN) : COLOR {
	float4 rgbColors1 = tex2D(detailSample1, IN.Tex);
	
	
	float4 texColors3 = tex2D(detailSample3, float2(repeatScale3,repeatScale3) * IN.Tex);
	float4 texColors4 = tex2D(detailSample4, float2(repeatScale4,repeatScale4) * IN.Tex);
	
	
	float4 baseColor;

	baseColor = (texColors3 * rgbColors1);
	baseColor += (texColors4 * (1.0f - rgbColors1));
	

  float4 DiffuseLight=1-saturate(dot(IN.Attenuation,IN.Attenuation));
	float4 Light=DiffuseLight*LightColor*IN.Diffuse;
	return baseColor*(Light+Ambient);
}

technique blendAndLight {
	pass p1 {		
		vertexShader = compile vs_2_0 VS(); 
		pixelShader  = compile ps_2_0 PS();
         
	}
}