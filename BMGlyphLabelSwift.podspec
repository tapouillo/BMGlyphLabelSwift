Pod::Spec.new do |s|
  s.name         = 'BMGlyphLabelSwift'
  s.version      = '0.1.2'
  s.summary      = 'Use bitmap fonts generated from the bmGlyph app in SpriteKit - Swift Version'
  s.author = {
    'Stéphane Queraud' => 'stephane@sovapps.com'
  }
  s.source = {
    :git => 'https://github.com/tapouillo/BMGlyphLabelSwift.git',
    :tag =>  s.version.to_s 
  }
  s.license      = {
    :type => '???',
    :file => 'LICENSE.txt'
  }
  s.source_files = 'BMGlyphLabel/*.swift'
  s.homepage = 'https://github.com/tapouillo/BMGlyphLabelSwift'
  s.platform     = :ios, '8.0'
  s.ios.frameworks = 'SpriteKit'
  s.requires_arc = true
end
