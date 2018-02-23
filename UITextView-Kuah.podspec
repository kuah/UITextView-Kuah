Pod::Spec.new do |s|
  s.name         = 'UITextView-Kuah'
  s.version      = '0.2'
  s.summary      = '为UITextView添加Placeholder'
  s.homepage     = 'https://github.com/kuah/UITextView-Kuah'
  s.author       = "CT4 => 284766710@qq.com"
  s.source       = {:git => 'https://github.com/kuah/UITextView-Kuah.git', :tag => "#{s.version}"}
  s.source_files = "source/**/*.{h,m}"
  s.requires_arc = true
  s.libraries = 'z'
  s.ios.deployment_target = '8.0'
  s.license = 'MIT'
  s.frameworks = 'UIKit'
end
