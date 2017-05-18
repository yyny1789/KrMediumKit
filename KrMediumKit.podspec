
Pod::Spec.new do |s|
  s.name         = "KrMediumKit"
  s.version      = "0.0.3"
  s.summary      = "Basic components of 36kr Medium"
  s.license      = "MIT"
  s.author             = { "yangyang" => "yangyang02@36kr.com" }

  s.homepage     = "https://github.com/yyny1789/KrMediumKit"
  s.source       = { :git => "https://github.com/yyny1789/KrMediumKit.git", :tag => s.version }
  s.platform     = :ios
  s.ios.deployment_target = "9.0"
  s.source_files = "KrMediumKit/", "KrMediumKit/NetworkManager/"
  s.dependency "Moya/RxSwift", "~> 8.0.0"
end
