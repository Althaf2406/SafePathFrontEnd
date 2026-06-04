require 'xcodeproj'
project = Xcodeproj::Project.open('SafePath.xcodeproj')
app_target = project.targets.find { |t| t.name == 'SafePath' }
test_target = project.targets.find { |t| t.name == 'SafePathAppTests' }

if test_target && app_target
  test_target.add_dependency(app_target)
  
  test_target.build_configurations.each do |config|
    config.build_settings['SDKROOT'] = 'iphoneos'
    config.build_settings['TARGETED_DEVICE_FAMILY'] = '1,2'
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '26.2'
    config.build_settings.delete('WATCHOS_DEPLOYMENT_TARGET')
    
    config.build_settings['TEST_HOST'] = '$(BUILT_PRODUCTS_DIR)/SafePath.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/SafePath'
    config.build_settings['BUNDLE_LOADER'] = '$(TEST_HOST)'
  end
  
  project.save
  puts "Updated project settings successfully."
else
  puts "Target not found."
end
