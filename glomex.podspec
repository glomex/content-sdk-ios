Pod::Spec.new do |s|
  s.name             = 'glomex'
  s.version          = '0.1.0'
  s.summary          = 'This pod can be user for a Glomex Content SDK'

  s.description      = <<-DESC
  This pod can be user for a Glomex Content SDK. Please find the instruction on README
                       DESC

  s.homepage         = 'https://github.com/glomex/content-sdk-ios/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mrgerych@gmail.com' => 'mrgerych@gmail.com' }
  s.source           = { :git => 'https://github.com/glomex/content-sdk-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.default_subspec = 'Default'

  s.subspec 'Default' do |default|
    default.dependency 'glomex/ContentSdk'
  end

  s.subspec 'ContentSdk' do |contentsdk|
    contentsdk.source_files = 'Sources/**/*'
  end
end
