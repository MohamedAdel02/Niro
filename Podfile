source 'https://github.com/CocoaPods/Specs.git'
# platform :ios, '9.0'

target 'Niro' do
  use_frameworks!

pod 'Alamofire'
pod 'SnapKit', '~> 5.0.0'
pod 'FirebaseAuth'
pod 'FirebaseFirestore'
pod 'Cosmos'

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end

end
