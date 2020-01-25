//
//  AcoomplishmentScene.swift
//  Fret Sensei
//
//  Created by Lubin Tan on 13/3/16.
//  Copyright © 2016 Lubz. All rights reserved.
//

import Foundation
import SpriteKit

var rightAnswerCounter:Int = 0
var fiveInARow:Bool = false
var tenInARow:Bool = false
var twentyInARow:Bool = false
var fortyInARowOn4String:Bool = false
var fortyInARowOn5String:Bool = false
var fortyInARowOn6String:Bool = false
var fortyInARowOn7String:Bool = false
var fortyInARowOn8String:Bool = false
var fortyInARowOn9String:Bool = false
var fortyInARowOn10String:Bool = false

let fiver:Int = 3
let tenner:Int = 6
let twentier:Int = 9
let fortier4string:Int = 24
let fortier5string:Int = 29
let fortier6string:Int = 34
let fortier7string:Int = 39
let fortier8string:Int = 44
let fortier9string:Int = 49
let fortier10string:Int = 54

let fiverLabel = "5 in a row"
let tennerLabel = "10 in a row"
let twentierLabel = "20 in a row"
let fortierLabel = "40 in a row"

let fiverKey = "5key"
let tennerKey = "10key"
let twentierKey = "20key"
let fortier4Key = "40-4key"
let fortier5Key = "40-5key"
let fortier6Key = "40-6key"
let fortier7Key = "40-7key"
let fortier8Key = "40-8key"
let fortier9Key = "40-9key"
let fortier10Key = "40-10key"

let magentaColor = SKColor(red: 153.0/255.0, green: 0.0/255.0, blue: 76.0/255.0, alpha: 1)
let lightBlueColor = SKColor(red: 153.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)

func storeAcc(value: Bool, key: String){
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setBool(value, forKey: key)
//    defaults.synchronize()
}


class AccScene: SKScene{

    
    let acc5 = SKLabelNode(text: "5 in a row")
    let acc10 = SKLabelNode(text: "10 in a row")
    let acc20 = SKLabelNode(text: "20 in a row")
    let acc40for4 = SKLabelNode(text: "40 in a row on 4-string")
    let acc40for5 = SKLabelNode(text: "40 in a row on 5-string")
    let acc40for6 = SKLabelNode(text: "40 in a row on 6-string")
    let acc40for7 = SKLabelNode(text: "40 in a row on 7-string")
    let acc40for8 = SKLabelNode(text: "40 in a row on 8-string")
    let acc40for9 = SKLabelNode(text: "40 in a row on 9-string")
    let acc40for10 = SKLabelNode(text: "40 in a row on 10-string")
    
    let background:SKShapeNode = SKShapeNode(rect: CGRect(x: CGFloat(0), y: CGFloat(0), width: screenSize.width, height: screenSize.height))
    var homeAction: (() -> ())?
    var playAction: (() -> ())?
    
    let eachLabelFontLockedColor = SKColor(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0, alpha: 1)
    let eachLabelFontUnlockedColor = lightBlueColor
    

    
    func retrieveAcc(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.stringForKey(fiverKey) == "1"{ fiveInARow = true }
        if defaults.stringForKey(tennerKey) == "1"{ tenInARow = true }
        if defaults.stringForKey(twentierKey) == "1"{ twentyInARow = true }
        if defaults.stringForKey(fortier4Key) == "1"{ fortyInARowOn4String = true }
        if defaults.stringForKey(fortier5Key) == "1"{ fortyInARowOn5String = true }
        if defaults.stringForKey(fortier6Key) == "1"{ fortyInARowOn6String = true }
        if defaults.stringForKey(fortier7Key) == "1"{ fortyInARowOn7String = true }
        if defaults.stringForKey(fortier8Key) == "1"{ fortyInARowOn8String = true }
        if defaults.stringForKey(fortier9Key) == "1"{ fortyInARowOn9String = true }
        if defaults.stringForKey(fortier10Key) == "1"{ fortyInARowOn10String = true }
    }
    
