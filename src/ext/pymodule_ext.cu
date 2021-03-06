// Implementation file for the python extensions

#include "include/ext/pymodule_ext.h"

void pymodule_naive_tsne(float *points, float *result, ssize_t *dims, int proj_dim, float perplexity, float early_ex, 
                            float learning_rate, int n_iter,  int n_iter_np, float min_g_norm) {
    
    // Extract the dimensions of the points array
    ssize_t N_POINTS = dims[0];
    ssize_t N_DIMS = dims[1];

    // Construct device arrays
    thrust::device_vector<float> d_points(N_POINTS*N_DIMS);

    // Copy the points to the GPU using thrust
    thrust::copy(points, points+N_DIMS*N_POINTS, d_points.begin());

    // Construct the sigmas
    thrust::device_vector<float> sigmas(N_POINTS, 1.0f);

    // Create the CUBLAS handle
    cublasHandle_t handle;
    CublasSafeCall(cublasCreate(&handle));

    // Do the T-SNE
    auto tsne_result = NaiveTSNE::tsne(handle, d_points, N_POINTS, N_DIMS, proj_dim, perplexity, 
                                            early_ex, learning_rate, n_iter, n_iter_np, min_g_norm);

    // Copy the data back to the CPU
    thrust::copy(tsne_result.begin(), tsne_result.end(), result);
}

void pymodule_bh_tsne(float *result,
                      float* points,
                      ssize_t *dims,
                      float perplexity, 
                      float learning_rate, 
                      float magnitude_factor,
                      int num_neighbors,
                      int iterations,
                      int iterations_no_progress,
                      int force_magnify_iters,
                      float perplexity_search_epsilon,
                      float pre_exaggeration_momentum,
                      float post_exaggeration_momentum,
                      float theta,
                      float epssq,
                      float min_gradient_norm,
                      float *grad_norm,
                      int initialization_type,
                      float* preinit_data,
                      bool dump_points,
                      char* dump_file,
                      int dump_interval,
                      bool use_interactive,
                      char* viz_server,
                      int viz_timeout,
                      int verbosity,
                      int print_interval,
                      int gpu_device,
                      int return_style,
                      int num_snapshots
                      
                    ) {

    // Extract the dimensions of the points array
    ssize_t num_points = dims[0];
    ssize_t num_dims = dims[1];

    // Construct the GPU options
    tsnecuda::GpuOptions gpu_opt(gpu_device);

    // Construct the options
    tsnecuda::Options opt(result, points, num_points, num_dims,grad_norm);

    // Setup one-off options
    opt.perplexity = perplexity;
    opt.learning_rate = learning_rate;
    opt.magnitude_factor = magnitude_factor;
    opt.num_neighbors = num_neighbors;
    opt.iterations = iterations;
    opt.iterations_no_progress = iterations_no_progress;
    opt.force_magnify_iters = force_magnify_iters;
    opt.perplexity_search_epsilon = perplexity_search_epsilon;
    opt.pre_exaggeration_momentum = pre_exaggeration_momentum;
    opt.post_exaggeration_momentum = post_exaggeration_momentum;
    opt.theta = theta;
    opt.epssq = epssq;
    opt.min_gradient_norm = min_gradient_norm;
    opt.grad_norm = grad_norm;
    opt.verbosity = verbosity;
    opt.print_interval = print_interval;
    
    // Initialization
    switch (initialization_type) {
        case 0:
            opt.initialization = tsnecuda::TSNE_INIT::UNIFORM;
            break;
        case 1:
            opt.initialization = tsnecuda::TSNE_INIT::GAUSSIAN;
            break;
        case 2:
            //opt.initialization = tsnecuda::TSNE_INIT::RESUME;
            std::cerr << "E: RESUME initialization not yet supported fully..." << std::endl;
            exit(1);
        case 3:
            opt.initialization = tsnecuda::TSNE_INIT::VECTOR;
            opt.preinit_data = preinit_data;
            break;
        default:
            std::cerr << "E: Invalid initialization supplied" << std::endl;
            exit(1);
    }

    // Point dumping
    if (dump_points) {
        opt.enable_dump(std::string(dump_file), dump_interval);
    }

    // Enable Interactive Visualization
    if (use_interactive) {
        opt.enable_viz(std::string(viz_server), viz_timeout);
    }
    
    // Return data setup
    switch(return_style) {
        case 0:
            opt.return_style = tsnecuda::RETURN_STYLE::ONCE;
            break;
        case 1:
            opt.return_style = tsnecuda::RETURN_STYLE::SNAPSHOT;
            opt.num_snapshots = num_snapshots;
            break;
        default:
            std::cerr << "E: Invalid return style supplied" << std::endl;
            exit(1);
    }

    // Do the t-SNE
    tsnecuda::bh::RunTsne(opt, gpu_opt);

    // Copy the data back from the GPU
    cudaDeviceSynchronize();

