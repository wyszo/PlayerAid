platform :ios, '8.0'

inhibit_all_warnings! # suppress all warnings from pods
use_frameworks!

pod 'AFNetworking', '2.5.0' # 3.0.4 available
pod 'FBSDKCoreKit', '4.10.0'
pod 'FBSDKLoginKit', '4.10.0'
pod 'MagicalRecord', '2.3.2'
pod 'KZAsserts', '1.0'
pod 'KZPropertyMapper', '2.6'
pod 'UIAlertView-Blocks', '1.0'
pod 'UITextView+Placeholder', '1.1.1'
pod 'FLKAutoLayout', '0.2.1'
pod 'Mixpanel', '2.9.0'
pod 'BlocksKit', '2.2.5'
pod 'DateTools', '1.7.0'
pod 'NSString+RemoveEmoji', '0.1.1'
pod 'Fabric', '1.6.6'
pod 'Crashlytics', '3.7.0'
pod 'TTTAttributedLabel', '1.13.4'

pod 'XRSA', :git => 'https://github.com/wyszo/XRSA.git', :branch => 'master'
pod 'FDTake', :path => '../FDTake', :branch => 'feature/AssetsHelper'
pod 'YCameraView', :git => 'https://github.com/wyszo/YCameraView.git', :branch => 'MorePAChanges'

pod 'TWCommonLib', :path => '../TWCommonLib'


# post-install configuration hooks
post_install do |installer|
  installer.pods_project.build_configuration_list.build_configurations.each do |configuration|
    configuration.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
  end
end