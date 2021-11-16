# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Schingen' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  platform :ios, '14.0'
  inhibit_all_warnings!

pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'FBSDKLoginKit'
pod 'GoogleSignIn','5.0.2'
pod 'MessageKit'
pod 'JGProgressHUD'
pod 'RealmSwift'
pod 'SDWebImage'

end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    if config.name != 'Release'
      config.build_settings['VALID_ARCHS'] = 'arm64, arm64e, x86_64'
    end
  end
end
