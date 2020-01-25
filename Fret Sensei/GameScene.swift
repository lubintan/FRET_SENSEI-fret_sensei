//
//  GameScene.swift
//  Fret Sensei
//
//  Created by Lubin Tan on 10/2/16.
//  Copyright (c) 2016 Lubz. All rights reserved.
//

import SpriteKit

var tunings:Array<note> = []
var numFrets = 15
let kFret = "kFret"
var lastTick:NSDate? = nil



let screenSize: CGRect = UIScreen.mainScreen().bounds

let timerLength = 50 //secs
let statusHeight = CGFloat(0.10) * screenSize.height
let fretBoardHeight = CGFloat(0.42) * screenSize.height
let userInputHeight = CGFloat(0.48) * screenSize.height
let stringWidth = fretBoardHeight * 0.02

let fretBoardColor = SKColor(red: 247.0/255.0, green: 176.0/255.0, blue: 104.0/255.0, alpha: 1)
let headStockColor = SKColor(red: 204.0/255.0, green: 102.0/255.0, blue: 0.0/255.0, alpha: 1)
let stringColor = SKColor(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0, alpha: 1)
let dotColor = SKColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
let bgColor = SKColor(red: 212.0/255.0, green: 152.0/255.0, blue: 228.0/255.0, alpha: 1)
let greenColor =  SKColor(red: 33.0/255.0, green: 213.0/255.0, blue: 111.0/255.0, alpha: 1)
let redColor = SKColor(red: 255.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1)
let bgGreen = SKColor(red: 153.0/255.0, green: 255.0/255.0, blue: 204.0/255.0, alpha: 1)
let fretColor = SKColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)

let singleDots = [3,5,7,9,15,17,19,21]
let doubleDots = [12,24]


func drawLabel(text:String, x:CGFloat, y:CGFloat, fontColor:UIColor=UIColor.blackColor(),fontSize:CGFloat=9, fontName:String = "Superclarendon-Black")->SKLabelNode{
    let newLabel = SKLabelNode(text: text)
    newLabel.fontSize=fontSize
    newLabel.fontColor=fontColor
    newLabel.fontName = fontName
    newLabel.position = CGPoint(x: x,y: y)
    return newLabel
}

func drawCircle(radius:CGFloat=CGFloat(10), x:CGFloat, y:CGFloat, fillColor:UIColor=UIColor.blackColor(), strokeColor:UIColor=UIColor.blackColor()) -> SKShapeNode{
    
    let newCircle = SKShapeNode(circleOfRadius: radius)
    newCircle.fillColor = fillColor
    newCircle.strokeColor = strokeColor
    newCircle.position = CGPoint(x: x, y: y)
    return newCircle
}

func drawLine(xStart:CGFloat, yStart:CGFloat, xEnd:CGFloat, yEnd:CGFloat, fillColor:UIColor=UIColor.blackColor(), strokeColor:UIColor=UIColor.blackColor(), lineWidth:CGFloat=CGFloat(2)) -> SKShapeNode{
    
    let ref = CGPathCreateMutable()
    let newLine = SKShapeNode()
    CGPathMoveToPoint(ref, nil, xStart, yStart)
    CGPathAddLineToPoint(ref, nil, xEnd, yEnd )
    newLine.path = ref
    newLine.lineWidth = lineWidth
    newLine.fillColor = fillColor
    newLine.strokeColor = strokeColor
    
    return newLine
}



func removeChildFromNode(parent: SKNode, kid: String){
    let this = parent.childNodeWithName(kid)
    if this != nil{
        parent.removeChildrenInArray([this!])
    }
}

func memoryStore(numberTostore: Int, key: String) -> String{
    
    //        print("updating...")
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setInteger(numberTostore, forKey: key)
//    defaults.synchronize()
    
    return key
}

