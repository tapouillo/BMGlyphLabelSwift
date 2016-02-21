//
//  BMGlyphLabel.swift
//  bmGlyphLabelS
//
//  Created by Stéphane QUERAUD on 20/02/2016.
//  Copyright © 2016 Stéphane QUERAUD. All rights reserved.
//

import Foundation
import SpriteKit

//
//  bmGlyphLabel.m
//  SpriteKit Bitmap Font
//
//  Created by Stéphane QUERAUD on 11/10/13.
//  Copyright (c) 2013 Stéphane QUERAUD. All rights reserved.
//

class BMGlyphLabel: SKNode {
    
    
    enum BMGlyphHorizontalAlignment : Int {
        case Centered = 1
        case Right = 2
        case Left = 3
    }
    
    enum BMGlyphVerticalAlignment : Int {
        case Middle = 1
        case Top = 2
        case Bottom = 3
    }
    
    enum BMGlyphJustify : Int {
        case Left = 1
        case Right = 2
        case Center = 3
    }
    
    var text: String!
    var horizontalAlignment: BMGlyphHorizontalAlignment
    var verticalAlignment: BMGlyphVerticalAlignment
    var textJustify: BMGlyphJustify
    var color: SKColor
    var colorBlendFactor: CGFloat
    var totalSize: CGSize!
    var font : BMGlyphFont!
    
    
     init(txt: String, fnt: BMGlyphFont) {
        horizontalAlignment = BMGlyphHorizontalAlignment.Centered
        verticalAlignment = BMGlyphVerticalAlignment.Middle
        textJustify = BMGlyphJustify.Left
        color = SKColor(red: 1, green: 1, blue: 1, alpha: 1);
        colorBlendFactor = 1.0;
        font = fnt
        text = ""
        super.init()
        setGlyphText(txt)
    }

    required init?(coder aDecoder: NSCoder) {
       
        fatalError("init(coder:) has not been implemented")
    }

    
    func setTextJustify(newTextJustify: BMGlyphJustify) {
        if textJustify != newTextJustify {
            self.textJustify = newTextJustify
            self.justifyText()
        }
    }
    
    func setHorizontalAlignment(newAlign: BMGlyphHorizontalAlignment) {
        if horizontalAlignment != newAlign {
            self.horizontalAlignment = newAlign
            self.justifyText()
        }
    }
    
    func setVerticalAlignment(newAlign: BMGlyphVerticalAlignment) {
        if verticalAlignment != newAlign {
            self.verticalAlignment = newAlign
            self.justifyText()
        }
    }
    
    func setGlyphText(newText: String) {
        if !(text == newText) {
            self.text = newText
            self.updateLabel()
            self.justifyText()
        }
    }
    
    func positionLabel() {
    }
    
    func justifyText() {
        var shift: CGPoint = CGPointZero
        switch self.horizontalAlignment {
        case BMGlyphHorizontalAlignment.Left:
            shift.x = 0
        case BMGlyphHorizontalAlignment.Right:
            shift.x = -self.totalSize.width
        case BMGlyphHorizontalAlignment.Centered:
            shift.x = -self.totalSize.width / 2
        }
        
        switch self.verticalAlignment {
        case BMGlyphVerticalAlignment.Bottom:
            shift.y = -self.totalSize.height
        case BMGlyphVerticalAlignment.Top:
            shift.y = 0
        case BMGlyphVerticalAlignment.Middle:
            shift.y = -self.totalSize.height / 2
        }
        
        for node in self.children  {
            let originalPosition: CGPoint = ((node as! SKSpriteNode).userData?.objectForKey("originalPosition")?.CGPointValue)!
            node.position = CGPointMake(originalPosition.x + shift.x, originalPosition.y - shift.y)
        }
        if textJustify != BMGlyphJustify.Left {
            var numberNodes: Int = 0
            var nodePosition: Int = 0
            var widthForLine: Int = 0
            var c: unichar
            var node: SKSpriteNode
            for var i = 0; i <= self.text.characters.count; i++ {
                if i != self.text.characters.count {
                    c = (self.text as NSString).characterAtIndex(i)
                }
                else {
                    c = "\n".characterAtIndex(0)
                }
                if c == "\n".characterAtIndex(0) {
                    if numberNodes > 0 {
                        while nodePosition < numberNodes {
                            
                            node = self.children[nodePosition] as! SKSpriteNode
                            if textJustify == BMGlyphJustify.Right {
                                node.position = CGPointMake( node.position.x + self.totalSize.width - CGFloat(widthForLine) + shift.x,  node.position.y)
                            }
                            else {
                                node.position = CGPointMake(node.position.x + (self.totalSize.width - CGFloat(widthForLine)) / 2 + shift.x / 2, node.position.y)
                            }
                            nodePosition++
                        }
                    }
                    widthForLine = 0
                }
                else {
                    node = self.children[numberNodes] as! SKSpriteNode
                    numberNodes++
                    widthForLine = Int(node.position.x + node.size.width)
                }
            }
        }
    }
    
