#
# Be sure to run `pod lib lint YLT_Pay.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YLT_Pay'
  s.version          = '0.0.1'
  s.summary          = '支付方式集成'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
AliPay、WeChatPay、UnionPay、ApplePay等支付方式集成
                       DESC

  s.homepage         = 'https://github.com/YLTTeam/YLT_Pay.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xphaijj0305@126.com' => 'xianggong@126.com' }
  s.source           = { :git => 'https://github.com/YLTTeam/YLT_Pay.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'YLT_Pay/Classes/**/*.{h,m}'
  s.public_header_files = 'YLT_Pay/Classes/**/*.h'
  s.libraries = 'z'
  
  s.dependency 'YLT_BaseLib'
  #s.dependency 'OpenSSL-Universal'
  
  s.subspec 'AliPay' do |sp|
      sp.source_files = 'YLT_Pay/Classes/AliPay/*.{h,m}','YLT_Pay/Classes/AliPay/Util/*.{h,m}'
      sp.public_header_files = 'YLT_Pay/Classes/AliPay/*.h','PHPayLib/Classes/AliPay/Util/*.h'
      sp.vendored_frameworks = 'YLT_Pay/Classes/Alipay/*.framework'
      sp.resources = 'YLT_Pay/Classes/Alipay/*.bundle'
  end
  
  s.subspec 'WeChatPay' do |sp|
      sp.source_files = 'YLT_Pay/Classes/WeChatPay/*.{h,m}'
      sp.public_header_files = 'YLT_Pay/Classes/WeChatPay/*.h'
      sp.vendored_libraries = 'YLT_Pay/Classes/WeChatPay/*.a'
      sp.libraries = 'sqlite3.0'
  end
  
  s.subspec 'UnionPay' do |sp|
      sp.source_files = 'YLT_Pay/Classes/UnionPay/*.{h,m,mm}'
      sp.public_header_files = 'YLT_Pay/Classes/UnionPay/*.h'
      sp.vendored_libraries = 'YLT_Pay/Classes/UnionPay/*.a'
      sp.frameworks = 'CoreMotion'
  end
  
end
