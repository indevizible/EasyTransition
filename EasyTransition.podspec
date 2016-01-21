Pod::Spec.new do |s|
s.name					= "EasyTransition"
s.version				= "1.2"
s.summary				= "EasyTransition is a simple library for make a transition in iOS."
s.homepage				= "https://github.com/indevizible/EasyTransition"
s.license				= { :type => "MIT", :file => 'LICENSE' }
s.authors				= { "indevizible" => "jadedragon17650@gmail.com" }

s.ios.deployment_target	= "8.0"
s.source				= { :git => "https://github.com/indevizible/EasyTransition.git", :tag => "#{s.version}"}
s.source_files			= "EasyTransition/**/EasyTransition.swift","EasyTransition/**/UIView+Constraints.swift"
s.requires_arc			= true
end