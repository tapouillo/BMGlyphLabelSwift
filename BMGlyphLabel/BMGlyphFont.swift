//
//  BMGlyphFont.swift
//  bmGlyphLabelS
//
//  Created by Stéphane QUERAUD on 20/02/2016.
//  Copyright © 2016 Stéphane QUERAUD. All rights reserved.
//

import Foundation
import SpriteKit


class BMGlyphFont: NSObject, NSXMLParserDelegate {
    
    var lineHeight: Int
    var kernings: [NSObject : AnyObject]
    var chars: [NSObject : AnyObject]
    var charsTextures: [NSObject : AnyObject]
    var textureAtlas: SKTextureAtlas

    func fontWithName(name: String) -> BMGlyphFont {
        return BMGlyphFont(name: name)
    }
    
    init(name: String) {
            lineHeight = 0
            kernings = [NSObject : AnyObject]()
            chars = [NSObject : AnyObject]()
            charsTextures = [NSObject : AnyObject]()
            textureAtlas = SKTextureAtlas(named: name)
            super.init()
        
            let fontFile: String = "\(name)\(getSuffixForDevice())"
        
            let path: NSURL = NSBundle.mainBundle().URLForResource(fontFile, withExtension: "xml")!
            let data: NSData = NSData(contentsOfURL: path)!
        
            let parser: NSXMLParser = NSXMLParser(data: data)
            parser.delegate = self
            parser.parse()
    }
    
    func getSuffixForDevice() -> String {
        var suffix: String = ""
        var scale: CGFloat
        if (UIScreen.mainScreen().respondsToSelector("nativeScale")) {
            scale = UIScreen.mainScreen().nativeScale
        }
        else {
            scale = UIScreen.mainScreen().scale
        }
        if scale == 2.0 {
            suffix = "@2x"
        }
        else if scale > 2.0 && scale <= 3.0 {
            suffix = "@3x"
        }
        
        return suffix
    }
    
    func xAdvance(charId: unichar) -> Int {
        let v = self.chars["xadvance_\(Int(charId))"]
        
        if (v != nil) {
            return Int(v as! NSNumber)
        }
        else {
            return 0;
        }
    }
    
    func xOffset(charId: unichar) -> Int {
        let v = self.chars["xoffset_\(Int(charId))"]
        
        if (v != nil) {
            return Int(v as! NSNumber)
        }
        else {
            return 0;
        }
    }
    
    func yOffset(charId: unichar) -> Int {
        let v = self.chars["yoffset_\(Int(charId))"]
        
        if (v != nil) {
            return Int(v as! NSNumber)
        }
        else {
            return 0;
        }
    }
    
    func kerningForFirst(first: unichar, second: unichar) -> Int {
        
        let v = self.kernings["\(Int(first))/\(Int(second))"]
        
        if (v != nil) {
            return Int(v as! NSNumber)
        }
        else {
            return 0;
        }
    }
    
    func textureFor(charId: Int) -> SKTexture {
        return self.textureAtlas.textureNamed("\(charId)")
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
    
        if (elementName == "kerning") {
            let first: Int = Int(attributeDict["first"]!)!
            let second: Int = Int(attributeDict["second"]!)!
            let amount: Int = Int(attributeDict["amount"]!)!
            self.kernings["\(Int(first))/\(Int(second))"] = amount
        }
        else if (elementName == "char") {
            let charId: Int = Int(attributeDict["id"]!)!
            let xadvance: Int = Int(attributeDict["xadvance"]!)!
            let xoffset: Int = Int(attributeDict["xoffset"]!)!
            let yoffset: Int = Int(attributeDict["yoffset"]!)!
            self.chars["xoffset_\(Int(charId))"] = xoffset
            self.chars["yoffset_\(Int(charId))"] = yoffset
            self.chars["xadvance_\(Int(charId))"] = xadvance
            self.charsTextures["\(Int(charId))"] = self.textureFor( charId )
        }
        else if (elementName == "common") {
            self.lineHeight = Int(attributeDict["lineHeight"]!)!
        }
        
    }
}