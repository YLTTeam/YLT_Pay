
Pod::Spec.new do |s|
  s.name             = 'YLT_Pay'
  s.version          = '0.0.3'
  s.summary          = '支付方式集成'

  s.description      = <<-DESC
AliPay、WeChatPay、UnionPay、ApplePay等支付方式集成
                       DESC

  s.homepage         = 'https://github.com/YLTTeam/YLT_Pay.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xphaijj0305@126.com' => 'xianggong@126.com' }
  s.source           = { :git => 'https://github.com/YLTTeam/YLT_Pay.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.platform     = :ios
  s.ios.deployment_target = '8.0'

  s.source_files = 'YLT_Pay/Classes/*.{h,m}'
  s.public_header_files = 'YLT_Pay/Classes/*.h'
  s.dependency 'YLT_BaseLib'
  
  s.subspec 'Pay' do |sp|
      sp.source_files = 'YLT_Pay/Classes/*.{h,m}'
      sp.public_header_files = 'YLT_Pay/Classes/*.h'
  end

  s.subspec 'AliPay' do |sp|
      sp.source_files = 'YLT_Pay/Classes/AliPay/*.{h,m}','YLT_Pay/Classes/AliPay/Util/*.{h,m}','YLT_Pay/Classes/AliPay/OpenSSL/OpenSSL/*.h'
      sp.public_header_files = 'YLT_Pay/Classes/AliPay/*.h','YLT_Pay/Classes/AliPay/Util/*.h'
      sp.vendored_frameworks = 'YLT_Pay/Classes/Alipay/*.framework'
      sp.vendored_libraries = 'YLT_Pay/Classes/Alipay/OpenSSL/lib/*.a'
      sp.resources = 'YLT_Pay/Classes/Alipay/*.bundle'
      sp.libraries = 'z','sqlite3.0','c++'
      sp.dependency 'YLT_Pay/Pay'
      sp.frameworks = 'CoreMotion','CFNetwork','CoreGraphics','CoreText','QuartzCore','CoreTelephony','SystemConfiguration','Foundation','UIKit'
      #sp.xcconfig = { 'ENABLE_BITCODE' => 'NO' }
  end

  s.subspec 'WeChatPay' do |sp|
      sp.source_files = 'YLT_Pay/Classes/WeChatPay/*.{h,m}','YLT_Pay/Classes/WeChatPay/lib/*.{h,m}'
      sp.public_header_files = 'YLT_Pay/Classes/WeChatPay/*.h'
      sp.vendored_libraries = 'YLT_Pay/Classes/WeChatPay/lib/*.a'
      sp.libraries = 'z','sqlite3.0','c++'
      sp.frameworks = 'Security','CFNetwork','CoreGraphics','CoreTelephony','SystemConfiguration','Foundation','UIKit'
      sp.dependency 'YLT_Pay/Pay'
      #sp.xcconfig = { 'ENABLE_BITCODE' => 'NO' }
  end

  s.subspec 'UnionPay' do |sp|
      sp.source_files = 'YLT_Pay/Classes/UnionPay/*.{h,m,mm}','YLT_Pay/Classes/UnionPay/lib/*.{h,m,mm}'
      sp.public_header_files = 'YLT_Pay/Classes/UnionPay/*.h'
      sp.vendored_libraries = 'YLT_Pay/Classes/UnionPay/lib/*.a'
      sp.frameworks = 'CoreMotion'
      sp.libraries = 'stdc++','z','sqlite3.0'
      sp.dependency 'YLT_Pay/Pay'
  end

  s.subspec 'ApplePay' do |sp|
      sp.source_files = 'YLT_Pay/Classes/ApplePay/*.{h,m}'
      sp.public_header_files = 'YLT_Pay/Classes/ApplePay/*.h'
      sp.frameworks = 'PassKit'
      sp.dependency 'YLT_Pay/Pay'
  end
  
  s.subspec 'IapPay' do |sp|
      sp.source_files = 'YLT_Pay/Classes/IapPay/*.{h,m}'
      sp.public_header_files = 'YLT_Pay/Classes/IapPay/*.h'
      sp.frameworks = 'StoreKit'
      sp.dependency 'YLT_Pay/Pay'
  end
  
  #sp.header_mappings_dir = 'YLT_Pay/Classes/AliPay/OpenSSL'
  #      sp.xcconfig = {
  #   'HEADER_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/YLT_Pay/Classes/AliPay/OpenSSL/'
  #}
  #sp.xcconfig = {
  #   'CLANG_CXX_LANGUAGE_STANDARD' => 'c++11',
  #    'CLANG_CXX_LIBRARY' => 'libc++'
  #}
end
