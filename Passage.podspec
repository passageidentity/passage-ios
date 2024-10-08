Pod::Spec.new do |s|
    s.name             = 'Passage'
    s.version          = ENV['LIB_VERSION'] || '1.1.1' #fallback to major version
    s.summary          = 'This pod is deprecated, please use PassageSwift instead.'
    s.homepage         = 'https://github.com/passageidentity/passage-ios'
    s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
    s.author           = { 'Passage Identity, Inc' => 'hello@passage.id' }
    s.source           = { :git => 'https://github.com/passageidentity/passage-ios.git', :tag => s.version.to_s }
    s.ios.deployment_target = '14.0'
    s.swift_version = '5.0'
    s.source_files = 'Sources/Passage/**/*'
    s.exclude_files = ['Sources/Passage/Passage.docc/**/*', 'docs']
    s.dependency 'SwiftKeychainWrapper'
    s.dependency 'AnyCodable-FlightSchool'

end
