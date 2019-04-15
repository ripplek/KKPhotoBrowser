

Pod::Spec.new do |s|


  s.name         = "KKPhotoBrowser"
  s.version      = "0.1.0"
  s.summary      = "A PhotoBorwser Library for iOS."
  s.homepage     = "https://github.com/ripplek/KKPhotoBrowser"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.swift_version = "5.0"
  s.swift_versions = ['4.0', '4.2', '5.0']
  s.author       = { "张坤" => "ripple_k@163.com" }
  s.source       = { :git => "https://github.com/ripplek/KKPhotoBrowser.git", :tag => "#{s.version}" }
  s.ios.deployment_target = "10.0"
  s.source_files  = "PhotoBrowser/KKPhotoBrowser/*.swift", "PhotoBrowser/KKPhotoBrowser/Animator/*.swift", "PhotoBrowser/KKPhotoBrowser/Model/*.swift", "PhotoBrowser/KKPhotoBrowser/View/*.swift"
  s.requires_arc = true
  s.dependency "Kingfisher"

  
end

