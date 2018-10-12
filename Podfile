# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

project './HuntSmart.xcodeproj'

target 'HuntSmart' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    # Pods for HuntSmart
    pod 'TensorFlow-experimental'
    
    pod 'AFNetworking'
    pod 'AFNetworking-Synchronous'
    
    pod 'DLFPhotosPicker', :git => 'https://github.com/venusdev85/DLFPhotosPicker'
    pod 'SDWebImage'
    pod 'SDWebImage/GIF'
    pod 'BFRImageViewer'
    
    pod 'Charts'
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                if target.name == 'Charts'
                    config.build_settings['SWIFT_VERSION'] = '4.2'
                    else
                    config.build_settings['SWIFT_VERSION'] = '4.1'
                end
            end
        end
    end
    
    pod 'MBProgressHUD'
    pod 'Toast'
    pod 'MKDropdownMenu'
    
    # social sharing
    pod 'FBSDKCoreKit'
    pod 'FBSDKLoginKit'
    pod 'FBSDKShareKit'
    
    pod 'TwitterKit'
    
    pod 'GoogleMaps'
    pod 'GooglePlaces'
end

target 'ImageImport' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    # Pods for ImageImport
    pod 'TensorFlow-experimental'
    
    pod 'MBProgressHUD'
    pod 'Toast'
end