func memoryRetrieve(key: String) -> Int{
    
    //        print ("retrieveing..")
    let defaults = NSUserDefaults.standardUserDefaults()
    if let storedHighScore = defaults.stringForKey(key){
        return Int(storedHighScore)!
    } else{
        return -1
    }
}


class GameScene: SKScene {
    
    
    let statusBannerColor = SKColor(red: 200.0/255.0, green: 152.0/255.0, blue: 200.0/255.0, alpha: 1)
    
    
    let background:SKShapeNode = SKShapeNode(rect: CGRect(x: CGFloat(0), y: CGFloat(0), width: screenSize.width, height: screenSize.height))
    var fretBoard:SKShapeNode = SKShapeNode(rect: CGRect(x: CGFloat(0), y: CGFloat(0), width: screenSize.width, height: fretBoardHeight))
    let statusBanner:SKShapeNode = SKShapeNode(rect: CGRect(x: CGFloat(0), y: CGFloat(0), width: screenSize.width, height: statusHeight))
    let userInput:SKShapeNode = SKShapeNode(rect: CGRect(x: CGFloat(0), y: CGFloat(0), width: screenSize.width, height: userInputHeight))
    
     let ABCDEFG = [("A",note.A.rawValue), ("B",note.B.rawValue), ("C",note.C.rawValue), ("D",note.D.rawValue), ("E",note.E.rawValue), ("F",note.F.rawValue), ("G",note.G.rawValue)]
    
    let highScoreKey = "highScoreKey"

    
    
    var tick:(() -> ())?
    var settingsAction: (() -> ())?
    var homeAction: (() -> ())?
    var tickLengthMillis = NSTimeInterval(1000)

    var touchableNodes:Array<SKNode> = []
    
    var score:Int = 0
    var currentHighScore:Int = 0
    var lock1:Bool = false
    let gameQueue = dispatch_queue_create("gameQueue", nil)
    
    
   
    //for user input area
    var circle:SKShapeNode!
    var circleLabel:SKLabelNode!
    
    var noteCoordinates:Array<Array<Fret>>!
    var noteCoordinatesCopy:Array<Array<Fret>>!
    var scoreValue:SKLabelNode!
    var timerValue:SKLabelNode!
    var highScoreValue:SKLabelNode!
    var startButton:TriangleButton!

    var pick:SKSpriteNode!
    var tempLabel:SKLabelNode!
    let tempLabelSize: CGFloat = 60
    
    
    required init(coder aDecoder: NSCoder){
        fatalError("NSCoder not supported")
    }
    
    override init(size: CGSize){
        
        super.init(size: size)
        
        self.userInteractionEnabled = true
    }
    
    

    
    //default background
    func requiredDrawing() -> Array<Array<Fret>>{
        
        drawBackground()
        noteCoordinates = drawFretBoard()
        noteCoordinatesCopy = noteCoordinates
        getNewCoords()
        drawStatusBanner()
        drawUserInput()
        
        
        
        return noteCoordinates
    }
    
    
    func drawBackground() {
        
        background.fillColor = bgColor
        background.strokeColor = bgColor
        background.fillTexture = SKTexture(imageNamed: "background-fretsensei")
        background.strokeTexture = SKTexture(imageNamed: "background-fretsensei")
        background.userInteractionEnabled = true
        self.addChild(background)
        
    }
    
