Pod::Spec.new do |s|
  s.name         = "DoodleKit"
  s.version      = "0.0.3"
  s.summary  	 = 'Collaborative Doodling Framework using GameKit'
  s.homepage     = "https://github.com/crowdcompass/DoodleKit"
  s.license      = 'MIT'
  s.author       = { 'Alex Belliotti' => 'alexbelliotti@gmail.com', "Dave Shanley" => "dshanley@crowdcompass.com", "Kevin Steigerwald" => 'ksteigerwald@crowdcompass.com', "Chris Hellmuth" => 'chellmuth@crowdcompass.com', "Robert Corlett" => 'rcorlett@crowdcompass.com', "Benjamin Cullen-Kerney" => 'bkerney@crowdcompass.com', "Ryan Crosby" => 'rcrosby@crowdcompass.com' }
  s.source       = { :git => 'https://github.com/crowdcompass/DoodleKit.git', :branch => "framework" }
  s.source_files =  'DoodleKit/DoodleKit', 'DoodleKit/DoodleKit/Drawing'
  s.requires_arc = true
  s.public_header_files = 'DoodleKit/DoodleKit.h', 'DoodleKit/Drawing/DKDoodleView.h', 'DoodleKit/Drawing/DKSerializer.h'
  s.header_mappings_dir = 'DoodleKit'

  s.ios.deployment_target = '6.0'
  s.ios.frameworks = 'CoreFoundation', 'CoreGraphics', 'UIKit'

end
