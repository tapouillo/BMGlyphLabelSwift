//
//  GameScene.swift
//  bmGlyphLabelS
//
//  Created by Stéphane QUERAUD on 20/02/2016.
//  Copyright (c) 2016 Stéphane QUERAUD. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
   
    var font: BMGlyphFont?
    var label: BMGlyphLabel?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.backgroundColor = SKColor.blackColor()
        
        font  = BMGlyphFont(name:"chrome")
        label = BMGlyphLabel(txt: "bmGlyph\nswift", fnt: font!)
        
        label!.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        self.addChild(label!)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        label!.setGlyphText("-- justify --\ncenter")
        label!.setTextJustify(BMGlyphLabel.BMGlyphJustify.Center)
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
