Pod::Spec.new do |s|
  s.name         = "TransporterSwift"
  s.version      = "0.1.1"
  s.summary      = "A library makes uploading and downloading easier"
  s.homepage     = "https://github.com/nghialv/Transporter"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "nghialv" => "nghialv2607@gmail.com" }
  s.social_media_url   = "https://twitter.com/nghialv2607"

  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/nghialv/Transporter.git", :tag => "0.1.1" }
  s.source_files  = "Transporter/*"
  s.requires_arc = true
end
