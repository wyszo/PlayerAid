platform :ios, '8.0'

inhibit_all_warnings! # suppress all warnings from pods
use_frameworks!

pod 'AFNetworking', '2.5.0' # 3.0.0 in beta 2 available, 2.6.3 stable
pod 'Facebook-iOS-SDK', '3.24.1' # 4.1.0 available
pod 'MagicalRecord', '2.3.0'
pod 'KZAsserts', '1.0'
pod 'KZPropertyMapper', '2.5.1'
pod 'UIAlertView-Blocks', '1.0'
pod 'UITextView+Placeholder', '1.1.0'
pod 'FLKAutoLayout', '0.2.1'
pod 'Mixpanel', '2.9.0'
pod 'BlocksKit', '2.2.5'
pod 'DateTools', '1.7.0'
pod 'NSString+RemoveEmoji', '0.0.1'
pod 'Fabric', '1.6.1'
pod 'Crashlytics', '3.4.1'
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