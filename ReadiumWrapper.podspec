Pod::Spec.new do |spec|

    spec.name         = "ReadiumWrapper"
    spec.version      = "0.1.2"
    spec.summary      = "A simple wrapper for Readium"
    spec.homepage     = "https://github.com/bmcalister/readium-wrapper"
    spec.license      = 'BSD 3-Clause License'
    spec.author       = { "Brian Mc Alister" => "brian@mca.io" }
    spec.source       = { :git => "https://github.com/bmcalister/readium-wrapper.git", :tag => "#{spec.version}" }
    spec.platform     = :ios
    spec.source_files  = ["ReadiumWrapper/**/*.{swift, plist, .h, .m}"]
    spec.exclude_files = ["**/Info*.plist"]
    spec.resources = ['ReadiumWrapper/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,json}']
    spec.ios.deployment_target = "10.0"
    spec.swift_version = "5"
    spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

    # Most of these don't resolve so we have to manually add them
    #
    # spec.dependency  'CryptoSwift', '1.3.2'
    # spec.dependency  'ZIPFoundation', '0.9.11'
    # spec.dependency  'Kingfisher','5.15.6'
    # spec.dependency  'MBProgressHUD','1.2.0'
    # spec.dependency  'SQLite.swift', '0.12.2'
    # spec.dependency  'Minizip', '1.0.0'
    # spec.dependency  'GCDWebServer', '3.6.3'
    # spec.dependency  'Fuzi', '3.1.2'
    # spec.dependency  'SwiftSoup', '2.3.2'
  
    # spec.dependency  'R2Shared', '2.0.0-beta.1'
    # spec.dependency  'R2Streamer', '2.0.0-beta.1'
    # spec.dependency  'R2Navigator', '2.0.0-beta.1'
    # spec.dependency  'ReadiumOPDS', '2.0.0-beta.1'

    spec.preserve_paths = 'Frameworks/Build/iOS/*.framework'
    spec.vendored_frameworks = 'Frameworks/Build/iOS/CryptoSwift.framework','Frameworks/Build/iOS/Fuzi.framework','Frameworks/Build/iOS/GCDWebServer.framework','Frameworks/Build/iOS/Kingfisher.framework','Frameworks/Build/iOS/KingfisherSwiftUI.framework','Frameworks/Build/iOS/MBProgressHUD.framework','Frameworks/Build/iOS/Minizip.framework','Frameworks/Build/iOS/R2Navigator.framework','Frameworks/Build/iOS/R2Shared.framework','Frameworks/Build/iOS/R2Streamer.framework','Frameworks/Build/iOS/ReadiumOPDS.framework','Frameworks/Build/iOS/SQLite.framework','Frameworks/Build/iOS/SwiftSoup.framework','Frameworks/Build/iOS/ZIPFoundation.framework'
    spec.ios.frameworks = 'CoreServices', 'SystemConfiguration'
  end
  