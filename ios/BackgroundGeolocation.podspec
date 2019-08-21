require 'json'

package = JSON.parse(File.read(File.join(__dir__, '../package.json')))

Pod::Spec.new do |s|
  s.name                = 'BackgroundGeolocation'
  s.version             = package['version']
  s.summary             = package['description']
  s.description         = package['description']
  s.homepage            = package['homepage']
  s.license             = 'Custom'
  s.author              = package['author']
  s.source              = { :git => package['repository']['url'], :tag => s.version }
  s.platform            = :ios, '8.0'

  s.static_framework = true
  s.preserve_paths      = 'docs', 'CHANGELOG.md', 'LICENSE'
  s.dependency 'CocoaLumberjack', '~> 3.5.1'
  s.libraries           = 'sqlite3', 'z'
  s.vendored_frameworks = 'BackgroundGeolocation/Frameworks/TSLocationManager.framework', 'BackgroundGeolocation/Frameworks/TSBackgroundFetch.framework'
end