    func drawStatusBanner() {

        
        let spacing = screenSize.width*(0.08)
       
        currentHighScore = retrieveHighScore()
        
        timerValue = drawLabel("TIMER: " + String(timerCounter), x: spacing, y: statusHeight/2.0, fontColor: dotColor, fontSize: statusHeight*0.5)
        scoreValue = drawLabel("SCORE: "+"0", x: timerValue.frame.maxX + spacing, y: statusHeight/2.0, fontColor: dotColor, fontSize: statusHeight*0.5)
        
        highScoreValue = drawLabel("HIGH SCORE: " + String(currentHighScore), x: scoreValue.frame.maxX + spacing, y: statusHeight/2.0, fontColor: dotColor, fontSize: statusHeight*0.5)
        
        scoreValue.fontName = "AvenirNextCondensed-Bold"
        timerValue.fontName = "AvenirNextCondensed-Bold"
        highScoreValue.fontName = "AvenirNextCondensed-Bold"

        let settingsIcon = SimpleImageButton(imageFile: "settingsButtonWithHole", size: CGSize(width: (0.9 * statusHeight), height: (0.9 * statusHeight)), buttonAction: settingsTask)
        
        settingsIcon.position = CGPoint(x: statusBanner.frame.maxX - (statusHeight * 3), y: statusHeight/2.0)
        settingsIcon.userInteractionEnabled = true
        
        let homeIcon = SimpleImageButton(imageFile: "homeButton", size: CGSize(width: (0.9 * statusHeight), height: (0.9 * statusHeight)), buttonAction: homeTask)
        homeIcon.position = CGPoint(x: settingsIcon.frame.maxX + ( 2 * statusHeight) , y: statusHeight/2.0)
        homeIcon.userInteractionEnabled = true
        
        
        statusBanner.addChild(scoreValue)
        statusBanner.addChild(timerValue)
        statusBanner.addChild(highScoreValue)
        statusBanner.addChild(settingsIcon)
        statusBanner.addChild(homeIcon)
        
        scoreValue.verticalAlignmentMode = .Center
        timerValue.verticalAlignmentMode = .Center
        highScoreValue.verticalAlignmentMode = .Center
        
        scoreValue.horizontalAlignmentMode = .Left
        timerValue.horizontalAlignmentMode = .Left
        highScoreValue.horizontalAlignmentMode = .Left
        
        statusBanner.position = CGPoint(x: background.frame.minX, y: userInputHeight + fretBoardHeight)
        statusBanner.fillColor = UIColor.clearColor()
        statusBanner.strokeColor = UIColor.clearColor()
        background.addChild(statusBanner)
        statusBanner.userInteractionEnabled = true
    }
    
    
    func drawFretBoard(selfNumFrets:Int = numFrets, selfTunings:Array<note> = tunings, completion : (() -> ()) = {}) -> Array<Array<Fret>>{
        
        rightAnswerCounter = 0 // reset
        
        fretBoard = SKShapeNode(rect: CGRect(x: CGFloat(0), y: CGFloat(0), width: screenSize.width, height: fretBoardHeight))
        
        
        //draw templabel for use later
        tempLabel = drawLabel("", x: fretBoard.frame.midX, y: 0, fontColor: redColor, fontSize: tempLabelSize)
        tempLabel.zPosition = 5
        
        let headStockWidth = screenSize.width * 0.03
        
        let fretWidth = (screenSize.width - headStockWidth)/CGFloat(selfNumFrets)
        
        let midFret:Int
        if selfNumFrets%2 == 0 {midFret = selfNumFrets/2}
        else {midFret = (selfNumFrets - 1)/2}
        
        let fretSlice = fretWidth/CGFloat(midFret+10)
        
        
        let stringSpacing = fretBoardHeight/CGFloat(selfTunings.count)
        
        //for use in finding coordinates
        var xArray : Array<CGFloat> = []
        var yArray : Array<CGFloat> = []

        
        //draw fretboard
        fretBoard.position = CGPoint(x: screenSize.width, y: userInputHeight)
        fretBoard.fillColor = fretBoardColor
        fretBoard.strokeColor = fretBoardColor
        fretBoard.fillTexture = SKTexture(imageNamed: "fretBoardWood")
        fretBoard.strokeTexture = SKTexture(imageNamed: "fretBoardWood")
        background.addChild(fretBoard)
        
        //draw headstock
        let headStock = SKSpriteNode(texture: SKTexture(imageNamed: "headstockWood"), size: CGSize(width: headStockWidth * 1.5, height: fretBoardHeight))
        headStock.position = CGPoint(x:0, y:(fretBoardHeight/2.0))
        fretBoard.addChild(headStock)

        
        //0th fret
        
        let fret0 = SKSpriteNode(texture: SKTexture(imageNamed: "nut"), size: CGSize(width: headStockWidth * 0.5, height: fretBoardHeight))
        fret0.position = CGPoint(x: headStockWidth, y: fretBoardHeight/2.0)
        
        
        fretBoard.addChild(fret0)
        xArray = [ headStockWidth * 0.5]
        
        
        
        var lastFretPos = headStockWidth
        //draw Frets
        for i in 1..<(selfNumFrets + 1){
            let thisFretWidth:CGFloat
            if ((selfNumFrets%2==0) && (i>=midFret)){
                thisFretWidth = fretWidth + (fretSlice * CGFloat(midFret - i))
            }else{
                thisFretWidth = fretWidth + (fretSlice * CGFloat(midFret - i + 1 ))
            }
            
            let fretPos = lastFretPos + thisFretWidth
            lastFretPos = fretPos
            let thisFret = drawLine(fretPos, yStart:0 , xEnd:fretPos, yEnd:fretBoardHeight, fillColor:fretColor, strokeColor:fretColor)
            fretBoard.addChild(thisFret)
            xArray.append(fretPos - (0.5 * thisFretWidth))
            
            //draw dots
            if doubleDots.contains(i){
                let midpoint = fretPos - (0.5 * thisFretWidth)
                let y1 = fretBoardHeight/CGFloat(4)
                let y2 = y1*CGFloat(3)
                let radius = 0.2 * fretWidth
                
                let dot1 = drawCircle(radius, x: midpoint, y: y1, fillColor: dotColor, strokeColor: dotColor)
                let dot2 = drawCircle(radius, x: midpoint, y: y2, fillColor: dotColor, strokeColor: dotColor)
                fretBoard.addChild(dot1)
                fretBoard.addChild(dot2)
            }
            
            if singleDots.contains(i){
                let midpoint = fretPos - (0.5 * thisFretWidth)
                let y = fretBoardHeight/CGFloat(2)
                let radius = 0.2 * fretWidth
                
                let dot = drawCircle(radius, x: midpoint, y: y, fillColor: dotColor, strokeColor: dotColor)
                fretBoard.addChild(dot)
                
            }
            

        }
        

        
        
        //draw Strings
        for i in 1..<(selfTunings.count+1){
            let stringPos = (CGFloat(i)-0.5) * stringSpacing
            let thisString = SKShapeNode(rect: CGRect(x: -1.0 * headStockWidth, y: stringPos - (stringWidth * 0.5), width: screenSize.width + headStockWidth, height: stringWidth))
            thisString.fillColor = stringColor
            thisString.fillTexture = SKTexture(imageNamed: "string")
            thisString.strokeColor = UIColor.clearColor()
            
            thisString.zPosition = 2.0
            fretBoard.addChild(thisString)
            
            yArray.append(stringPos)
        }
       
        
        
        pick = SKSpriteNode(imageNamed: "pick")
        pick.size = CGSize(width: 0.04 * screenSize.width, height: fretBoardHeight/10)
        pick.zPosition = 3.0
        
        pick.hidden = true
        tempLabel.hidden = true
        fretBoard.addChild(pick)
        fretBoard.addChild(tempLabel)
        tempLabel.horizontalAlignmentMode = .Center
        tempLabel.verticalAlignmentMode = .Bottom
        
        
        
        //fretboard notes
        let fretBoardNotes = FretBoard(tunings: selfTunings, noOfFrets: selfNumFrets, xArray: xArray, yArray: yArray)
        
        
        
        let moveAction = SKAction.moveToX(0, duration: 1)
        moveAction.timingMode = .EaseOut
        fretBoard.runAction(moveAction, completion: {self.startButton.userInteractionEnabled = true; completion()})
        
        
        return fretBoardNotes.fretBoard

    }
    
