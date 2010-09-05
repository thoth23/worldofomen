  //--------------------------------
  // Bloom
  //--------------------------------
  // By Evolved
  // http://www.vector3r.com/
  //--------------------------------

  //-----------------
  // un-tweaks
  //-----------------
   matrix WorldVP:WorldViewProjection; 

  //-----------------
  // tweaks
  //-----------------
   float blurWidth = 0.015f;
   float Brightness = 0.20f;

  //-----------------
  // Texture
  //-----------------
   texture screenTX 
      <
      	string Name = " ";
      >;
   sampler2D screen=sampler_state 
      {
	Texture=<screenTX>;
     	ADDRESSU=CLAMP;
        ADDRESSV=CLAMP;
        ADDRESSW=CLAMP;
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
	float4 opos:POSITION;
  	float2 Texa:TEXCOORD0;
  	float2 Texb:TEXCOORD1;
  	float2 Texc:TEXCOORD2;
  	float2 Texd:TEXCOORD3;
      };
   struct outputT
     {
 	float4 opos:POSITION;  
 	float2 Tex:TEXCOORD0;  
     };

  //-----------------
  // vertex shader
  //-----------------
   output VSblurXA(input IN)
      {
   	output OUT;
    	OUT.opos  = mul(IN.pos,WorldVP);
    	OUT.Texa = IN.UV+blurWidth*(1*float2(0.5,0));
    	OUT.Texb = IN.UV+blurWidth*(1*float2(1.0,0)); 
    	OUT.Texc = IN.UV+blurWidth*(1*float2(1.5,0));
    	OUT.Texd = IN.UV+blurWidth*(1*float2(2.0,0));
   	return OUT;
      }
   output VSblurXB(input IN)
      {
   	output OUT;
    	OUT.opos  = mul(IN.pos,WorldVP);
    	OUT.Texa = IN.UV+blurWidth*(1*float2(-0.5,0));
    	OUT.Texb = IN.UV+blurWidth*(1*float2(-1.0,0)); 
    	OUT.Texc = IN.UV+blurWidth*(1*float2(-1.5,0));
    	OUT.Texd = IN.UV+blurWidth*(1*float2(-2.0,0));
   	return OUT;
      }
   output VSblurYA(input IN)
      {
   	output OUT;
    	OUT.opos  = mul(IN.pos,WorldVP);
    	OUT.Texa = IN.UV+blurWidth*(1*float2(0,0.5));
    	OUT.Texb = IN.UV+blurWidth*(1*float2(0,1.0)); 
    	OUT.Texc = IN.UV+blurWidth*(1*float2(0,1.5));
    	OUT.Texd = IN.UV+blurWidth*(1*float2(0,2.0));
   	return OUT;
      }
   output VSblurYB(input IN)
      {
   	output OUT;
    	OUT.opos  = mul(IN.pos,WorldVP);
    	OUT.Texa = IN.UV+blurWidth*(1*float2(0,-0.5));
    	OUT.Texb = IN.UV+blurWidth*(1*float2(0,-1.0)); 
    	OUT.Texc = IN.UV+blurWidth*(1*float2(0,-1.5));
    	OUT.Texd = IN.UV+blurWidth*(1*float2(0,-2.0));
   	return OUT;
      }
   outputT VSTone(input IN) 
     {
 	outputT OUT;
 	OUT.opos=mul(IN.pos,WorldVP);
 	OUT.Tex=IN.UV; 
 	return OUT;
    }

  //-----------------
  // pixel shader
  //-----------------
   float4 PS(output IN) : COLOR
      {
   	float4 tex=tex2D(screen, IN.Texa);
   	tex=tex+tex2D(screen,IN.Texb);
   	tex=tex+tex2D(screen,IN.Texc)/2;
   	tex=tex+tex2D(screen,IN.Texd)/2;	
  	return (tex*Brightness);
      } 
   float4 PSTone(outputT IN)  : COLOR
     {
 	float4 color=tex2D(screen,IN.Tex);
	color=pow(color,4);
	return color;	
     }  

  //-----------------
  // techniques   
  //-----------------
    technique Tone
      {
  	pass p1
      {		
  	vertexShader = compile vs_1_1 VSTone(); 
  	pixelShader  = compile ps_2_0 PSTone(); 	
      }
      }
    technique blurpassX
      {
	pass p1
      {
   	VertexShader = compile vs_1_1 VSblurXA();
   	PixelShader  = compile ps_1_1 PS();
    	SrcBlend = One;
    	DestBlend = One;
      }
  	pass p2
      {
   	VertexShader = compile vs_1_1 VSblurXB();
   	PixelShader  = compile ps_1_1 PS();
    	SrcBlend = One;
    	DestBlend = One;
 	AlphaBlendEnable = True;
      }
      }
    technique blurpassY
      {
	pass p1
      {
   	VertexShader = compile vs_1_1 VSblurYA();
   	PixelShader  = compile ps_1_1 PS();
    	SrcBlend = One;
    	DestBlend = One;
      }
  	pass p2
      {
   	VertexShader = compile vs_1_1 VSblurYB();
   	PixelShader  = compile ps_1_1 PS();
    	SrcBlend = One;
    	DestBlend = One;
 	AlphaBlendEnable = True;
      }
      }