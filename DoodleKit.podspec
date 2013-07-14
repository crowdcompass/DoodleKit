Pod::Spec.new do |s|
  s.name         = "DoodleKit"
  s.version      = "0.0.6"
  s.description  = "DoodleKit manages up to four users drawings on a single canvas, allowing doodlers to create and share content across their devices."
  s.summary  	 = 'Collaborative Doodling Framework using GameKit'
  s.homepage     = "https://github.com/crowdcompass/DoodleKit"
  s.license      = 'MIT'
  s.authors      = { "Alex Belliotti"    => "alexbelliotti@gmail.com", 
                     "Dave Shanley"      => "dshanley@crowdcompass.com", 
                     "Kevin Steigerwald" => "ksteigerwald@crowdcompass.com", 
                     "Chris Hellmuth"    => "chellmuth@crowdcompass.com", 
                     "Robert Corlett"    => "rcorlett@crowdcompass.com", 
                     "Ben Cullen-Kerney" => "bkerney@crowdcompass.com", 
                     "Ryan Crosby"       => "rcrosby@crowdcompass.com" }
  s.source       = { :git => 'https://github.com/crowdcompass/DoodleKit.git' }
  s.source_files =  'DoodleKit/DoodleKit', 'DoodleKit/DoodleKit/Drawing', 'DoodleKit/DoodleKit/Networking'
  s.requires_arc = true
  s.public_header_files = 'DoodleKit/DoodleKit.h', 'DoodleKit/Drawing/DKDoodleView.h', 'DoodleKit/Drawing/DKSerializer.h'
  s.ios.deployment_target = '6.0'
  s.ios.frameworks = 'CoreFoundation', 'CoreGraphics', 'UIKit'
end
