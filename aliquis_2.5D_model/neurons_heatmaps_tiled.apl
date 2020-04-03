# Required Aliquis (R) 2.2.3 or later
# Bioretics (R) and Aliquis (R) are registered trademarks of Bioretics srl - Italy.

name: "neurons_heatmaps_tiled"

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
  name: "red_channel"
  type: SELECT_CHANNELS
  input: "src"
  select_channels_param {
    ch: 1
    ch: 2
  }
}

stages {
  name: "pad_macro"
  type: PADDING
  input: "red_channel"
  padding_param {
    size_left: 0
    size_right: $win_side
    size_top: 0
    size_bottom: $win_side
    border_type: CONSTANT
    color { d:0 d:0 d:0 }
  }
}

stages {
  name: "slid_win"
  type: SLIDING_WINDOW
  input: "pad_macro"
  sliding_window_param {
    width: $win_side
    height: $win_side
    step_x: $win_side
    step_y: $win_side
  }
}

stages {
  name: "pad_micro"
  type: PADDING
  input: "slid_win"
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
  name: "heatmap"
  type: DEBUG_HEATMAP
  input: "cnn"
}

