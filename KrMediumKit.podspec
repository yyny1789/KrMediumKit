
Pod::Spec.new do |s|
  s.name         = "KrMediumKit"
  s.version      = "0.0.8"
  s.summary      = "Basic components of 36kr Medium"
  s.license      = { :type => "MIT", :file => "License.md" }
  s.author             = { "yangyang" => "yangyang02@36kr.com" }

  s.homepage     = "https://github.com/yyny1789/KrMediumKit"
  s.source       = { :git => "https://github.com/yyny1789/KrMediumKit.git", :tag => s.version }
  s.platform     = :ios
  s.ios.deployment_target = "9.0"
  s.frameworks       = 'UIKit'

  s.source_files = "Source/Network/"
  s.dependency "Moya", "~> 8.0.0"
  s.dependency "ObjectMapper", "~> 2.0.0"
  s.dependency "ReachabilitySwift", "~> 3.0.0"
  s.dependency "Device", "~> 3.0.0"

end
