
Pod::Spec.new do |spec|
  spec.name         = 'LFProgressView'
  spec.platform     = :ios,'8.0'
  spec.version      = '1.0.0'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/mlf2020/LFProgressView.git'
  spec.authors      = { 'Meng Lingfeng' => '1162133023@qq.com' }
  spec.summary      = 'provide a very easy way to add HUD.'
  spec.source       = { :git => 'https://github.com/mlf2020/LFProgressView.git', :tag => 'v1.0.0' }
  spec.source_files = "LFProgressView/LFProgressView.swift"
  spec.framework    = 'UIKit'
end
