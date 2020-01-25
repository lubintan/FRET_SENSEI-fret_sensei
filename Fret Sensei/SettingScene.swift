//
//  SettingScene.swift
//  Fret Sensei
//
//  Created by Lubin Tan on 2/3/16.
//  Copyright © 2016 Lubz. All rights reserved.
//

import SpriteKit

let stringUpperLimit = 10
let stringLowerLimit = 1

var soundOn: Bool = true

var tuningsMoreThanNDifferent: Bool = false

func getTuningLabel(index: Int) ->String{
    var tuningText = tunings[index].description
    if tuningText.characters.count > 1 {
        tuningText = tuningText.substringToIndex(tuningText.startIndex.advancedBy(2))
    }
    return tuningText
}

func storeTunings(){
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setInteger(tunings.count, forKey: "length")
    
    for i in 0..<tunings.count{
        defaults.setInteger(tunings[i].rawValue, forKey: "\(i)")
    }
    
//    defaults.synchronize()
    
}

func retrieveTunings(){
    let length = memoryRetrieve("length")
    if length >= stringLowerLimit {
        tunings = []
        
        for i in 0..<length{
            let value = memoryRetrieve("\(i)")
            if value != -1{
                tunings.append(note(rawValue:value)!)
            }else{
                tunings = [note.E, note.A, note.D, note.G, note.B, note.E]
            }
        }
        
    }else{
        tunings = [note.E, note.A, note.D, note.G, note.B, note.E]
    }
}

func checkIfTuningsDifferent(){
    let threshold = 3
    let tuningsCopy = tunings
    
    tuningsMoreThanNDifferent = false
    
    let uniqueTunings = Set(tuningsCopy)
    if uniqueTunings.count >= threshold {tuningsMoreThanNDifferent = true}
    
    
}


var filePath : String {
    let manager = NSFileManager.defaultManager()
    let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
    return url.URLByAppendingPathComponent("objectsArray").path!
}

class SettingScene: SKScene {
    
    let bottomBarHeight = 0.1 * screenSize.height
    let fretHeight = 0.75 * screenSize.height
    var background:SKShapeNode!
    let stringStagger = 0.075 * screenSize.width
    var stringValue:SettingsButton!
    
    var fretValue:SettingsButton!
    let fretUpperLimit = 24
    let fretLowerLimit = 5
    var homeAction: (() -> ())?
    var playAction: (() -> ())?
    var soundButton: SimpleImageButton!
    let soundKey = "soundKey"
    
    let fretBoard:SKShapeNode = SKShapeNode(rect: CGRect(x: CGFloat(0), y: CGFloat(0), width: 0.2 * screenSize.width, height: 0.75 * screenSize.height), cornerRadius: 13.0)
    //height here must be same as "fretHeight"
    

    
    required init(coder aDecoder: NSCoder){
        fatalError("NSCoder not supported")
    }
    