    func drawUserInput() {
        userInput.position = CGPoint(x: 0,y: 0)
        userInput.fillColor = UIColor.clearColor()
        userInput.strokeColor = UIColor.clearColor()
        userInput.userInteractionEnabled = true
        background.addChild(userInput)
        
        let circleRadius = CGFloat(0.3 * userInputHeight)

        
        circle = drawCircle(circleRadius, x: userInput.frame.midX, y: circleRadius + CGFloat(0.05 * userInputHeight), fillColor: fretBoardColor, strokeColor: fretBoardColor)
        
        circleLabel = drawLabel("", x: 0, y: 0, fontColor: dotColor, fontSize: circleRadius , fontName: "Georgia")
        
        userInput.addChild(circle)
        circle.addChild(circleLabel)
        circleLabel.horizontalAlignmentMode = .Center
        circleLabel.verticalAlignmentMode = .Center
        
        //draw Start Button
        
        startButton = TriangleButton(size: CGSize(width: 1.2 * circleRadius, height: 1.2 * circleRadius), buttonAction: gameBegan)
        startButton.name = "startButton"
        startButton.position = CGPoint(x: 0.115 * circleRadius, y: -0.05 * circleRadius)
        startButton.userInteractionEnabled = false
        circle.addChild(startButton)

        
        
        //draw arc of notes
        
        let points = [CGPoint(x: 0.1 * screenSize.width, y: 0.0605422 * screenSize.height),
                      CGPoint(x: 0.21502 * screenSize.width, y: 0.230321 * screenSize.height),
                      CGPoint(x: 0.351843 * screenSize.width, y: 0.337678 * screenSize.height),
                      CGPoint(x: 0.5 * screenSize.width, y: 0.3744 * screenSize.height),
                      CGPoint(x: 0.648157 * screenSize.width, y: 0.337678 * screenSize.height),
                      CGPoint(x: 0.78498 * screenSize.width, y: 0.230321 * screenSize.height),
                      CGPoint(x: 0.9 * screenSize.width, y: 0.0605422 * screenSize.height),
                      ]

        for i in 0..<(points.count){
//
//              
            let thisLabel = SKButton(defaultText:ABCDEFG[i].0, noteIndex:ABCDEFG[i].1 ,size: CGSize(width: 1.2 * circleRadius, height: 1.0 * circleRadius), buttonAction: buttonAction, buttonRelease: enterAnswer)
            thisLabel.noteLabel.fontSize = userInput.frame.height/5.0
            thisLabel.position = points[i]
            thisLabel.userInteractionEnabled = false
            userInput.addChild(thisLabel)
            
            
            
            touchableNodes.append(thisLabel)
            
//            
//            
            }
        

        }
        
