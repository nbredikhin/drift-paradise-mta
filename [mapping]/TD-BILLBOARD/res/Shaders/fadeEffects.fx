texture texture1;
texture texture2;

float effectProgress = 30;
float2 centerPoint = float2(0.5, 0.5);
float numberOfBlinds = 8;

int effectID = 1;


sampler Texture1Sampler = sampler_state {
    Texture = (texture1);
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
};


sampler Texture2Sampler = sampler_state {
    Texture = (texture2);
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
};


float distanceFromCenterToSquareEdge(float2 dir) {	
	dir = abs(dir);
	float dist = dir.x > dir.y ? dir.x : dir.y;
	
	return dist;
}


float4 doCircleStretch(float2 textureCoords, float progress) {
	
	float2 center = centerPoint;
	float radius = progress * 0.70710678;
	float2 toUV = textureCoords - center;
	float len = length(toUV);
	float2 normToUV = toUV / len;

	if (len < radius) {
		float distFromCenterToEdge = distanceFromCenterToSquareEdge(normToUV) / 2.0;
		float2 edgePoint = center + distFromCenterToEdge * normToUV;

		float minRadius = min(radius, distFromCenterToEdge);
		float percentFromCenterToRadius = len / minRadius;

		float2 newUV = lerp(center, edgePoint, percentFromCenterToRadius);
		
		return tex2D(Texture1Sampler, newUV);
	} else {
		float distFromCenterToEdge = distanceFromCenterToSquareEdge(normToUV);
		float2 edgePoint = center + distFromCenterToEdge * normToUV;
		float distFromRadiusToEdge = distFromCenterToEdge - radius;

		float2 radiusPoint = center + radius * normToUV;
		float2 radiusToUV = textureCoords - radiusPoint;

		float percentFromRadiusToEdge = length(radiusToUV) / distFromRadiusToEdge;

		float2 newUV = lerp(center, edgePoint, percentFromRadiusToEdge);
		
		return tex2D(Texture2Sampler, newUV);
	}
}


float4 doRippleEffect(float2 textureCoords, float progress) {
	
	float frequency = 20;
	float speed = 10;
	float amplitude = 0.05;
	float2 center = float2(0.5, 0.5);
	float2 toUV = textureCoords - center;
	float distanceFromCenter = length(toUV);
	float2 normToUV = toUV / distanceFromCenter;

	float wave = cos(frequency * distanceFromCenter - speed * progress);
	float offset1 = progress * wave * amplitude;
	float offset2 = (1.0 - progress) * wave * amplitude;

	float2 newUV1 = center + normToUV * (distanceFromCenter + offset1);
	float2 newUV2 = center + normToUV * (distanceFromCenter + offset2);

	float4 c1 = tex2D(Texture1Sampler, newUV1);
	float4 c2 = tex2D(Texture2Sampler, newUV2);

	return lerp(c1, c2, progress);
}


float4 doBlinds(float2 textureCoords, float progress) {
	
	if (frac(textureCoords.y * numberOfBlinds) < progress/100) {
		return tex2D(Texture1Sampler, textureCoords);
	} else {
		return tex2D(Texture2Sampler, textureCoords);
	}
}


float4 doSingleBlind(float2 textureCoords, float progress) {
	
	textureCoords.y -= progress;

	if (textureCoords.y > 0.0) {
		return tex2D(Texture2Sampler, textureCoords);
	} else {
		return tex2D(Texture1Sampler, frac(textureCoords));
	}
}


struct PixelShaderInput {
	float4 Color				: COLOR;
	float4 Position 			: POSITION;
	float2 textureCoords		: TEXCOORD;
};

float4 MyPixelShader(PixelShaderInput input) : COLOR {
	
	float4 fadeColor;
	
	if (effectID == 1) {
		fadeColor = doRippleEffect(input.textureCoords, effectProgress/100);
	} else if (effectID == 2) {
		fadeColor = doCircleStretch(input.textureCoords, 1 - effectProgress/100);
	} else if (effectID == 3) {	
		fadeColor = doBlinds(input.textureCoords, 100 - effectProgress);
	}
	
	fadeColor.rgb *= 0.5;
	
	return fadeColor;
}


//-----------------------------------------------------------------------------
//-- Techniques
//-----------------------------------------------------------------------------
technique Ripple {
    pass p0 {
		PixelShader = compile ps_2_0 MyPixelShader();
    }
}
 
// Fallback
technique fallback {
    pass P0 {
        // Just draw normally
    }
}