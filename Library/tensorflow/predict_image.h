//
//  predict_image.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/13/18.
//  Copyright © 2018 Google. All rights reserved.
//

#include "tensorflow_utils.h"


@interface predict_image : NSObject {
    std::unique_ptr<tensorflow::Session> tf_session;
    std::unique_ptr<tensorflow::MemmappedEnv> tf_memmapped_env;
    std::vector<std::string> labels;
}

- (NSDictionary *)RunInferenceOnImage:(NSString *)imagePath;

@end

