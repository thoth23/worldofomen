//********************************************************************************************
//
// Bumpmapping with 8 lights ( 2 passes) (ps v1.4 , vs v1.1)          
// by EVOLVED    	   
//
//	
/////////////////////////////////////////////
// un-TWEAKABLES 
	matrix WorldViewProj : WorldViewProjection;
	matrix World :  World; 
	matrix ViewInv : ViewInverse;
// TWEAKABLES 	
	float3 LP_1 <> = {100.0f, 100.0f, -100.0f};	// light position 1
	float  LR_1 <> = 50.0;		// light range 1
	float4 LC_1 <> = {1.0f, 1.0f, 1.0f, 0.0f};	// light color 1
	float3 LP_2 <> = {100.0f, 100.0f, -100.0f};	// light position 2
	float  LR_2 <> = 50.0;		// light range 2
	float4 LC_2 <> = {1.0f, 0.0f, 0.0f, 0.0f};	// light color 2
	float3 LP_3 <> = {100.0f, 100.0f, -100.0f};	// etc..
	float  LR_3 <> = 50.0;
	float4 LC_3 <> = {0.0f, 1.0f, 0.0f, 0.0f};
	float3 LP_4 <> = {100.0f, 100.0f, -100.0f};
	float  LR_4 <> = 50.0;
	float4 LC_4 <> = {0.0f, 0.0f, 1.0f, 0.0f};
	float3 LP_5 <> = {100.0f, 100.0f, -100.0f};
	float  LR_5 <> = 50.0;
	float4 LC_5 <> = {1.0f, 1.0f, 0.0f, 0.0f};
	float3 LP_6 <> = {100.0f, 100.0f, -100.0f};
	float  LR_6 <> = 50.0;
	float4 LC_6 <> = {1.0f, 0.0f, 1.0f, 0.0f};
	float3 LP_7 <> = {100.0f, 100.0f, -100.0f};
	float  LR_7 <> = 50.0;
	float4 LC_7 <> = {0.0f, 1.0f, 1.0f, 0.0f};
	float3 LP_8 <> = {100.0f, 100.0f, -100.0f};
	float  LR_8 <> = 50.0;
	float4 LC_8 <> = {1.0f, 0.50f, 0.0f, 0.0f};
//********************************************************************************************
// Textures
   texture colorTexture < string Name = "<defalt>"; >;	// grab our base texture (TextCord 0)
	sampler2D colorSampler = sampler_state // grab our base sampler
		{
		Texture = <colorTexture>;
		};
   texture normalTexture <string Name = "<defalt>"; >; // grab our noramlmap texture (TextCord 1)
	sampler2D normalSampler = sampler_state // grab our noramlmap sampler
		{
		Texture = <normalTexture>;
		};
//********************************************************************************************
// DATA STRUCTS 
	// vertex data
		struct appdata {
    			float4 Position	: POSITION;
          		float4 UV       : TEXCOORD;
        		float3 Normal	: NORMAL;
   			float3 Tangent	: TANGENT;
    			float3 Binormal	: BINORMAL;
		};
	// vertex to pixel shader data
		struct VSOutput {
    			float4 pos	        : POSITION;
    			float2 uv		: TEXCOORD0; 
        		float3 Light1		: TEXCOORD1;
     			float3 Light2		: TEXCOORD2; 			
        		float3 Light3		: TEXCOORD3;
        		float3 Light4		: TEXCOORD4;
               	};
