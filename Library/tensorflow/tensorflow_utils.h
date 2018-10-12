//
//  tensorflow_utils.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/18/18.
//  Copyright © 2018 Google. All rights reserved.
//

#ifndef HuntSmart_TENSORFLOW_UTILS_H_
#define HuntSmart_TENSORFLOW_UTILS_H_

#import <Foundation/Foundation.h>

#include <fstream>
#include <pthread.h>
#include <unistd.h>
#include <queue>
#include <sstream>
#include <string>
#include <memory>

#include "tensorflow/core/framework/op_kernel.h"
#include "tensorflow/core/public/session.h"
#include "tensorflow/core/util/memmapped_file_system.h"

#include "ios_image_load.h"


// If you have your own model, modify this to the file name, and make sure
// you've added the file to your app resources too.
static NSString* model_file_name = @"rounded_graph";
static NSString* model_file_type = @"pb";
// This controls whether we'll be loading a plain GraphDef proto, or a
// file created by the convert_graphdef_memmapped_format utility that wraps a
// GraphDef and parameter file that can be mapped into memory from file to
// reduce overall memory usage.
const bool model_uses_memory_mapping = false;
const float required_score = 0.55f;
// If you have your own model, point this to the labels file.
static NSString* labels_file_name = @"retrained_labels";
static NSString* labels_file_type = @"txt";
// These dimensions need to match those the model was trained with.
const int wanted_input_width = 224;
const int wanted_input_height = 224;
const int wanted_input_channels = 3;
const float input_mean = 128.0f;
const float input_std = 128.0f;
const std::string input_layer_name = "input";
const std::string output_layer_name = "final_result";

// Reads a serialized GraphDef protobuf file from the bundle, typically
// created with the freeze_graph script. Populates the session argument with a
// Session object that has the model loaded.
tensorflow::Status LoadModel(NSString* file_name, NSString* file_type,
                             std::unique_ptr<tensorflow::Session>* session);

// Loads a model from a file that has been created using the
// convert_graphdef_memmapped_format tool. This bundles together a GraphDef
// proto together with a file that can be memory-mapped, containing the weight
// parameters for the model. This is useful because it reduces the overall
// memory pressure, since the read-only parameter regions can be easily paged
// out and don't count toward memory limits on iOS.
tensorflow::Status LoadMemoryMappedModel(
                                         NSString* file_name, NSString* file_type,
                                         std::unique_ptr<tensorflow::Session>* session,
                                         std::unique_ptr<tensorflow::MemmappedEnv>* memmapped_env);

// Takes a text file with a single label on each line, and returns a list.
tensorflow::Status LoadLabels(NSString* file_name, NSString* file_type,
                              std::vector<std::string>* label_strings);

// Sorts the results from a model execution, and returns the highest scoring.
void GetTopN(const Eigen::TensorMap<Eigen::Tensor<float, 1, Eigen::RowMajor>,
             Eigen::Aligned>& prediction,
             const int num_results, const float threshold,
             std::vector<std::pair<float, int> >* top_results);

NSString* FilePathForResourceName(NSString* name, NSString* extension);

#endif  // HuntSmart_TENSORFLOW_UTILS_H_

