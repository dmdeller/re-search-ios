# Uncomment this line to define a global platform for your project
# platform :ios, "6.0"

target "ReSearch" do
    pod 'MagicalRecord', '~> 2.2.0'
end

target "ReSearchTests" do

end

target "ReSearch Favourite" do

end

#target "ReSearch Choose" do
#
#end

target "ReSearchKit" do

end

target "ReSearchKitTests" do

end

# https://github.com/CocoaPods/CocoaPods/wiki/Acknowledgements#ios-setting-bundle
post_install do |installer|
    require 'fileutils'
    FileUtils.cp_r('Pods/Pods-ReSearch-acknowledgements.plist', 'ReSearch/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