    func accColors(){
        if fiveInARow {acc5.fontColor = eachLabelFontUnlockedColor; drawImage("starButton", position: CGPoint(x: acc5.frame.minX - 20, y: acc5.position.y), size: CGSize(width: acc5.frame.height, height: acc5.frame.height))} else{acc5.fontColor = eachLabelFontLockedColor}
        
        if tenInARow {acc10.fontColor = eachLabelFontUnlockedColor; drawImage("starButton", position: CGPoint(x: acc10.frame.minX - 20, y: acc10.position.y), size: CGSize(width: acc10.frame.height, height: acc10.frame.height))} else{acc10.fontColor = eachLabelFontLockedColor}
        
        if twentyInARow {acc20.fontColor = eachLabelFontUnlockedColor; drawImage("starButton", position: CGPoint(x: acc20.frame.minX - 20, y: acc20.position.y), size: CGSize(width: acc20.frame.height, height: acc20.frame.height))} else{acc20.fontColor = eachLabelFontLockedColor}
        
        
        if fortyInARowOn4String {acc40for4.fontColor = eachLabelFontUnlockedColor; drawImage("starButton", position: CGPoint(x: acc40for4.frame.minX - 20, y: acc40for4.position.y), size: CGSize(width: acc40for4.frame.height, height: acc40for4.frame.height))} else{acc40for4.fontColor = eachLabelFontLockedColor}
        
        if fortyInARowOn5String {acc40for5.fontColor = eachLabelFontUnlockedColor; drawImage("starButton", position: CGPoint(x: acc40for5.frame.minX - 20, y: acc40for5.position.y), size: CGSize(width: acc40for5.frame.height, height: acc40for5.frame.height))} else{acc40for5.fontColor = eachLabelFontLockedColor}
        
        if fortyInARowOn6String {acc40for6.fontColor = eachLabelFontUnlockedColor; drawImage("starButton", position: CGPoint(x: acc40for6.frame.minX - 20, y: acc40for6.position.y), size: CGSize(width: acc40for6.frame.height, height: acc40for6.frame.height))} else{acc40for6.fontColor = eachLabelFontLockedColor}
        
        if fortyInARowOn7String {acc40for7.fontColor = eachLabelFontUnlockedColor; drawImage("starButton", position: CGPoint(x: acc40for7.frame.minX - 20, y: acc40for7.position.y), size: CGSize(width: acc40for7.frame.height, height: acc40for7.frame.height))} else{acc40for7.fontColor = eachLabelFontLockedColor}
        
        if fortyInARowOn8String {acc40for8.fontColor = eachLabelFontUnlockedColor; drawImage("starButton", position: CGPoint(x: acc40for8.frame.minX - 20, y: acc40for8.position.y), size: CGSize(width: acc40for8.frame.height, height: acc40for8.frame.height))} else{acc40for8.fontColor = eachLabelFontLockedColor}
        
        if fortyInARowOn9String {acc40for9.fontColor = eachLabelFontUnlockedColor; drawImage("starButton", position: CGPoint(x: acc40for9.frame.minX - 20, y: acc40for9.position.y), size: CGSize(width: acc40for9.frame.height, height: acc40for9.frame.height))} else{acc40for9.fontColor = eachLabelFontLockedColor}

        if fortyInARowOn10String {acc40for10.fontColor = eachLabelFontUnlockedColor; drawImage("starButton", position: CGPoint(x: acc40for10.frame.minX - 20, y: acc40for10.position.y), size: CGSize(width: acc40for10.frame.height, height: acc40for10.frame.height))} else{acc40for10.fontColor = eachLabelFontLockedColor}
        
    }
    
    func drawImage(imageFileName: String, position: CGPoint, size: CGSize){
        let image = SKSpriteNode(imageNamed: imageFileName)
        image.position = position
        image.size = size
        background.addChild(image)
        
    }
    
    func createBackground(){
        background.fillColor = bgColor
        background.strokeColor = bgColor
        background.fillTexture = SKTexture(imageNamed: "background-fretsensei")
        background.strokeTexture = SKTexture(imageNamed: "background-fretsensei")
        addChild(background)
    }
    
