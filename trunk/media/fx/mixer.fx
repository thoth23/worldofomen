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

float repeatScale3 = 64.0f;
float repeatScale4 = 512.0f;
float repeatScale5 = 32.0f;
float repeatScale6 = 32.0f;
float repeatScale7 = 32.0f;
float repeatScale8 = 32.0f;

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

texture detailMap2 <string ResourceName = "";>;
sampler2D detailSample2 = sampler_state {
	texture = (detailMap2);
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

texture detailMap5 <string ResourceName = "";>;
sampler2D detailSample5 = sampler_state {
	texture = (detailMap5);
	minfilter = linear;
	magfilter = linear;
	mipfilter = linear;
	addressU  = wrap;
	addressV  = wrap;
};

texture detailMap6 <string ResourceName = "";>;
sampler2D detailSample6 = sampler_state {
	texture = (detailMap6);
	minfilter = linear;
	magfilter = linear;
	mipfilter = linear;
	addressU  = wrap;
	addressV  = wrap;
};

texture detailMap7 <string ResourceName = "";>;
sampler2D detailSample7 = sampler_state {
	texture = (detailMap7);
	minfilter = linear;
	magfilter = linear;
	mipfilter = linear;
	addressU  = wrap;
	addressV  = wrap;
};

texture detailMap8 <string ResourceName = "";>;
sampler2D detailSample8 = sampler_state {
	texture = (detailMap8);
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
	float4 rgbColors2 = tex2D(detailSample2, IN.Tex);
	
	float4 texColors3 = tex2D(detailSample3, float2(repeatScale3,repeatScale3) * IN.Tex);
	float4 texColors4 = tex2D(detailSample4, float2(repeatScale4,repeatScale4) * IN.Tex);
	float4 texColors5 = tex2D(detailSample5, float2(repeatScale5,repeatScale5) * IN.Tex);
	float4 texColors6 = tex2D(detailSample6, float2(repeatScale6,repeatScale6) * IN.Tex);
	float4 texColors7 = tex2D(detailSample7, float2(repeatScale7,repeatScale7) * IN.Tex);
	float4 texColors8 = tex2D(detailSample8, float2(repeatScale8,repeatScale8) * IN.Tex);
	
	
	float4 baseColor;

	baseColor = (texColors3 * rgbColors1.r);
	baseColor += (texColors4 * rgbColors1.g);
	baseColor += (texColors5 * rgbColors1.b);
		
	baseColor += (texColors6 * rgbColors2.r);
	baseColor += (texColors7 * rgbColors2.g);
	baseColor += (texColors8 * rgbColors2.b);
	
	

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