//********************************************************************************************
VSOutput mainVS1(appdata IN) // 1st vertex data for light 1-4
		{
   		VSOutput OUT;
       			OUT.pos       = mul( IN.Position , WorldViewProj ); // out pos
			OUT.uv	      = IN.UV; // out uv data
		float3 WP = mul(IN.Position, World).xyz; // world space position
		float3x3 TM = {IN.Tangent,IN.Binormal,IN.Normal}; // tangent Matrix
		TM = transpose(TM);
	 	float3 L =  LP_1  - WP; // light vector in would space pos
    	 	 float Ld = (1/length(L)); // light range
	   	   float3 LO = mul(L,TM); // multiply light vector x tangent Matrix
		     OUT.Light1 = normalize(LO) * (Ld*LR_1)-0.2 ; // normalize our final lv and add range
	 	 L =  LP_2  - WP; // do the above 3 more times
    	 	  Ld = (1/length(L));
	   	    LO = mul(L,TM);
		     OUT.Light2 = normalize(LO) * (Ld*LR_2)-0.2 ;
	 	 L =  LP_3  - WP;
    	 	  Ld = (1/length(L));
	   	    LO = mul(L,TM);
		     OUT.Light3 = normalize(LO) * (Ld*LR_3)-0.2 ;
	 	 L =  LP_4  - WP;
    	 	  Ld = (1/length(L));
	   	    LO = mul(L,TM);
		     OUT.Light4 = normalize(LO) * (Ld*LR_4)-0.2 ;
  return OUT;
}
VSOutput mainVS2(appdata IN) // 2nd vertex data for light 5-8
		{
   		VSOutput OUT;
       			OUT.pos       = mul( IN.Position , WorldViewProj );
			OUT.uv	      = IN.UV;
		float4 TP = float4(IN.Position);
		float3 WP = mul(TP, World).xyz;
		float3x3 TM = {IN.Tangent,IN.Binormal,IN.Normal};
		TM = transpose(TM);
	 	float3 L =  LP_5  - WP;
    	 	 float Ld = (1/length(L));
	   	   float3 LO = mul(L,TM);
		     OUT.Light1 = normalize(LO) * (Ld*LR_5)-0.2 ;
	 	 L =  LP_6  - WP;
    	 	  Ld = (1/length(L));
	   	    LO = mul(L,TM);
		     OUT.Light2 = normalize(LO) * (Ld*LR_6)-0.2 ;
	 	 L =  LP_7  - WP;
    	 	  Ld = (1/length(L));
	   	    LO = mul(L,TM);
		     OUT.Light3 = normalize(LO) * (Ld*LR_7)-0.2 ;
	 	 L =  LP_8  - WP;
    	 	  Ld = (1/length(L));
	   	    LO = mul(L,TM);
		     OUT.Light4 = normalize(LO) * (Ld*LR_8)-0.2 ;
  return OUT;
}
//********************************************************************************************
float4 PS_bumpmap_lights1(VSOutput IN)  : COLOR
{
	float4 TB=tex2D(colorSampler,IN.uv); // base map
   	float4 NB=tex2D(normalSampler,IN.uv)*2-1; // noraml map
	 	float3 LV=IN.Light1; // get light vector position
	 		float GLB=saturate(dot(NB,LV)); // combine the light vector with the noraml map 
	 			float4 TN=GLB*LC_1 ; // add color
		float4 result= TB * TN; // return this
   	return result;
}
float4 PS_bumpmap_lights2(VSOutput IN)  : COLOR
{
	float4 TB=tex2D(colorSampler,IN.uv);
   	float4 NB=tex2D(normalSampler,IN.uv)*2-1;
	 	float3 LV=IN.Light1; // get light vector position 1
	 		float GLB=saturate(dot(NB,LV)); // combine
	 			float4 TN=GLB*LC_1 ; // add color
		LV=IN.Light2; // get light vector position 2
			 GLB=saturate(dot(NB,LV)); // combine
				TN=TN+GLB*LC_2 ; // add new result to the previous + color
		float4 result= TB * TN ; // return this
   	return result;
}
float4 PS_bumpmap_lights3(VSOutput IN)  : COLOR
{
	float4 TB=tex2D(colorSampler,IN.uv);
   	float4 NB=tex2D(normalSampler,IN.uv)*2-1;
	 	float3 LV=IN.Light1;
	 		float GLB=saturate(dot(NB,LV));
	 			float4 TN=GLB*LC_1 ;
	 	LV=IN.Light2;
	 		GLB=saturate(dot(NB,LV));
	 			TN=TN+GLB*LC_2 ;
	 	LV=IN.Light3;
	 		GLB=saturate(dot(NB,LV));
	 			TN=TN+GLB*LC_3 ;
		float4 result= TB * TN ;
   	return result;
}
float4 PS_bumpmap_lights4(VSOutput IN)  : COLOR
{
	float4 TB=tex2D(colorSampler,IN.uv);
   	float4 NB=tex2D(normalSampler,IN.uv)*2-1;
	 	float3 LV=IN.Light1;
	 		float GLB=saturate(dot(NB,LV));
	 			float4 TN=GLB*LC_1 ;
	 	LV=IN.Light2;
	 		GLB=saturate(dot(NB,LV));
	 			TN=TN+GLB*LC_2 ;
	 	LV=IN.Light3;
	 		GLB=saturate(dot(NB,LV));
	 			TN=TN+GLB*LC_3 ;
	 	
	 	LV=IN.Light4;
	 		GLB=saturate(dot(NB,LV));
	 			TN=TN+GLB*LC_4 ;
		float4 result= TB * TN ;
   	return result;
}
float4 PS_bumpmap_lights5(VSOutput IN)  : COLOR
{
	float4 TB=tex2D(colorSampler,IN.uv);
   	float4 NB=tex2D(normalSampler,IN.uv)*2-1;
	 	float3 LV=IN.Light1;
	 		float GLB=saturate(dot(NB,LV));
	 			float4 TN=GLB*LC_5 ;
		float4 result= TB * TN ;
   	return result;
}
float4 PS_bumpmap_lights6(VSOutput IN)  : COLOR
{
	float4 TB=tex2D(colorSampler,IN.uv);
   	float4 NB=tex2D(normalSampler,IN.uv)*2-1;
	 	float3 LV=IN.Light1;
	 		float GLB=saturate(dot(NB,LV));
	 			float4 TN=GLB*LC_5 ;
	 	LV=IN.Light2;
	 		GLB=saturate(dot(NB,LV));
	 			TN=TN+GLB*LC_6 ;
		float4 result= TB * TN ;
   	return result;
}
float4 PS_bumpmap_lights7(VSOutput IN)  : COLOR
{
	float4 TB=tex2D(colorSampler,IN.uv);
   	float4 NB=tex2D(normalSampler,IN.uv)*2-1;
	 	float3 LV=IN.Light1;
	 		float GLB=saturate(dot(NB,LV));
	 			float4 TN=GLB*LC_5 ;
	 	LV=IN.Light2;
	 		GLB=saturate(dot(NB,LV));
	 			TN=TN+GLB*LC_6 ;
	 	LV=IN.Light3;
	 		GLB=saturate(dot(NB,LV));
	 			TN=TN+GLB*LC_7 ;
		float4 result= TB * TN ;
   	return result;
}
float4 PS_bumpmap_lights8(VSOutput IN)  : COLOR
{
	float4 TB=tex2D(colorSampler,IN.uv);
   	float4 NB=tex2D(normalSampler,IN.uv)*2-1;
	 	float3 LV=IN.Light1;
	 		float GLB=saturate(dot(NB,LV));
	 			float4 TN=GLB*LC_5 ;
	 	LV=IN.Light2;
	 		GLB=saturate(dot(NB,LV));
	 			TN=TN+GLB*LC_6 ;
	 	LV=IN.Light3;
	 		GLB=saturate(dot(NB,LV));
	 			TN=TN+GLB*LC_7 ;
	 	LV=IN.Light4;
	 		GLB=saturate(dot(NB,LV));
	 			TN=TN+GLB*LC_8 ;
		float4 result= TB * TN ;
   	return result;
}
//********************************************************************************************
// technique 
	technique lighting1
 		{
			pass one
				{		
					VertexShader = compile vs_1_1 mainVS1(); // run VS v1.1
					PixelShader = compile ps_1_4 PS_bumpmap_lights1(); // run PS v1.4	 			
				}
			}
	technique lighting2
 		{
			pass one
				{		
					VertexShader = compile vs_1_1 mainVS1();
					PixelShader = compile ps_1_4 PS_bumpmap_lights2();				
				}
			}
	technique lighting3
 		{
			pass one
				{		
					VertexShader = compile vs_1_1 mainVS1();
					PixelShader = compile ps_1_4 PS_bumpmap_lights3();				
				}
			}
	technique lighting4 
 		{
			pass one
				{		
					VertexShader = compile vs_1_1 mainVS1();
					PixelShader = compile ps_1_4 PS_bumpmap_lights4();				
				}
			}
	technique lighting5 
 		{
			pass one
				{		
					VertexShader = compile vs_1_1 mainVS1();
					PixelShader = compile ps_1_4 PS_bumpmap_lights4();				
				}
			pass two  
				{		
					AlphaBlendEnable = True; 
					SrcBlend = One;
					DestBlend = One;
					VertexShader = compile vs_1_1 mainVS2();
					PixelShader = compile ps_1_4 PS_bumpmap_lights5();				
				}
			}
	technique lighting6 
 		{
			pass one
				{		
					VertexShader = compile vs_1_1 mainVS1();
					PixelShader = compile ps_1_4 PS_bumpmap_lights4();				
				}
			pass two
				{		
					AlphaBlendEnable = True;
					SrcBlend = One;
					DestBlend = One;
					VertexShader = compile vs_1_1 mainVS2();
					PixelShader = compile ps_1_4 PS_bumpmap_lights6();				
				}
			}
	technique lighting7 
 		{
			pass one
				{		
					VertexShader = compile vs_1_1 mainVS1();
					PixelShader = compile ps_1_4 PS_bumpmap_lights4();				
				}
			pass two
				{		
					AlphaBlendEnable = True;
					SrcBlend = One;
					DestBlend = One;
					VertexShader = compile vs_1_1 mainVS2();
					PixelShader = compile ps_1_4 PS_bumpmap_lights7();				
				}
			}
	technique lighting8 
 		{
			pass one
				{		
					VertexShader = compile vs_1_1 mainVS1();
					PixelShader = compile ps_1_4 PS_bumpmap_lights4();				
				}
			pass two
				{		
					AlphaBlendEnable = True;
					SrcBlend = One;
					DestBlend = One;
					VertexShader = compile vs_1_1 mainVS2();
					PixelShader = compile ps_1_4 PS_bumpmap_lights8();				
				}
			}
//********************************************************************************************