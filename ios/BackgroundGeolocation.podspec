
Pod::Spec.new do |s|
  s.name                = 'BackgroundGeolocation'
  s.version             = "3.0.0"
  s.summary             = "Background Geolocation summary"
  s.description         = <<-DESC
    Cross-platform background geolocation module for React Native with
    battery-saving circular stationary-region monitoring and stop detection.
  DESC
  s.homepage            = 'https://github.com/transistorsoft/background-geolocation-lt'
  s.license             = 'Custom'
  s.author              = 'Transistor Software <info@transistorsoft.com>'
  s.source              = { :git => 'https://github.com/transistorsoft/background-geolocation-lt.git', :tag => s.version }
  s.platform            = :ios, '8.0'

  s.static_framework = true
  s.preserve_paths      = 'docs', 'CHANGELOG.md', 'LICENSE'
  s.dependency 'CocoaLumberjack', '~> 3.5.1'
  s.libraries           = 'sqlite3', 'z'
  s.vendored_frameworks = 'BackgroundGeolocation/Frameworks/TSLocationManager.framework', 'BackgroundGeolocation/Frameworks/TSBackgroundFetch.framework'
end