    func settingsTask(){
        settingsAction?()
    }
    
    func homeTask(){
        homeAction?()
    }
        
    func buttonAction() -> Void{
        if lastTick != nil{
            circleLabel.text = notePressed
        }
        return
    }
    
    func enterAnswer() -> Void{
        if lastTick != nil {
                self.view?.userInteractionEnabled = false
                
                if currentCorrectNote!.rawValue == noteSelected!.rawValue{
                    self.circle.fillColor = greenColor
                    self.circle.strokeColor = greenColor
                    self.score += 1
                    if soundOn {self.circle.runAction(playCorrect)}
                    
                    rightAnswerCounter += 1
                    
                    if tuningsMoreThanNDifferent{
                        if rightAnswerCounter == 5 {
                            skView.frameInterval = 1
                            
                            fiveInARow = true
                            self.score += fiver
                            
                            self.tempLabel.fontSize = tempLabelSize / 2
                            self.tempLabel.position.y = 0
                            self.tempLabel.text = fiverLabel
                            self.tempLabel.fontColor = greenColor
                            self.tempLabel.hidden = false
                            self.tempLabel.runAction(SKAction.moveToY(100, duration: 0.5), completion: {skView.frameInterval = playModeFrameInterval})
                            
                            storeAcc(true, key: fiverKey)
                            
                        } else if rightAnswerCounter == 10 {
                            skView.frameInterval = 1

                            tenInARow = true
                            self.score += tenner
                            
                            self.tempLabel.fontSize = tempLabelSize / 2
                            self.tempLabel.position.y = 0
                            self.tempLabel.text = tennerLabel
                            self.tempLabel.fontColor = greenColor
                            self.tempLabel.hidden = false
                            self.tempLabel.runAction(SKAction.moveToY(100, duration: 0.5), completion: {skView.frameInterval = playModeFrameInterval})
                            
                            storeAcc(true, key: tennerKey)
                            
                        } else if rightAnswerCounter == 20 {
                            skView.frameInterval = 1

                            twentyInARow = true
                            self.score += twentier
                            
                            self.tempLabel.fontSize = tempLabelSize / 2
                            self.tempLabel.position.y = 0
                            self.tempLabel.text = twentierLabel
                            self.tempLabel.fontColor = greenColor
                            self.tempLabel.hidden = false
                            self.tempLabel.runAction(SKAction.moveToY(100, duration: 0.5), completion: {skView.frameInterval = playModeFrameInterval})
                            
                            storeAcc(true, key: twentierKey)
                            
                        }else if rightAnswerCounter == 40 {
                            skView.frameInterval = 1
                            
                            self.tempLabel.fontSize = tempLabelSize / 2
                            self.tempLabel.position.y = 0
                            self.tempLabel.text = fortierLabel
                            self.tempLabel.fontColor = greenColor
                            self.tempLabel.hidden = false
                            self.tempLabel.runAction(SKAction.moveToY(100, duration: 0.5), completion: {skView.frameInterval = playModeFrameInterval})
                            
                            if tunings.count == 4 {
                                fortyInARowOn4String = true
                                self.score += fortier4string
                                storeAcc(true, key: fortier4Key)
                                
                            }else if tunings.count == 5 {
                                fortyInARowOn5String = true
                                self.score += fortier5string
                                storeAcc(true, key: fortier5Key)
                                
                            }else if tunings.count == 6 {
                                fortyInARowOn6String = true
                                self.score += fortier6string
                                storeAcc(true, key: fortier6Key)
                                
                            }else if tunings.count == 7 {
                                fortyInARowOn7String = true
                                self.score += fortier7string
                                storeAcc(true, key: fortier7Key)
                                
                            }else if tunings.count == 8 {
                                fortyInARowOn8String = true
                                self.score += fortier8string
                                storeAcc(true, key: fortier8Key)
                                
                            }else if tunings.count == 9 {
                                fortyInARowOn9String = true
                                self.score += fortier9string
                                storeAcc(true, key: fortier9Key)
                                
                            }else if tunings.count == 10 {
                                fortyInARowOn10String = true
                                self.score += fortier10string
                                storeAcc(true, key: fortier10Key)
                            }
                        }
                    }
                    
                    if self.score > self.currentHighScore {
                        self.currentHighScore = self.score
                        self.updateHighScore()
                        self.highScoreValue.text = "HIGH SCORE: " + String(self.currentHighScore)
                    }
                    self.scoreValue.text = "SCORE: " + String(self.score)
                    
                    
                    //            print ("CORRECT!")
                    
                }else{
                    self.tempLabel.hidden = true
                    self.tempLabel.fontSize = tempLabelSize
                    self.tempLabel.fontColor = redColor
                    self.tempLabel.position.y = 0
                    self.tempLabel.text = currentCorrectNote!.noteName

                    
                    self.tempLabel.hidden = false
                    self.circle.fillColor = redColor
                    self.circle.strokeColor = redColor
                    if soundOn {self.circle.runAction(playWrong)}
                    rightAnswerCounter = 0
                    
                }
            
            
                self.circle.runAction(SKAction.waitForDuration(0.5), completion: {
                    self.view?.userInteractionEnabled = true
                    self.generateFinger()
                    
                    self.circle.fillColor = fretBoardColor
                    self.circle.strokeColor = fretBoardColor
                    self.circleLabel.text = ""
                })
        
        }
     }

    
    func generateFinger(){

        
        getNewCoords()
        
        
        if lastTick != nil{
            tempLabel.hidden = true
            pick.hidden = false
        
        }
}

