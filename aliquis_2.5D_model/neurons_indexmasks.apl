# Required Aliquis (R) 2.2.3 or later
# Bioretics (R) and Aliquis (R) are registered trademarks of Bioretics srl - Italy.

name: "neurons_indexmasks"

color_map: { d: 0,   d:   0, d:   0 }  # Class 0
color_map: { d: 0,   d: 255, d: 255 }  # Class 1
color_map: { d: 255, d: 255, d:   0 }  # Class 2

stages {
  name: "src"
  type: SOURCE_IMAGE
  source_param {
    path: "$imgs_folder/*"
    load_multipage: true
    ximage_meta: DISCARD
    
    }
}

stages {
  name: "select_channel"
  type: SELECT_CHANNELS
  input: "src"
  select_channels_param {
    ch: 1
    ch: 2
  }
}

stages {
  name: "pad_micro"
  type: PADDING
  input: "select_channel"
  padding_param {
    size_left: 16
    size_right: 16
    size_top: 16
    size_bottom: 16
    border_type: CONSTANT
    color { d:0 d:0 d:0 }
  }
}


stages {
  name: "cnn"
  type: NEURAL_NETWORK
  input: "pad_micro"
  neural_network_param {
    model: "models/$model_name/net.caffemodel"
    deploy: "models/$model_name/deploy.prototxt"
    fully_deploy: "models/$model_name/deploy_fully.prototxt"
    fully_subst_layers: "fc4 => fc4-conv, fc5 => fc5-conv, fc6 => fc6-conv"
    fully_cluster: false
    scale: 0.003921568627
    heatmap: true
    gpu: true
    heatmap_multiplier: $hm
    heatmap_multiplier_stride: $hms
    gpu_id: 0
  }
}

stages {
  name: "pad_hm"
  type: PADDING
  input: "cnn"
  padding_param {
    size_left: 1
    size_right: 1
    size_top: 1
    size_bottom: 1
    color { d:0 d:0 d:0 }
    border_type: CONSTANT
  }
}

stages {
  name: "cont_find"
  type: CONTOURS_FINDER
  input: "pad_hm"
  contours_finder_param {
    threshold: 0.5
    value_type: RANKING
    num: 3
  }
}

stages {
  name: "neurons_shapes"
  type: CLASS_FILTER
  input: "cont_find"
  class_filter_param {
    class_include: "$classes"
    default_policy: CLASS_REJECT
    value_threshold: $cl_thresh
  }
}

stages {
  name: "shapes_on_root"
  type: SHAPES_ON_ROOT
  input: "neurons_shapes"
}

stages {
  name: "area_threshold"
  type: SHAPES_FILTER
  input: "shapes_on_root"
  shapes_filter_param {
    area_threshold_min: $area_min
    area_threshold_max: $area_max
  }
}

stages {
  name: "index_mask"
  type: INDEX_MASK
  input: "area_threshold"
}

