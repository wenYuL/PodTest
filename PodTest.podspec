
Pod::Spec.new do |spec|

  spec.name         = "PodTest"
  spec.version      = "0.0.1"
  spec.summary      = "Test PodTest."
  spec.homepage     = "https://github.com/wenYuL/PodTest"
  spec.license      = "MIT (example)"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "刘文裕" => "wenyugogo@sina.com" }
  spec.platform     = :ios
  spec.source       = { :git => "https://github.com/wenYuL/PodTest.git", :tag => "#{spec.version}" }
  spec.source_files = "PodTest/*.{h,m}"
  spec.frameworks   = 'Foundation', 'UIKit', 'Masonry'
end
