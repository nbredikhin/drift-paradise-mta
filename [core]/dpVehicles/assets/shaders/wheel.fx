//
// Example shader - ped_morph.fx
//


//---------------------------------------------------------------------
// Ped morph settings
//---------------------------------------------------------------------
float3 sMorphSize = float3(0,0,0);
float sRazval = 10;
float sWidth = 0.2;
float sRotationX = 0;
float sRotationZ = 0;
float3 sAxis = float3(0, 0, 0);
float4 sColor = float4(1, 1, 1, 1);

texture sReflectionTexture;

float gFilmDepth = 0;
float gFilmIntensity = 0.25;
bool gFilmDepthEnable = false;


//---------------------------------------------------------------------
// Include some common stuff
//---------------------------------------------------------------------
#include "mta-helper.fx"

sampler Sampler0 = sampler_state
{
    Texture         = (gTexture0);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
};

samplerCUBE ReflectionSampler = sampler_state
{
   Texture = (sReflectionTexture);
   MAGFILTER = LINEAR;
   MINFILTER = LINEAR;
   MIPFILTER = LINEAR;
   MIPMAPLODBIAS = 0.000000;
};


//---------------------------------------------------------------------
// Structure of data sent to the vertex shader
//---------------------------------------------------------------------
struct VSInput
{
    float3 Position : POSITION0;
    float3 Normal : NORMAL0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

//---------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//---------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
    float3 Tangent : TEXCOORD1;
    float3 Binormal : TEXCOORD2;
    float3 Normal : TEXCOORD3;
    float3 NormalSurf : TEXCOORD4;
    float3 View : TEXCOORD5;
    float4 BottomColor : TEXCOORD6;
    float3 SparkleTex : TEXCOORD7;
    float4 Diffuse2 : COLOR1;
};


//////////////////////////////////////////////////////////////////////////
// Function to Index this texture - use in vertex or pixel shaders ///////
//////////////////////////////////////////////////////////////////////////

float calc_view_depth(float NDotV,float Thickness)
{
    return (Thickness / NDotV);
}


float4 quat_from_axis_angle(float3 axis, float angle)
{ 
  float4 qr;
  float half_angle = (angle * 0.5) * 3.14159 / 180.0;
  qr.x = axis.x * sin(half_angle);
  qr.y = axis.y * sin(half_angle);
  qr.z = axis.z * sin(half_angle);
  qr.w = cos(half_angle);
  return qr;
}
 
float4 quat_conj(float4 q)
{ 
  return float4(-q.x, -q.y, -q.z, q.w); 
}
  
float4 quat_mult(float4 q1, float4 q2)
{ 
  float4 qr;
  qr.x = (q1.w * q2.x) + (q1.x * q2.w) + (q1.y * q2.z) - (q1.z * q2.y);
  qr.y = (q1.w * q2.y) - (q1.x * q2.z) + (q1.y * q2.w) + (q1.z * q2.x);
  qr.z = (q1.w * q2.z) + (q1.x * q2.y) - (q1.y * q2.x) + (q1.z * q2.w);
  qr.w = (q1.w * q2.w) - (q1.x * q2.x) - (q1.y * q2.y) - (q1.z * q2.z);
  return qr;
}
 
float3 rotate_vertex_position(float3 position, float3 axis, float angle)
{ 
  float4 qr = quat_from_axis_angle(axis, angle);
  float4 qr_conj = quat_conj(qr);
  float4 q_pos = float4(position.x, position.y, position.z, 0);
  
  float4 q_tmp = quat_mult(qr, q_pos);
  qr = quat_mult(q_tmp, qr_conj);
  
  return float3(qr.x, qr.y, qr.z);
}

