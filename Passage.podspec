Pod::Spec.new do |s|
    s.name             = 'Passage'
    s.version          = '0.1.0'
    s.summary          = 'A short description of Passage.'
    s.homepage         = 'https://github.com/passageidentity/passage-ios'
    s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
    s.author           = { 'Passage Identity, Inc' => 'hello@passage.id' }
    s.source           = { :git => 'https://github.com/passageidentity/passage-ios', :tag => s.version.to_s }
    s.ios.deployment_target = '15.0'
    s.swift_version = '5.0'
    s.source_files = 'Sources/Passage/**/*'
    s.exclude_files = ['Sources/Passage/Passage.docc/**/*', 'docs']
    s.dependency 'SwiftKeychainWrapper'
end
