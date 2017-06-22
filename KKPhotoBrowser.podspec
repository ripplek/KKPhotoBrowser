

Pod::Spec.new do |s|


  s.name         = "KKPhotoBrowser"
  s.version      = "0.0.1"
  s.summary      = "A PhotoBorwser Library for iOS."
  s.homepage     = "https://github.com/ripplek/KKPhotoBrowser"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "张坤" => "ripple_k@163.com" }
  s.source       = { :git => "https://github.com/ripplek/KKPhotoBrowser.git", :tag => "#{s.version}" }
  s.ios.deployment_target = "9.0"
  s.source_files  = "PhotoBrowser/KKPhotoBrowser/*.swift", "PhotoBrowser/KKPhotoBrowser/Animator/*.swift", "PhotoBrowser/KKPhotoBrowser/Model/*.swift", "PhotoBrowser/KKPhotoBrowser/View/*.swift"
  s.requires_arc = true
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
  s.dependency "Kingfisher"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"
end

