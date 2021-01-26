#
# Be sure to run `pod lib lint GhostPlusSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GhostPlusSwift'
  s.version          = '1.0'
  s.summary          = 'GhostPlus Framework for Swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  This is a GhostpLus Swift framework which is used as Mobile Hybrid Application Common Framework
                       DESC

  s.homepage         = 'https://github.com/GhostPlusX/GhostPlusSwift.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'david1000@gmail.com' => 'daivd1000@gmail.com' }
  s.source           = { :git => 'https://github.com/GhostPlusX/GhostPlusSwift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'GhostPlusSwift/Classes/**/*'
  
  s.dependency   'Alamofire'
  s.dependency   'CryptoSwift'
  s.dependency   'Device'
  s.dependency   'SwiftyJSON'
  s.dependency   'ObjectMapper'
  s.dependency   'SwiftyXMLParser'
  s.dependency   'KeychainSwift'
  s.dependency   'SnapKit' 
  
  # s.resource_bundles = {
  #   'GhostPlusSwift' => ['GhostPlusSwift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
