BMGlyphLabel (Swift Version)
=================

This is a class to add the ability to easily add bmGlyph font files to SpriteKit.

Usage: 

	Import the BMGlyphLabel folder in your project (with the 2 .swift files)

You may create font objects like so:

	var font: BMGlyphFont?
	(...)
	font  = BMGlyphFont(name:"chrome")

It's useful to cache these as the initial load can be slow.

Create labels like this:

	 var label: BMGlyphLabel?
	 label = BMGlyphLabel(txt: "bmGlyph\nswift", fnt: font!)

	 label!.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));   
     self.addChild(label!)

Use "\n" in your string to signify a newline.

BMGlyphLabel inherits from SKNode, so you are able to apply any SKNode properties or methods to it (position). It also includes additional functionality, specific to the class:

#### horizontalAlignment *property*
Valid values:

	BMGlyphHorizontalAlignment.Centered,
	BMGlyphHorizontalAlignment.Right,
	BMGlyphHorizontalAlignment.Left

Usage:
	
	label!.setHorizontalAlignment(BMGlyphLabel.BMGlyphHorizontalAlignment.Left)
	
#### verticalAlignment *property*
Valid values:

	BMGlyphVerticalAlignment.Middle,
	BMGlyphVerticalAlignment.Top,
	BMGlyphVerticalAlignment.Bottom
	
Usage: 

	label!.setVerticalAlignment(BMGlyphLabel.BMGlyphVerticalAlignment.Middle)

#### textJustify *property*
Valid values:

	BMGlyphJustify.Left,
	BMGlyphJustify.Right,
	BMGlyphJustify.Center
	
Usage: 

	label!.setTextJustify(BMGlyphLabel.BMGlyphJustify.Center)

#### color *property*
This is the same usage as SKSpriteNode. SKColor value, etc etc.

Note: I like to make grayscale fonts that I then colorize. They can look very nice if done right.


#### colorBlendFactor *property*
This is the same usage as SKSpriteNode. CGFloat value ranging from 0.0 to 1.0, etc etc.

#### text *property*
NSString object. You can change this to change the text of the label.

Usage:

	label!.setGlyphText("-- justify --\ncenter")
    label!.setTextJustify(BMGlyphLabel.BMGlyphJustify.Center)



