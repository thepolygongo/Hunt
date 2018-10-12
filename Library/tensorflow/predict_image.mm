//
//  predict_image.mm
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/13/18.
//  Copyright © 2018 Google. All rights reserved.
//

#import "predict_image.h"


@interface predict_image ()
@end

@implementation predict_image {
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        tensorflow::Status load_status;
        if (model_uses_memory_mapping) {
            load_status = LoadMemoryMappedModel(model_file_name, model_file_type, &tf_session, &tf_memmapped_env);
        } else {
            load_status = LoadModel(model_file_name, model_file_type, &tf_session);
        }
        if (!load_status.ok()) {
            LOG(FATAL) << "Couldn't load model: " << load_status;
        }
        
        tensorflow::Status labels_status = LoadLabels(labels_file_name, labels_file_type, &labels);
        if (!labels_status.ok()) {
            LOG(FATAL) << "Couldn't load labels: " << labels_status;
        }
    }
    return self;
}

- (NSDictionary *)RunInferenceOnImage:(NSString *)imagePath {
    // Read the Grace Hopper image.
    int image_width;
    int image_height;
    int image_channels;
    std::vector<tensorflow::uint8> image_data = LoadImageFromFile(
                                                                  [imagePath UTF8String], &image_width, &image_height, &image_channels);
    
    assert(image_channels >= wanted_input_channels);
    tensorflow::Tensor image_tensor(
                                    tensorflow::DT_FLOAT,
                                    tensorflow::TensorShape({
        1, wanted_input_height, wanted_input_width, wanted_input_channels}));
    auto image_tensor_mapped = image_tensor.tensor<float, 4>();
    tensorflow::uint8* in = image_data.data();
    // tensorflow::uint8* in_end = (in + (image_height * image_width * image_channels));
    float* out = image_tensor_mapped.data();
    for (int y = 0; y < wanted_input_height; ++y) {
        const int in_y = (y * image_height) / wanted_input_height;
        tensorflow::uint8* in_row = in + (in_y * image_width * image_channels);
        float* out_row = out + (y * wanted_input_width * wanted_input_channels);
        for (int x = 0; x < wanted_input_width; ++x) {
            const int in_x = (x * image_width) / wanted_input_width;
            tensorflow::uint8* in_pixel = in_row + (in_x * image_channels);
            float* out_pixel = out_row + (x * wanted_input_channels);
            for (int c = 0; c < wanted_input_channels; ++c) {
                out_pixel[c] = (in_pixel[c] - input_mean) / input_std;
            }
        }
    }
    
    if (tf_session.get()) {
        std::vector<tensorflow::Tensor> outputs;
        tensorflow::Status run_status = tf_session->Run(
                                                        {{input_layer_name, image_tensor}}, {output_layer_name}, {}, &outputs);
        if (!run_status.ok()) {
            LOG(ERROR) << "Running model failed:" << run_status;
        } else {
            tensorflow::Tensor *output = &outputs[0];
            auto predictions = output->flat<float>();
            
            NSMutableDictionary *newValues = [NSMutableDictionary dictionary];
            for (int index = 0; index < predictions.size(); index += 1) {
                const float predictionValue = predictions(index);
                if (predictionValue > 0.05f) {
                    std::string label = labels[index % predictions.size()];
                    NSString *labelObject = [NSString stringWithUTF8String:label.c_str()];
                    NSNumber *valueObject = [NSNumber numberWithFloat:predictionValue];
                    [newValues setObject:valueObject forKey:labelObject];
                }
            }
            
            return newValues;
        }
    }
    
    return nil;
}

@end

