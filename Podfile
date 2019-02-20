# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Sparen' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Sparen

    pod 'Firebase'
    pod 'Firebase/Core'
    pod 'Firebase/Auth'
    pod 'Firebase/Storage'
    pod 'Firebase/Database'
    pod 'Firebase/DynamicLinks'
    pod 'Firebase/Messaging'
    pod 'Firebase/Functions'
    pod 'IGListKit', '~> 3.0'
    pod 'SDWebImage', '~> 4.0'
    pod 'LTMorphingLabel'
    pod 'GSMessages'
    pod 'IQKeyboardManager'
    pod 'Cartography', '~> 3.0'
    pod 'Stripe'
    pod 'MBProgressHUD', '~> 1.1.0'
    pod 'Eureka'
    pod 'SwipeCellKit'
    pod 'CreditCardRow'



  target 'SparenTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SparenUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  post_install do |installer|
      # Your list of targets here.
      myTargets = ['Eureka']
      
      installer.pods_project.targets.each do |target|
          if myTargets.include? target.name
              target.build_configurations.each do |config|
                  config.build_settings['SWIFT_VERSION'] = '4.0'
              end
          end
       end
   end
end
