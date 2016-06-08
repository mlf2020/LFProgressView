Pod::Spec.new do |s|

  s.name         = "LFProgressView"
  s.version      = "1.0.0"
  s.summary      = "a light HUD you can easily use."
  s.license      = { :type => 'MIT'}
  s.author       = {'mlf2020' => '1162133023@qq.com'}
  s.source       = { :git => 'https://github.com/mlf2020/LFProgressView.git', :tag => "1.0.0" }
  s.platform     = :ios 
  s.source_files = 'LFProgressView.swift'
  s.framework    = 'UIKit' 
  s.requires_arc = true

end
