#
# Be sure to run `pod lib lint GlomexContentSdk.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GlomexContentSdk'
  s.version          = '0.1.0'
  s.summary          = 'This pod can be user for a Glomex Content SDK'

  s.description      = <<-DESC
  This pod can be user for a Glomex Content SDK. Please find the instruction on README
                       DESC

  s.homepage         = 'https://github.com/glomex/content-sdk-ios/'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mrgerych@gmail.com' => 'mrgerych@gmail.com' }
  s.source           = { :git => 'https://github.com/glomex/content-sdk-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Sources/**/*'
  
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