    func updateLabel() {
        var lastCharId: unichar = 0
        var size: CGSize = CGSizeZero
        var pos: CGPoint = CGPointZero
        var scaleFactor: CGFloat
        scaleFactor = UIScreen.mainScreen().scale
        //scaleFactor = 1.0
        var letter: SKSpriteNode
        let childCount: Int = Int(self.children.count)
        let linesCount: Int = self.text.componentsSeparatedByString("\n").count - 1
        //remove unused SKSpriteNode
        if self.text.characters.count - linesCount < childCount && childCount > 0 {
            var del: SKSpriteNode
            for var j = childCount; j > self.text.characters.count - linesCount; j-- {
                del = self.children[j - 1] as! SKSpriteNode
                del.removeFromParent()
            }
        }
        if self.text.characters.count > 0 {
            size.height += (CGFloat(self.font.lineHeight) / scaleFactor)
        }
        var realCharCount: Int = 0
        for var i = 0; i < self.text.characters.count; i++ {
            
            let c: unichar = (self.text as NSString).characterAtIndex(i)
            if c == "\n".characterAtIndex(0) {
                pos.y -= CGFloat(self.font.lineHeight) / scaleFactor
                size.height += CGFloat(self.font.lineHeight) / scaleFactor
                pos.x = 0
            }
            else {
                //re-use existing SKSpriteNode and re-assign the correct texture
                if realCharCount < childCount {
                    letter = self.children[realCharCount] as! SKSpriteNode
                    letter.texture = (self.font.charsTextures["\(c)"] as! SKTexture)
                    letter.size = letter.texture!.size()
                }
                else {
                    let glyphTexture = self.font.charsTextures["\(c)"]
                    if (glyphTexture != nil) {
                        letter = SKSpriteNode(texture: (glyphTexture as! SKTexture))
                        self.addChild(letter)
                    }
                    else {
                        letter = SKSpriteNode()
                    }
                }
                letter.colorBlendFactor = colorBlendFactor
                letter.color = color
                letter.anchorPoint = CGPointZero
                letter.position = CGPointMake(pos.x + CGFloat(self.font.xOffset(c) + self.font.kerningForFirst(lastCharId, second: c)) / scaleFactor, pos.y - (letter.size.height + CGFloat(self.font.yOffset(c)) / scaleFactor))
               
                letter.userData = [
                    "originalPosition" : NSValue(CGPoint: letter.position)
                ]
                
                pos.x += CGFloat(self.font.xAdvance(c) + self.font.kerningForFirst(lastCharId, second: c)) / scaleFactor
                if size.width < pos.x {
                    size.width = pos.x
                }
                realCharCount++
            }
            lastCharId = c
        }
        self.totalSize = size
    }
    
    func setGlyphColor(color: SKColor) {
        self.color = color
        for letter in self.children {
            (letter as! SKSpriteNode).color = color
        }
       
    }
    
    func setGlyphColorBlendFactor(var colorBlendFactor: CGFloat) {
        colorBlendFactor = min(colorBlendFactor, 1.0)
        colorBlendFactor = max(colorBlendFactor, 0.0)
        self.colorBlendFactor = colorBlendFactor
        
        for letter in self.children {
            (letter as! SKSpriteNode).colorBlendFactor = colorBlendFactor
        }
        
    }
}
