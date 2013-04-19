Pod::Spec.new do |s|
  s.name         = "AppPaoPao"
  s.version      = "0.0.1"
  s.license      = 'BSD'
  s.summary      = "AppPaoPao ios sdk."
  s.homepage     = "http://www.apppaopao.com"
  s.author       = { "Richard Huang" => "flyerhzm@gmail.com" }
  s.source       = { :git => "https://github.com/AppPaoPao/apppaopao-ios-sdk.git", commit: 'c8e5d62022' }#, :tag => "0.0.1" }
  s.platform     = :ios
  s.source_files = "AppPaoPao/*.{h,m}"
  s.preserve_paths = "libAppPaoPao.a"
  s.resources    = "AppPaoPaoResources.bundle"

  s.frameworks   = 'CoreGraphics', 'Foundation', 'UIKit'
  s.weak_frameworks = 'CoreTelephony'

  # Specify a list of frameworks that the application needs to link
  # against for this Pod to work.
  #
  # s.framework  = 'SomeFramework'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'

  # Specify a list of libraries that the application needs to link
  # against for this Pod to work.
  #
  # s.library   = 'iconv'
  # s.libraries = 'iconv', 'xml2'

  s.requires_arc = true

  s.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
  # If you need to specify any other build settings, add them to the
  # xcconfig hash.
  #
  # s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }

  # Finally, specify any Pods that this Pod depends on.
  #
  # s.dependency 'JSONKit', '~> 1.4'

end
