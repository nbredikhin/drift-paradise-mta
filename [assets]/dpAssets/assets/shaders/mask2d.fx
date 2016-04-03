#include "include/tex_matrix.fx"

texture sPicTexture;
texture sMaskTexture;

technique hello
{
    pass P0
    {
        // Set up texture stage 0
        Texture[0] = sPicTexture;
        AddressU[0] = Clamp;
        AddressV[0] = Clamp;
        // Color mix texture and diffuse
        ColorOp[0] = Modulate;
        ColorArg1[0] = Texture;
        ColorArg2[0] = Diffuse;
        // Alpha mix texture and diffuse
        AlphaOp[0] = Modulate;
        AlphaArg1[0] = Texture;
        AlphaArg2[0] = Diffuse;
     

        // Set up texture stage 1
        Texture[1] = sMaskTexture;
        TexCoordIndex[1] = 0;
        AddressU[1] = Clamp;
        AddressV[1] = Clamp;
        // Color pass through from stage 0
        ColorOp[1] = SelectArg1;
        ColorArg1[1] = Current;
        // Alpha modulate mask texture with stage 0
        AlphaOp[1] = Modulate;
        AlphaArg1[1] = Current;
        AlphaArg2[1] = Texture;


        // Disable texture stage 2
        ColorOp[2] = Disable;
        AlphaOp[2] = Disable;
    }
}
