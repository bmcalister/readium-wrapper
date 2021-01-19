Pod::Spec.new do |spec|


    spec.name         = "ReadiumWrapper"
    spec.version      = "0.0.1"
    spec.summary      = "A simple wrapper for Readium"
  
    spec.homepage     = "https://github.com/bmcalister/readium-wrapper"
  
    spec.license      = 'BSD 3-Clause License'
  
    spec.author             = { "Brian Mc Alister" => "brian@mca.io" }
  
    spec.source       = { :git => "https://github.com/bmcalister/readium-wrapper.git", :tag => "#{spec.version}" }
  
    spec.platform     = :ios
  
    spec.source_files  = "ReadiumWrapper/**/*.{swift, plist, .h, .m}"
    spec.exclude_files = ["**/Info*.plist"]
    spec.resources = ['ReadiumWrapper/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,json}']
  
    spec.ios.deployment_target = "10.0"
    spec.swift_version = "5.0"
  
    spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  end
  