//------------------------------------------------------------------------------------------
// VertexShaderFunction
//  1. Read from VS structure
//  2. Process
//  3. Write to PS structure
//------------------------------------------------------------------------------------------

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;    

    PS.Position = mul(float4(VS.Position, 1), gWorldViewProjection);

    VS.Position *= float3(1 + sWidth, 1, 1);

    VS.Position = rotate_vertex_position(VS.Position, float3(1, 0, 0), float3(sRotationX, 0, 0));
    VS.Position = rotate_vertex_position(VS.Position, float3(0, 1, 0), float3(sRazval, 0, 0));
    VS.Position = rotate_vertex_position(VS.Position, float3(0, 0, 1), float3(sRotationZ, 0, 0));
    // Рассчитать позицию вершины на экране
    PS.Position = MTACalcScreenPosition(VS.Position);

    // Передать tex coords
    PS.TexCoord = VS.TexCoord;

    VS.Normal = rotate_vertex_position(VS.Normal, float3(1, 0, 0), float3(sRotationX, 0, 0));
    VS.Normal = rotate_vertex_position(VS.Normal, float3(0, 1, 0), float3(sRazval, 0, 0));
    VS.Normal = rotate_vertex_position(VS.Normal, float3(0, 0, 1), float3(sRotationZ, 0, 0));
    float3 worldNormal = mul(VS.Normal, (float3x3)gWorld);

    // ------------------------------- PAINT ----------------------------------------

    float3 worldPosition = MTACalcWorldPosition( VS.Position );
    PS.View = normalize(gCameraPosition - worldPosition);
  
    // Fake tangent and binormal
    float3 Tangent = VS.Normal.yxz;
    Tangent.xz = VS.TexCoord.xy;
    float3 Binormal = normalize( cross(Tangent, VS.Normal) );
    Tangent = normalize( cross(Binormal, VS.Normal) );
  
    // Transfer some stuff
    PS.TexCoord = VS.TexCoord;
    PS.Tangent = normalize(mul(Tangent, gWorldInverseTranspose).xyz);
    PS.Binormal = normalize(mul(Binormal, gWorldInverseTranspose).xyz);
    PS.Normal = normalize( mul(VS.Normal, (float3x3)gWorld) );
    PS.NormalSurf = VS.Normal;

    PS.SparkleTex.x = fmod( VS.Position.x, 10 ) * 4.0;
    PS.SparkleTex.y = fmod( VS.Position.y, 10 ) * 4.0;
    PS.SparkleTex.z = fmod( VS.Position.z, 10 ) * 4.0;

    PS.Diffuse = MTACalcGTABuildingDiffuse(VS.Diffuse) + float4(0.2, 0.2, 0.2, 0);
    return PS;
}

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float4 OutColor = 1;

    float4 paintColor = sColor;
    float4 maptex = tex2D(Sampler0,PS.TexCoord.xy);
    float4 delta = maptex - float4(0, 0, 0, 1);
    if (dot(delta,delta) < 0.2) {
        float4 Color = maptex * PS.Diffuse * 1;
        Color.a = PS.Diffuse.a;
        return Color;
    }    
    // Some settings for something or another
    float microflakePerturbation = 1.00;
    float normalPerturbation = 1.00;
    float microflakePerturbationA = 0.10;

    // Compute paint colors
    float4 base = gMaterialAmbient;

    // Get the surface normal
    float3 vNormal = PS.Normal;

    // Micro-flakes normal map is a high frequency normalized
    // vector noise map which is repeated across the surface.
    // Fetching the value from it for each pixel allows us to
    // compute perturbed normal for the surface to simulate
    // appearance of micro-flakes suspended in the coat of paint:

    // This shader simulates two layers of micro-flakes suspended in
    // the coat of paint. To compute the surface normal for the first layer,
    // the following formula is used:
    // Np1 = ( a * Np + b * N ) / || a * Np + b * N || where a << b
    //
    float3 vNp1 = normalPerturbation * vNormal ;

    // To compute the surface normal for the second layer of micro-flakes, which
    // is shifted with respect to the first layer of micro-flakes, we use this formula:
    // Np2 = ( c * Np + d * N ) / || c * Np + d * N || where c == d
    float3 vNp2 = vNormal;

    // The view vector (which is currently in world space) needs to be normalized.
    // This vector is normalized in the pixel shader to ensure higher precision of
    // the resulting view vector. For this highly detailed visual effect normalizing
    // the view vector in the vertex shader and simply interpolating it is insufficient
    // and produces artifacts.
    float3 vView = normalize( PS.View );
  
    // Transform the surface normal into world space (in order to compute reflection
    // vector to perform environment map look-up):
    float3x3 mTangentToWorld = transpose( float3x3( PS.Tangent, PS.Binormal, PS.Normal ) );
    float3 vNormalWorld = normalize( mul( mTangentToWorld, vNormal ));

    // Compute reflection vector resulted from the clear coat of paint on the metallic
    // surface:
    float fNdotV = saturate(dot( vNormalWorld, vView));
    
    // Count reflection vector
    float3 vReflection = reflect(PS.View,PS.Normal);
    
    // Hack in some bumpyness
    vReflection.x+= vNp2.x * 0.1;
    vReflection.y+= vNp2.y * 0.1;
    // Sample environment map using this reflection vector:
    float4 envMap = texCUBE( ReflectionSampler, -vReflection.xzy );
    // Premultiply by alpha:

    envMap.rgb = envMap.rgb * envMap.rgb * envMap.rgb;
    // Brighten the environment map sampling result:
    envMap.rgb *= 0.8;
    envMap.rgb += PS.BottomColor.rgb;
    // Sample dust texture:

    // Combine result of environment map reflection with the paint color:
    float fEnvContribution = 1.0 - 0.5 * fNdotV;

    float4 finalColor = envMap * fEnvContribution + base * 0.1;
    finalColor.rgb += PS.Diffuse2.rgb  * 0.75;
    finalColor.a = 1.0;
    // Bodge in the car colors
    float4 Color = 0.15 + finalColor / 1 * 0.33 + PS.Diffuse * 0.9;
    //Color.rgb += finalColor * PS.Diffuse;

    Color *= maptex * paintColor; 
    Color.a = PS.Diffuse.a;
    return Color;
}


//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique tec0
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}

// Fallback
technique fallback
{
    pass P0
    {
        // Just draw normally
    }
}