    func createLabels(){
        
        let title = SKLabelNode(text: "Awards")
        
        let spacing = (screenSize.height - title.frame.height) / 10
        let eachLabelFontSize = screenSize.width / 30
        let eachLabelFontName = "AvenirNextCondensed-Bold"
        
        
        title.fontName = "AvenirNext-Bold"
        title.fontSize = screenSize.width / 20
        title.fontColor = dotColor
        title.position = CGPoint(x: screenSize.width/2.0, y: screenSize.height - (2 * spacing))
        title.horizontalAlignmentMode = .Center
        
        acc5.fontName = eachLabelFontName
        acc5.fontSize = eachLabelFontSize
        acc5.position = CGPoint(x: screenSize.width * 0.1 , y: title.frame.minY - (1.5 * spacing))
        acc5.horizontalAlignmentMode = .Left
        acc5.verticalAlignmentMode = .Center
        
        acc10.fontName = eachLabelFontName
        acc10.fontSize = eachLabelFontSize
        acc10.position = CGPoint(x: screenSize.width * 0.1, y: acc5.frame.minY - (spacing))
        acc10.horizontalAlignmentMode = .Left
        acc10.verticalAlignmentMode = .Center
    
        acc20.fontName = eachLabelFontName
        acc20.fontSize = eachLabelFontSize
        acc20.position = CGPoint(x: screenSize.width * 0.1, y: acc10.frame.minY - (spacing))
        acc20.horizontalAlignmentMode = .Left
        acc20.verticalAlignmentMode = .Center

        
        acc40for4.fontName = eachLabelFontName
        acc40for4.fontSize = eachLabelFontSize
        acc40for4.position = CGPoint(x: screenSize.width * 0.1 , y: acc20.frame.minY - (spacing))
        acc40for4.horizontalAlignmentMode = .Left
        acc40for4.verticalAlignmentMode = .Center
        
        acc40for5.fontName = eachLabelFontName
        acc40for5.fontSize = eachLabelFontSize
        acc40for5.position = CGPoint(x: screenSize.width * 0.1 , y: acc40for4.frame.minY - (spacing))
        acc40for5.horizontalAlignmentMode = .Left
        acc40for5.verticalAlignmentMode = .Center
        
        acc40for6.fontName = eachLabelFontName
        acc40for6.fontSize = eachLabelFontSize
        acc40for6.position = CGPoint(x: screenSize.width * 0.6 , y: title.frame.minY - (1.5 * spacing))
        acc40for6.horizontalAlignmentMode = .Left
        acc40for6.verticalAlignmentMode = .Center
        
        acc40for7.fontName = eachLabelFontName
        acc40for7.fontSize = eachLabelFontSize
        acc40for7.position = CGPoint(x: screenSize.width * 0.6 , y: acc40for6.frame.minY - (spacing))
        acc40for7.horizontalAlignmentMode = .Left
        acc40for7.verticalAlignmentMode = .Center
        
        acc40for8.fontName = eachLabelFontName
        acc40for8.fontSize = eachLabelFontSize
        acc40for8.position = CGPoint(x: screenSize.width * 0.6 , y: acc40for7.frame.minY - (spacing))
        acc40for8.horizontalAlignmentMode = .Left
        acc40for8.verticalAlignmentMode = .Center
        
        acc40for9.fontName = eachLabelFontName
        acc40for9.fontSize = eachLabelFontSize
        acc40for9.position = CGPoint(x: screenSize.width * 0.6 , y: acc40for8.frame.minY - (spacing))
        acc40for9.horizontalAlignmentMode = .Left
        acc40for9.verticalAlignmentMode = .Center
        
        acc40for10.fontName = eachLabelFontName
        acc40for10.fontSize = eachLabelFontSize
        acc40for10.position = CGPoint(x: screenSize.width * 0.6 , y: acc40for9.frame.minY - (spacing))
        acc40for10.horizontalAlignmentMode = .Left
        acc40for10.verticalAlignmentMode = .Center
        
        background.addChild(title)
        background.addChild(acc5)
        background.addChild(acc10)
        background.addChild(acc20)
        background.addChild(acc40for4)
        background.addChild(acc40for5)
        background.addChild(acc40for6)
        background.addChild(acc40for7)
        background.addChild(acc40for8)
        background.addChild(acc40for9)
        background.addChild(acc40for10)
        
      
        let homeButton = SimpleImageButton(imageFile: "homeButton", size: CGSize(width: 0.1 * screenSize.width, height: 0.1 * screenSize.width), buttonAction: homeAction!)
        homeButton.position = CGPoint(x: 0.95 * screenSize.width, y: screenSize.height - (0.06 * screenSize.width))
        
        let playButton = TriangleButton(size: CGSize(width: 0.08 * screenSize.width, height: 0.08 * screenSize.width), buttonAction: playAction! )
        playButton.position = CGPoint(x: 0.05 * screenSize.width, y: screenSize.height - (0.06 * screenSize.width))
        
        accColors()
        
        background.addChild(homeButton)
        background.addChild(playButton)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        createBackground()
        retrieveAcc()
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}