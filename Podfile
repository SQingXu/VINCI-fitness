# Uncomment this line to define a global platform for your project
#platform :ios, '10.0'

target 'VINCIFitness' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for VINCIFitness
pod “FBSDKCoreKit”;
pod “FBSDKLoginKit”; 
pod “FBSDKShareKit”;
pod ‘ImageLoader’;
pod 'GoogleMaps';
pod 'GooglePlaces';
pod 'GooglePlacePicker';
pod “SwiftyJSON”, '3.0.0';
pod 'GoogleAPIClient/Drive', '~> 1.0.2';
pod 'GTMOAuth2', '~> 1.1.0';

pod 'Alamofire',
:git => 'https://github.com/Alamofire/Alamofire.git',
:branch => 'master';

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
    end
end