    override init(size: CGSize){
        super.init(size: size)
        self.userInteractionEnabled = false
        
        drawBackground()
        drawFretBoard()
        drawStringOption()
        drawFretOption()
    }
    
    
    func drawBackground(){
        background = SKShapeNode(rect: CGRect(x: CGFloat(0),y:CGFloat(0),width: screenSize.width, height: screenSize.height))
        background.fillColor = bgColor
        background.strokeColor = bgColor
        background.fillTexture = SKTexture(imageNamed: "background-fretsensei")
        background.strokeTexture = SKTexture(imageNamed: "background-fretsensei")
        self.addChild(background)
        
        let homeButton = SimpleImageButton(imageFile: "homeButton", size: CGSize(width: 0.9 * statusHeight, height: 0.9 * statusHeight), buttonAction: homeTask)
        homeButton.position = CGPoint(x: background.frame.maxX - (0.55 * statusHeight), y: background.frame.maxY - (0.07 * screenSize.height))
        background.addChild(homeButton)
        
        let playButton = TriangleButton(size: CGSize(width: 0.9 * statusHeight, height: 0.9 * statusHeight), buttonAction: playTask )
        playButton.position = CGPoint(x: homeButton.frame.minX - (1.35 * statusHeight), y: background.frame.maxY - (0.07 * screenSize.height))
        background.addChild(playButton)
        
        
        if memoryRetrieve(soundKey) == 0 {
            soundButton = SimpleImageButton(imageFile: "speakerMute", size: CGSize(width: 0.9 * statusHeight, height: 0.9 * statusHeight), buttonAction: soundTask)
            soundOn = false
        } else {
            soundButton = SimpleImageButton(imageFile: "speakerON", size: CGSize(width: 0.9 * statusHeight, height: 0.9 * statusHeight), buttonAction: soundTask)
            soundOn = true
        }
        soundButton.position = CGPoint(x: playButton.frame.minX - (1.65 * statusHeight), y: background.frame.maxY - (0.07 * screenSize.height))
        background.addChild(soundButton)
        
        let intLabel = SKLabelNode(text: "Swipe left or right on each value to modify it.")
        intLabel.fontName = "Georgia-Italic"
        intLabel.fontSize *= 0.5 * screenSize.width / intLabel.frame.width
        intLabel.position = CGPoint(x: 0.05 * screenSize.width, y: 0.9 * screenSize.height)
        intLabel.horizontalAlignmentMode = .Left
        intLabel.verticalAlignmentMode = .Center
        background.addChild(intLabel)
        
         //draw fretboard
        fretBoard.position = CGPoint(x: 0.85 * screenSize.width, y: bottomBarHeight * 0.5)
        fretBoard.fillColor = fretBoardColor
        fretBoard.strokeColor = fretBoardColor
        fretBoard.fillTexture = SKTexture(imageNamed: "fretBoardWood")
        fretBoard.strokeTexture = SKTexture(imageNamed: "fretBoardWood")
        fretBoard.name = "fretBoard"
        background.addChild(fretBoard)
    }
    
    func homeTask(){
        homeAction!()
    }
    
    func playTask(){
        playAction!()
    }
    
    func soundTask(){
        if soundOn {
            soundOn = false
            soundButton.imageButton.texture = SKTexture(imageNamed: "speakerMute")
            memoryStore(0, key: soundKey)
        }
        else {
            soundOn = true
            soundButton.imageButton.texture = SKTexture(imageNamed: "speakerON")
            memoryStore(1, key: soundKey)
        }
    }
    
    func drawStringOption() {
        let stringLabel:SKLabelNode = SKLabelNode(text: "Strings")
        stringLabel.position = CGPoint(x: 0.2 * screenSize.width, y: fretHeight )
        stringLabel.fontColor = dotColor
        stringLabel.fontName = "AvenirNextCondensed-DemiBold"
        stringLabel.horizontalAlignmentMode = .Center
        stringLabel.verticalAlignmentMode = .Center
        stringLabel.fontSize = 0.05 * screenSize.height
        stringValue = SettingsButton(defaultText: String(tunings.count), size: CGSize(width: 0.15 * screenSize.width, height: 0.25 * screenSize.height), buttonRight: buttonRight, buttonLeft: buttonLeft, buttonRelease: {})
        stringValue.position = CGPoint(x: stringLabel.frame.midX, y:stringLabel.frame.minY - (stringLabel.frame.height * 1))
        
        background.addChild(stringLabel)
        background.addChild(stringValue)
        
        
    }
    
