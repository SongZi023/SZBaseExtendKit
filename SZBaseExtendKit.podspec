#
# Be sure to run `pod lib lint SZBaseExtendKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SZBaseExtendKit'
  s.version          = '0.1.0'
  s.summary          = 'OC中，常用的基础扩展类'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  OC中，常用的基础扩展类。如NSString，UIView，NSDictionary等等
                       DESC

  s.homepage         = 'https://github.com/SongZi023'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'w0231357129@163.com' => 'w0231357129@163.com' }
  s.source           = { :git => 'https://github.com/SongZi023/SZBaseExtendKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SZBaseExtendKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SZBaseExtendKit' => ['SZBaseExtendKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
