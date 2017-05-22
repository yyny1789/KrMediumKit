
Pod::Spec.new do |s|
  s.name         = "KrMediumKit"
  s.version      = "0.1.7"
  s.summary      = "Basic components of 36kr Medium"
  s.license      = { :type => "MIT", :file => "License.md" }
  s.author             = { "yangyang" => "yangyang02@36kr.com" }

  s.homepage     = "https://github.com/yyny1789/KrMediumKit"
  s.source       = { :git => "https://github.com/yyny1789/KrMediumKit.git", :tag => s.version }
  s.platform     = :ios
  s.ios.deployment_target = "9.0"
  s.frameworks   = 'UIKit'

  s.subspec 'Core' do |ss|
      ss.source_files = "Source/Utils/", "Source/Utils/Extensions/"
  end

  s.subspec 'Database' do |ss|
      ss.source_files = "Source/Database/"
      ss.dependency "RealmSwift"
  end

  s.subspec 'Network' do |ss|
      ss.source_files = "Source/Network/"
      ss.dependency "KrMediumKit/Database"
      ss.dependency "Moya/RxSwift", "~> 8.0.0"
      ss.dependency "ObjectMapper", "~> 2.0.0"
      ss.dependency "ReachabilitySwift", "~> 3.0.0"
  end

  s.subspec 'UI' do |ss|
      ss.source_files = "Source/UI/"
      ss.dependency "KrMediumKit/Core"

      ss.subspec 'PullToRefresh' do |sss|
      sss.source_files = "Source/UI/PullToRefresh"
      sss.dependency "KrMediumKit/Core"
      end
      
  end

end
