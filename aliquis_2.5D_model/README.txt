# Save index masks
aliquispl_run -E tiff -o res_indexmasks neurons_indexmasks.apl imgs_folder=imgs_small model_name=neuron_32x32x2_3c_nopool_2f_3o_20190530 hm=1 hms=4 classes=1,2 cl_thresh=0.7 area_min=9 area_max=1000000

# Save index masks in tiled mode
aliquispl_run -E tiff -o res_indexmasks_tiled neurons_indexmasks_tiled.apl imgs_folder=imgs_big win_side=512 model_name=neuron_32x32x2_3c_nopool_2f_3o_20190530 hm=1 hms=4 classes=1,2 cl_thresh=0.7 area_min=9 area_max=1000000

# Save heatmaps
aliquispl_run -E tiff -o res_heatmaps neurons_heatmaps.apl imgs_folder=imgs_small model_name=neuron_32x32x2_3c_nopool_2f_3o_20190530 hm=1 hms=4

# Save shapes
aliquispl_run -E tiff -s -d -H -o res_shapes neurons_shapes.apl imgs_folder=imgs_small model_name=neuron_32x32x2_3c_nopool_2f_3o_20190530 hm=1 hms=4 classes=1,2 cl_thresh=0.7 area_min=9 area_max=1000000

# Save shapes in tiled mode
aliquispl_run -E tiff -s -d -H -o res_shapes_tiled neurons_shapes_tiled.apl imgs_folder=imgs_big win_side=512 model_name=neuron_32x32x2_3c_nopool_2f_3o_20190530 hm=1 hms=4 classes=1,2 cl_thresh=0.7 area_min=9 area_max=1000000

# Save ximages
aliquispl_run -E tiff -s -x -o res_ximages neurons_shapes.apl imgs_folder=imgs_small model_name=neuron_32x32x2_3c_nopool_2f_3o_20190530 hm=1 hms=4 classes=1,2 cl_thresh=0.7 area_min=9 area_max=1000000

# Save ximages in tiled mode
aliquispl_run -E tiff -s -x -o res_ximages_tiled neurons_shapes_tiled.apl imgs_folder=imgs_big win_side=512 model_name=neuron_32x32x2_3c_nopool_2f_3o_20190530 hm=1 hms=4 classes=1,2 cl_thresh=0.7 area_min=9 area_max=1000000