    func getNewCoords(){
        self.pick.hidden = true
        
        
        if self.noteCoordinatesCopy.isEmpty{
            self.noteCoordinatesCopy = self.noteCoordinates
        }
        
        
        let randomizer1 = NSCalendar.currentCalendar().component(NSCalendarUnit.Second, fromDate: NSDate())
        
        let stringIndex = (randomizer1) % (self.noteCoordinatesCopy.count)
        let coordinates = self.noteCoordinatesCopy[stringIndex].removeAtIndex((randomizer1) % (self.noteCoordinatesCopy[stringIndex].count))
        
        self.pick.position = CGPoint(x: coordinates.centerPoint.x, y: coordinates.centerPoint.y)
        
        if self.noteCoordinatesCopy[stringIndex].isEmpty{
            self.noteCoordinatesCopy.removeAtIndex(stringIndex)
        }
        
        currentCorrectNote = coordinates.fretNote
        
    }
        
        
    
    
    
    func calcPoints(arcRadius: CGFloat, theta: CGFloat) -> CGPoint {
        return CGPoint(x: arcRadius * sin(theta), y: arcRadius * cos(theta))
    }
    

    
    func startTicking() {
        lastTick = NSDate()
    }
    
    func stopTicking() {
        lastTick = nil
    }
    
