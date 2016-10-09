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
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        self.backgroundColor = SKColor.black
        
        font  = BMGlyphFont(name:"chrome")
        label = BMGlyphLabel(txt: "bmGlyph\nswift", fnt: font!)
        
        label!.position = CGPointMake(self.frame.midX, self.frame.midY);
        
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
