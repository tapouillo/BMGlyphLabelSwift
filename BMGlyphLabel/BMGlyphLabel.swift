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

open class BMGlyphLabel: SKNode {
    
    
    public enum BMGlyphHorizontalAlignment : Int {
        case centered = 1
        case right = 2
        case left = 3
    }
    
    public enum BMGlyphVerticalAlignment : Int {
        case middle = 1
        case top = 2
        case bottom = 3
    }
    
    public enum BMGlyphJustify : Int {
        case left = 1
        case right = 2
        case center = 3
    }
    
    fileprivate var text: String!
    fileprivate var horizontalAlignment: BMGlyphHorizontalAlignment
    fileprivate var verticalAlignment: BMGlyphVerticalAlignment
    fileprivate var textJustify: BMGlyphJustify
    fileprivate var color: SKColor
    fileprivate var colorBlendFactor: CGFloat
    fileprivate var totalSize: CGSize!
    fileprivate var font : BMGlyphFont!
    
    
     public init(txt: String, fnt: BMGlyphFont) {
        horizontalAlignment = BMGlyphHorizontalAlignment.centered
        verticalAlignment = BMGlyphVerticalAlignment.middle
        textJustify = BMGlyphJustify.left
        color = SKColor(red: 1, green: 1, blue: 1, alpha: 1);
        colorBlendFactor = 1.0;
        font = fnt
        text = ""
        totalSize = CGSize(width: 0, height: 0)
        super.init()
        setGlyphText(txt)
    }

    public required init?(coder aDecoder: NSCoder) {
       
        fatalError("init(coder:) has not been implemented")
    }

    
    open func setTextJustify(_ newTextJustify: BMGlyphJustify) {
        if textJustify != newTextJustify {
            self.textJustify = newTextJustify
            self.justifyText()
        }
    }
    
    open func setHorizontalAlignment(_ newAlign: BMGlyphHorizontalAlignment) {
        if horizontalAlignment != newAlign {
            self.horizontalAlignment = newAlign
            self.justifyText()
        }
    }
    
    open func setVerticalAlignment(_ newAlign: BMGlyphVerticalAlignment) {
        if verticalAlignment != newAlign {
            self.verticalAlignment = newAlign
            self.justifyText()
        }
    }
    
    open func setGlyphText(_ newText: String) {
        if !(text == newText) {
            self.text = newText
            self.updateLabel()
            self.justifyText()
        }
    }
    
    func positionLabel() {
    }
    
    func justifyText() {
        var shift: CGPoint = CGPoint.zero
        switch self.horizontalAlignment {
        case BMGlyphHorizontalAlignment.left:
            shift.x = 0
        case BMGlyphHorizontalAlignment.right:
            shift.x = -self.totalSize.width
        case BMGlyphHorizontalAlignment.centered:
            shift.x = -self.totalSize.width / 2
        }
        
        switch self.verticalAlignment {
        case BMGlyphVerticalAlignment.bottom:
            shift.y = -self.totalSize.height
        case BMGlyphVerticalAlignment.top:
            shift.y = 0
        case BMGlyphVerticalAlignment.middle:
            shift.y = -self.totalSize.height / 2
        }
        
        for node in self.children  {
            let originalPosition = (node as! SKSpriteNode).userData?.object(forKey: "originalPosition") as! CGPoint
            node.position = CGPoint(x: originalPosition.x + shift.x, y: originalPosition.y - shift.y)
        }
        if textJustify != BMGlyphJustify.left {
            var numberNodes: Int = 0
            var nodePosition: Int = 0
            var widthForLine: Int = 0
            var c: unichar
            var node: SKSpriteNode
            let upperBound = self.text.characters.distance(from: self.text.characters.startIndex, to: self.text.characters.endIndex)
            for i in 0...upperBound {
                if i != self.text.characters.count {
                    c = (self.text as NSString).character(at: i)
                }
                else {
                    c = "\n".utf16.first!
                }
                if c == "\n".utf16.first {
                    if numberNodes > 0 {
                        while nodePosition < numberNodes {
                            
                            node = self.children[nodePosition] as! SKSpriteNode
                            if textJustify == BMGlyphJustify.right {
                                node.position = CGPoint( x: node.position.x + self.totalSize.width - CGFloat(widthForLine) + shift.x,  y: node.position.y)
                            }
                            else {
                                node.position = CGPoint(x: node.position.x + (self.totalSize.width - CGFloat(widthForLine)) / 2 + shift.x / 2, y: node.position.y)
                            }
                            nodePosition += 1
                        }
                    }
                    widthForLine = 0
                }
                else {
                    node = self.children[numberNodes] as! SKSpriteNode
                    numberNodes += 1
                    widthForLine = Int(node.position.x + node.size.width)
                }
            }
        }
    }
    
    func updateLabel() {
        var lastCharId: unichar = 0
        var size: CGSize = CGSize.zero
        var pos: CGPoint = CGPoint.zero
        var scaleFactor: CGFloat
        scaleFactor = UIScreen.main.scale
        //scaleFactor = 1.0
        var letter: SKSpriteNode
        let childCount: Int = Int(self.children.count)
        let linesCount: Int = self.text.components(separatedBy: "\n").count - 1
        //remove unused SKSpriteNode
        if self.text.characters.count - linesCount < childCount && childCount > 0 {
            var del: SKSpriteNode
            for j in ((self.text.characters.count - linesCount + 1)...childCount).reversed() {
                del = self.children[j - 1] as! SKSpriteNode
                del.removeFromParent()
            }
        }
        if self.text.characters.count > 0 {
            size.height += (CGFloat(self.font.lineHeight) / scaleFactor)
        }
        var realCharCount: Int = 0
        for i in 0 ..< self.text.characters.count {
            
            let c: unichar = (self.text as NSString).character(at: i)
            if c == "\n".utf16.first {
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
                letter.anchorPoint = CGPoint.zero
                letter.position = CGPoint(x: pos.x + CGFloat(self.font.xOffset(c) + self.font.kerningForFirst(lastCharId, second: c)) / scaleFactor, y: pos.y - (letter.size.height + CGFloat(self.font.yOffset(c)) / scaleFactor))
               
                letter.userData = [
                    "originalPosition" : letter.position
                ]
                
                pos.x += CGFloat(self.font.xAdvance(c) + self.font.kerningForFirst(lastCharId, second: c)) / scaleFactor
                if size.width < pos.x {
                    size.width = pos.x
                }
                realCharCount += 1
            }
            lastCharId = c
        }
        self.totalSize = size
    }
    
    func setGlyphColor(_ color: SKColor) {
        self.color = color
        for letter in self.children {
            (letter as! SKSpriteNode).color = color
        }
       
    }
    
    func setGlyphColorBlendFactor(_ colorBlendFactor: CGFloat) {
        var factor = colorBlendFactor
        factor = min(factor, 1.0)
        factor = max(factor, 0.0)
        self.colorBlendFactor = factor
        
        for letter in self.children {
            (letter as! SKSpriteNode).colorBlendFactor = factor
        }
        
    }
}
