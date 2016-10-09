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
        
        label!.position = CGPoint(x: self.frame.midX,y: self.frame.midY);
        
        self.addChild(label!)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            label!.setGlyphText("-- justify --\ncenter")
            label!.setTextJustify(BMGlyphLabel.BMGlyphJustify.center)
            
            // ...
        }
        super.touchesBegan(touches, with: event)
    }
    
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
