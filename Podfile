# Uncomment this line to define a global platform for your project
platform :ios, ‘9.0’

target 'CreativeCalendar' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for JTAppleCalendar
  pod 'JTAppleCalendar' #, :git => 'https://github.com/patchthecode/JTAppleCalendar.git'
  
  # Pod for Chameleon
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
  
  # Pods for Locksmith Keychain wrapper
  pod 'Locksmith'
  
  # Pods for BRYX Banner
  pod 'BRYXBanner'
  
  # Pods for Tab Bar Animation
  pod 'RAMAnimatedTabBarController', "~> 2.0.13"

  # Pods for firebase
  pod 'Firebase/Auth'
  

  target 'CreativeCalendarTests' do
    inherit! :search_paths
    # Pods for testing
    # Unit tests complained about the missing firebase module
    pod 'Firebase'
    
  end

  target 'CreativeCalendarUITests' do
    inherit! :search_paths
    # Pods for testing
    
  end
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              #config.build_settings['SWIFT_VERSION'] = '3.0'
              config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
          end
      end
  end
end
