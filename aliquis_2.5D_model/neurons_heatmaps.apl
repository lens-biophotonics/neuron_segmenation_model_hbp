# Required Aliquis (R) 2.2.3 or later
# Bioretics (R) and Aliquis (R) are registered trademarks of Bioretics srl - Italy.

name: "neurons_heatmaps"

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
  name: "select_channels"
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
  input: "select_channels"
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

