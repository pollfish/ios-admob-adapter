Pod::Spec.new do |s|
s.name = 'PollfishAdMobAdapter'
s.version = '6.0.0.0'
s.platform = :ios, '9.0'
s.license = { :type => 'Commercial', :text => 'See https://www.pollfish.com/terms/publisher' }
s.summary = 'Pollfish iOS Adapter for AdMob Mediation'
s.description = 'Adapter for publishers looking to use AdMob mediation to load and show Rewarded Surveys from Pollfish in the same waterfall with other Rewarded Ads.'
s.homepage = 'https://www.pollfish.com/publisher'
s.author = { 'Pollfish Inc.' => 'support@pollfish.com' }
s.social_media_url = 'https://twitter.com/pollfish'
s.requires_arc = true
s.source = {
:git => 'https://github.com/pollfish/ios-admob-adapter.git',
:tag => s.version.to_s
}
s.dependencies = {
    'Pollfish'=> '6.0.0',
    'Google-Mobile-Ads-SDK' => '8.3.0'
}
s.documentation_url = 'https://www.pollfish.com/docs/ios-admob-adapter'
s.vendored_frameworks = 'PollfishAdMobAdapter.xcframework'
end
