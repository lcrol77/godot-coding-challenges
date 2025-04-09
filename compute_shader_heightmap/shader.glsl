#[compute]
#version 460

// Instruct the GPU to use 8x8x1 = 64 local invocations per workgroup.
layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

// Prepare memory for the image, which will be both read and written to
// `restrict` is used to tell the compiler that the memory will only be accessed
// by the `heightmap` variable.
layout(r8, binding = 0) restrict uniform image2D heightmap;
// `readonly` is used to tell the compiler that we will not write to this memory.
// This allows the compiler to make some optimizations it couldn't otherwise.
layout(rgba8, binding = 1) restrict readonly uniform image2D gradient;

// This function is the GPU counterpart of `compute_island_cpu()` in `main.gd`.
void main() {
    // Grab the current pixel's position from the ID of this specific invocation ("thread").
    ivec2 coords = ivec2(gl_GlobalInvocationID.xy);
    ivec2 dimensions = imageSize(heightmap);
    // Calculate the center of the image.
    // Because we are working with integers ('round numbers') here,
    // the result will be floored to an integer.
    ivec2 center = dimensions / 2;
    // Calculate the smallest distance from center to edge.
    int smallest_radius = min(center.x, center.y);
    // Calculate the distance from the center of the image to the current pixel.
    float dist = distance(coords, center);
    // Retrieve the range of the gradient image.
    int gradient_max_x = imageSize(gradient).x - 1;
    // Calculate the gradient index based on the dist
    // `mix()` functions similarly to `lerp()` in GDScript.
    int gradient_x = int(mix(0.0, float(gradient_max_x), dist / float(smallest_radius)));
    // Retrieve the gradient value at the calculated position.
    ivec2 gradient_pos = ivec2(gradient_x, 0);
    vec4 gradient_color = imageLoad(gradient, gradient_pos);
    // Even though the image format only has the red channel,
    // this will still return a vec4: `vec4(red, 0.0, 0.0, 1.0)`
    vec4 pixel = imageLoad(heightmap, coords);
    pixel.r *= gradient_color.r;
    pixel.r = step(0.2,pixel.r) *pixel.r;
    imageStore(heightmap, coords, pixel);
}