struct VertexInput {
	@location(0) position: vec3f,
	@location(1) normal: vec3f,
	@location(2) uv: vec2f,
	@location(3) transformVec0: vec4f,
	@location(4) transformVec1: vec4f,
	@location(5) transformVec2: vec4f,
	@location(6) transformVec3: vec4f,
};

struct VertexOutput {
	@builtin(position) position: vec4f,
	@location(0) normal: vec3f,
	@location(1) uv: vec2f,
};

struct Uniforms {
    projectionMatrix: mat4x4f,
    viewMatrix: mat4x4f,
};

struct ModelUniform {
	modelMatrix: mat4x4f,
};

struct PrimitiveUniform {
	primitiveMatrix: mat4x4f,
	color: vec4f,
	has_texture: u32,
};

@group(0) @binding(0) var<uniform> uniforms: Uniforms;

@group(1) @binding(0) var<uniform> modelUniforms: ModelUniform;

@group(2) @binding(0) var<uniform> primitiveUniforms: PrimitiveUniform;
@group(2) @binding(1) var colorTexture: texture_2d<f32>;
@group(2) @binding(2) var colorSampler: sampler;

@vertex
fn vertex_main(in: VertexInput, @builtin(instance_index) instance_index: u32) -> VertexOutput {
	var out: VertexOutput;
	// x into, y up, z right
	var coordinate_system = mat4x4f(
		0.,  0., -1.,  0.,
		0.,  1.,  0.,  0.,
		1.,  0.,  0.,  0.,
		0.,  0.,  0.,  1.,
	);

	var instanceMatrix = mat4x4(in.transformVec0, in.transformVec1, in.transformVec2, in.transformVec3);

	out.position = uniforms.projectionMatrix * coordinate_system * uniforms.viewMatrix * instanceMatrix * modelUniforms.modelMatrix * vec4f(in.position, 1.);
	out.normal = in.normal;
	out.uv = in.uv;
	return out;
}

@fragment
fn fragment_main(in: VertexOutput) -> @location(0) vec4f {
	// let color = in.normal * 0.5 + 0.5;
	if (primitiveUniforms.has_texture == 0) {
		return vec4f(pow(primitiveUniforms.color.xyz, vec3f(2.2)), primitiveUniforms.color.a);
	}
	// let texcoord = vec2i(in.position.xy);
	// let texcoord = in.uv * vec2f(textureDimensions(colorTexture));
	let color = textureSample(colorTexture, colorSampler, in.uv).rgb;
	// let color = in.normal * uniforms.color.rgb;
	// Gamma-correction
	// let corrected_color = pow(color, vec3f(2.2));
	let corrected_color = color;
	return vec4f(corrected_color, primitiveUniforms.color.a);
}