    func drawFretOption(){
        let fretLabel:SKLabelNode = SKLabelNode(text: "Frets")
        fretLabel.position = CGPoint(x: 0.2 * screenSize.width, y: fretHeight - (0.30 * screenSize.height) )
        fretLabel.fontColor = dotColor
        fretLabel.fontName = "AvenirNextCondensed-DemiBold"
        fretLabel.horizontalAlignmentMode = .Center
        fretLabel.verticalAlignmentMode = .Center
        fretLabel.fontSize = 0.05 * screenSize.height
        
        fretValue = SettingsButton(defaultText: String(numFrets), size: CGSize(width: 0.15 * screenSize.width, height: 0.25 * screenSize.height), buttonRight: fretRight, buttonLeft: fretLeft, buttonRelease: {memoryStore(numFrets, key: kFret)})
        fretValue.position = CGPoint(x: fretLabel.frame.midX, y:fretLabel.frame.minY - (fretLabel.frame.height * 1))
        
        background.addChild(fretLabel)
        background.addChild(fretValue)
    }
    
    func buttonRight(){
        if tunings.count < stringUpperLimit{
            addRemoveString(true)
            stringValue.noteLabel.text = String(tunings.count)
            
            fretBoard.removeAllChildren()
            drawFretBoard()
        }
        
    }
    
    func buttonLeft(){
        if tunings.count > stringLowerLimit{
            addRemoveString(false)
            stringValue.noteLabel.text = String(tunings.count)
            
            fretBoard.removeAllChildren()
            drawFretBoard()
        }
        
    }
    
    func addRemoveString(add:Bool){
        if add {
            let lowestNote = tunings[0].rawValue
            let nextString = (lowestNote + 7)%12 //  - 5 + 12 % 12, a perfect fifth down
            var tempArray: Array<note> =  tunings.reverse()
            tempArray.append(note(rawValue: nextString)!)
            tunings = tempArray.reverse()
        }else{
            tunings.removeFirst()
        }
        
        storeTunings()
    }
    
    func fretRight(){
        if numFrets < fretUpperLimit{
            numFrets += 1
            fretValue.noteLabel.text = String(numFrets)
        }
    }
    
    func fretLeft(){
        if numFrets > fretLowerLimit{
            numFrets -= 1
            fretValue.noteLabel.text = String(numFrets)
        }
    }
    
    func drawFretBoard(){
        
        let stringSpacing = fretHeight/CGFloat(tunings.count) //allow for max 10 strings
        let tuningKnowSpacing = fretHeight/CGFloat(10)
        
        
        
        //draw headstock
        let headStock = SKSpriteNode(texture: SKTexture(imageNamed: "headstockWood"), size: CGSize(width: 0.05  * screenSize.width, height: fretHeight))
        headStock.position = CGPoint(x:0, y:(fretHeight/2.0))
        fretBoard.addChild(headStock)
        
        //0th fret
        let fret0 = SKSpriteNode(texture: SKTexture(imageNamed: "nut"), size: CGSize(width: 0.03 * screenSize.width, height: fretHeight))
        fret0.position = CGPoint(x: headStock.frame.maxX, y: 0)
        fret0.zPosition = 1
        headStock.addChild(fret0)
        
        
        //draw Strings
        
        for i in 1..<(tunings.count+1){
            let stringPos = (CGFloat(i)-0.5)*stringSpacing
            let stringStartPos = CGFloat(CGFloat(i) - CGFloat(tunings.count) - 0.5) * stringStagger
            
            let thisString = SKShapeNode(rect: CGRect(x: stringStartPos, y: stringPos - (stringWidth * 0.5), width: screenSize.width, height: stringWidth))
            thisString.fillColor = stringColor
            thisString.fillTexture = SKTexture(imageNamed: "string")
            thisString.strokeColor = UIColor.clearColor()
            
            thisString.zPosition = 2
            
            fretBoard.addChild(thisString)
            
            
            
            let tuningKnob = TuningKnobButton(defaultText: getTuningLabel(i-1), size: CGSize(width: screenSize.width/14, height: stringSpacing), buttonRight: {}, buttonLeft: {}, buttonRelease: {}, stringIndex: i-1)
            tuningKnob.position = CGPoint(x: stringStartPos - tuningKnowSpacing, y: stringPos)
            tuningKnob.zPosition = 2
            
            fretBoard.addChild(tuningKnob)
        }
    }
    



}