    func gameBegan() {
        self.startTicking()
    startButton.hidden = true
        self.score = 0
        rightAnswerCounter = 0
        self.scoreValue.text = "SCORE: " + String(self.score)
    
        pick.hidden = false
        tempLabel.hidden = true
        
        self.circle.fillColor = fretBoardColor
        self.circleLabel.text = ""
        
        for each in self.touchableNodes{
            each.userInteractionEnabled = true
        }
        
        timerCounter = timerLength
        timerValue.text = "TIMER: " + String(timerCounter)
        
        
    }
    
    func gameStopped(inGame:Bool = true ){
            self.stopTicking()
            for each in self.touchableNodes{
                each.userInteractionEnabled = false
            }
        
        if inGame{
            
            pick.hidden = true
            tempLabel.hidden = true
            
            self.tempLabel.fontSize = tempLabelSize
            self.tempLabel.fontColor = redColor
            self.tempLabel.position.y = 0
            self.tempLabel.text = "TIME'S UP!"
            tempLabel.hidden = false
            self.circle.fillColor = fretBoardColor
            self.circle.strokeColor = fretBoardColor
            self.circleLabel.text = ""
            getNewCoords()
            startButton.hidden = false
        }
    }


    func updateHighScore(){
        
        memoryStore(currentHighScore, key: highScoreKey)

    }
    
    func retrieveHighScore() -> Int{
        
        let retrievedValue = memoryRetrieve(highScoreKey)
        
        if retrievedValue == -1 {
            return 0
        }else {
            return retrievedValue
        }

    }
    
    override func update(currentTime: CFTimeInterval) {
        // Called before each frame is rendered
        
        guard let lastTickLocal = lastTick else{
            return
        }
        
        let timePassed = lastTickLocal.timeIntervalSinceNow * -1000.0
        
        if timePassed > tickLengthMillis {
            lastTick = NSDate()
            tick?()
        }
    }
}
