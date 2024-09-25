/*layout(location=0) in vec2 TexCoord;
layout(location=0) out vec4 FragColor;

layout(binding=0) uniform sampler2D InputTexture;
layout(binding=1) uniform sampler2D PaletteLUT;*/

vec3 Tonemap(vec3 color)
{
	ivec3 c = ivec3(clamp(color.rgb, vec3(0.0), vec3(1.0)) * 63.0 + 0.5);
	int index = (c.r * 64 + c.g) * 64 + c.b;
	int tx = index % 512;
	int ty = index / 512;
	return texelFetch(LUT, ivec2(tx, ty), 0).rgb;
}

void main()
{
	vec3 color = texture(InputTexture, TexCoord).rgb;
	color = Tonemap(color);
	FragColor = vec4(color.x, color.y, color.z, 1.0);
}