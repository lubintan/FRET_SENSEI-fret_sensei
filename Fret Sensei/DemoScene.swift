//
//  DemoScene.swift
//  Fret Sensei
//
//  Created by Lubin Tan on 16/3/16.
//  Copyright © 2016 Lubz. All rights reserved.
//

import Foundation
import SpriteKit


class Finger: SKNode {
    var withShadow = SKSpriteNode(imageNamed: "fingerWithShadow")
    var noShadow = SKSpriteNode(imageNamed: "fingerNoShadow")
    
    init(size: CGSize) {
        
        super.init()
        
        withShadow.size = size
        noShadow.size = CGSize(width: 0.6 * size.width, height: 0.8 * size.height)
        withShadow.anchorPoint = CGPoint(x: 0.5, y: 0.8)
        withShadow.hidden = true
        noShadow.anchorPoint = CGPoint(x: 0.5, y: 0.8)
        noShadow.hidden = true
        self.addChild(withShadow)
        self.addChild(noShadow)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func up(){
        withShadow.hidden = false
        noShadow.hidden = true
    }
    
    func down(){
        withShadow.hidden = true
        noShadow.hidden = false
        
    }
}

class DemoScene: GameScene{
    var pointer:Finger!
    var sequence1 :SKAction!
    var instructionLabel: SKLabelNode = SKLabelNode(text: "")
    let selfNumFrets = 12
    let selfTunings = [note.E, note.A, note.D, note.G, note.B, note.E]
    var homeButton: SimpleImageButton!
    
    override init(size: CGSize) {
        
        
        super.init(size: size)
        
        self.userInteractionEnabled = true

        
        
        drawBackground()
        drawHomeButton()
        drawUserInput()
        drawPointerAndLabel()
    }
    
    func runAnimation(completionFunc:(() -> ())) {
        
        self.pointer.removeAllActions()
        self.instructionLabel.removeAllActions()
        self.background.removeAllChildren()
        
        if self.homeButton.parent == nil {self.background.addChild(self.homeButton)}
        
        
        
        let openingLabel = SKLabelNode(text: "How To Play")
        openingLabel.fontColor = dotColor
        openingLabel.fontSize = screenSize.width / 5
        openingLabel.fontName =  "AvenirNextCondensed-BoldItalic"
        openingLabel.position = CGPoint(x: background.frame.midX, y:  background.frame.midY)
        openingLabel.verticalAlignmentMode = .Center
        openingLabel.horizontalAlignmentMode = .Center
        background.addChild(openingLabel)
        let faderOuter = SKAction.fadeOutWithDuration(1.5)
        faderOuter.timingMode = .EaseOut
        let openingAction = SKAction.sequence([SKAction.waitForDuration(0.8), faderOuter])
        
        
        
        openingLabel.runAction(openingAction,completion: {
            
            
            let fadingTiming = 0.001
            let fadeIn = SKAction.fadeInWithDuration(fadingTiming)
            self.userInput.runAction(fadeIn)
            
            if self.userInput.parent == nil {self.background.addChild(self.userInput)}
            
            
            //Reset user input area
            self.startButton.hidden = false
            self.circle.fillColor = fretBoardColor
            self.circle.strokeColor = fretBoardColor
            self.circleLabel.text = ""
            
            self.noteCoordinates = self.drawFretBoard(self.selfNumFrets, selfTunings: self.selfTunings)
            if (self.pointer.parent == nil) && (self.instructionLabel.parent == nil) {self.drawPointerAndLabel()}
            
            self.runAction(SKAction.waitForDuration(1), completion:{
                self.animationSequence1({
                    self.animationSequence2({
                        self.animationSequence3({
                            self.animationSequence4({
                                self.animationSequence5({
                                    self.animationSequnce6({
                                        completionFunc()
                                        //insert next animation sequence here
                                    })
                                    
                                })
                                
                            })
                        })
                    })
                })
            })
        })
        
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawHomeButton(){
        homeButton = SimpleImageButton(imageFile: "homeButton", size: CGSize(width: statusHeight, height: statusHeight), buttonAction: homeTask)
        homeButton.position = CGPoint(x: background.frame.maxX - (0.05 * screenSize.width), y: background.frame.maxY - (0.08 * screenSize.height))
        background.addChild(homeButton)
    }
    
    
    func drawPointerAndLabel(){
        pointer = Finger(size: CGSize(width: 0.15 * screenSize.width, height: 3.15 * 0.15 * screenSize.width))
        pointer.position = CGPoint(x: self.circle.frame.maxX + (0.05 * screenSize.width), y: self.circle.frame.minY + (0.05 * screenSize.height) )
        pointer.up()
        pointer.zPosition = 1
        background.addChild(pointer)
        
        instructionLabel.text = ""
        instructionLabel.position = CGPoint(x: screenSize.width / 2.0, y: fretBoard.frame.maxY)
        instructionLabel.verticalAlignmentMode = .Center
        instructionLabel.horizontalAlignmentMode = .Center
        instructionLabel.zPosition = 5
        instructionLabel.fontSize = 40
        instructionLabel.fontName = "AvenirNextCondensed-BoldItalic"
        instructionLabel.fontColor = dotColor
        background.addChild(instructionLabel)
        
        //disable butons
        startButton.userInteractionEnabled = false
        
    }
    
    
    func animationSequence1(completion: () -> ()){

        
        //Label Thread
        let fadingTiming = 0.3
        
        instructionLabel.text = "Tap the Play button to begin."
        
        let scalingFactor = 0.8 * screenSize.width / instructionLabel.frame.width
        instructionLabel.fontSize *= scalingFactor
        let transition1Label = SKAction.fadeInWithDuration(fadingTiming)
        transition1Label.timingMode = .EaseOut
        let transition1Label2 = SKAction.fadeInWithDuration(fadingTiming)
        transition1Label2.timingMode = .EaseOut
        
        instructionLabel.runAction(transition1Label, completion: {
            self.instructionLabel.runAction(SKAction.waitForDuration(1), completion: {
                self.instructionLabel.runAction(SKAction.fadeOutWithDuration(fadingTiming), completion:{
                self.instructionLabel.text = "Timer is set to " + String(timerLength) + " seconds."
                    self.instructionLabel.runAction(transition1Label2, completion:{
                        self.instructionLabel.runAction(SKAction.waitForDuration(1), completion:{
                            self.instructionLabel.runAction(SKAction.fadeOutWithDuration(fadingTiming), completion: completion)
                            
                        })
                    })
                })
            })
        })
        

        
        //Pointer/Finger Thread
        let transition1pointer = SKAction.moveTo(CGPoint(x: circle.position.x, y: circle.frame.minY + (0.05 * screenSize.height)), duration: 1)
        transition1pointer.timingMode = .EaseOut
        pointer.runAction(transition1pointer, completion: {
            self.pointer.down()
            if soundOn {self.runAction(playClick)}
            self.startButton.hidden = true
            self.pointer.runAction(SKAction.waitForDuration(0.5), completion: {
                self.generatePick(1, fret: 2)
                self.pointer.runAction(SKAction.waitForDuration(0.5), completion: {
                    self.pointer.up()
                })
            })
        })
        
 
        
        
    }
    
    func animationSequence2(completion: () -> ()){
        
        //Label Thread
        let fadingTiming = 0.3
        instructionLabel.text = "Tap and release to select answer."
        let scalingFactor = 0.8 * screenSize.width / instructionLabel.frame.width
        instructionLabel.fontSize *= scalingFactor
        let transition2Label = SKAction.fadeInWithDuration(fadingTiming)
        transition2Label.timingMode = .EaseOut
        
        instructionLabel.runAction(transition2Label, completion:{
            self.instructionLabel.runAction(SKAction.waitForDuration(1), completion: {
                self.instructionLabel.runAction(SKAction.fadeOutWithDuration(fadingTiming))
            })
        })
        
        
        //Pointer/Label Thread
        let transition2pointer = SKAction.moveTo(CGPoint(x: self.touchableNodes[1].position.x, y: self.touchableNodes[1].position.y - 15), duration: 1.0)
        transition2pointer.timingMode = .EaseOut
        
        pointer.runAction(transition2pointer, completion: {
            self.pointer.down()
            if soundOn {self.runAction(playClick)}
            self.circleLabel.text = "B"
            self.pointer.runAction(SKAction.waitForDuration(1), completion: {
                self.pointer.up()
                self.circle.fillColor = greenColor
                self.circle.strokeColor = greenColor
                if soundOn {self.circle.runAction(playCorrect)}
                self.pointer.runAction(SKAction.waitForDuration(1), completion: {
                    self.circleLabel.text = ""
                    self.circle.strokeColor = fretBoardColor
                    self.circle.fillColor = fretBoardColor
                    self.pointer.runAction(SKAction.waitForDuration(0.1), completion:{
                        self.generatePick(1, fret: 1)
                        self.pointer.runAction(SKAction.waitForDuration(1), completion: completion)
                        })
                    })
                })
            })
        
        
    }
    
    func animationSequence3(completion: () -> ()){
        
        //Label Thread
        let fadingTiming = 0.2
        instructionLabel.text = "Tap, slide left and release for flats."
        let scalingFactor = 0.8 * screenSize.width / instructionLabel.frame.width
        instructionLabel.fontSize *= scalingFactor
        let transition3Label = SKAction.fadeInWithDuration(fadingTiming)
        transition3Label.timingMode = .EaseOut
        
        instructionLabel.runAction(transition3Label, completion:{
            self.instructionLabel.runAction(SKAction.waitForDuration(2.0), completion: {
                self.instructionLabel.runAction(SKAction.fadeOutWithDuration(fadingTiming))
            })
        })
        
        
        //Pointer/Label Thread
        let transition3pointer = SKAction.moveTo(CGPoint(x: pointer.position.x - (0.1 * screenSize.width), y: pointer.position.y), duration: 1)
        let transition3pointer2 = SKAction.moveTo(CGPoint(x: pointer.position.x - (0.1 * screenSize.width), y: pointer.position.y), duration: 1)
        transition3pointer2.timingMode = .EaseOut
        
        pointer.runAction(SKAction.waitForDuration(3), completion:{
            self.pointer.down()
            if soundOn {self.runAction(playClick)}
            self.circleLabel.text = "B"
            self.pointer.runAction(SKAction.waitForDuration(0.5), completion: {
                self.pointer.runAction(transition3pointer, completion: {
                    if soundOn {self.runAction(playClick)}
                    self.circleLabel.text = "Bb"
//                    self.pointer.runAction(transition3pointer2, completion: {
                        //                self.circleLabel.text = "Bb"
                        self.pointer.runAction(SKAction.waitForDuration(1), completion: {
                            self.pointer.up()
                            self.circle.fillColor = greenColor
                            self.circle.strokeColor = greenColor
                            if soundOn {self.circle.runAction(playCorrect)}
                            self.pointer.runAction(SKAction.waitForDuration(1), completion: {
                                self.circleLabel.text = ""
                                self.circle.strokeColor = fretBoardColor
                                self.circle.fillColor = fretBoardColor
                                self.pointer.runAction(SKAction.waitForDuration(0.7), completion:{
                                    self.generatePick(2, fret: 5)
                                    completion()
                                })
//                            })
                        })
                    })
                })
            })
        })
    }
    
    func animationSequence4(completion: () -> ()) {
        //Label Thread
        let fadingTiming = 0.3
        instructionLabel.text = "Tap, slide right and release for sharps."
        let scalingFactor = 0.8 * screenSize.width / instructionLabel.frame.width
        instructionLabel.fontSize *= scalingFactor
        let transition4Label = SKAction.fadeInWithDuration(fadingTiming)
        transition4Label.timingMode = .EaseOut
        
        instructionLabel.runAction(transition4Label, completion:{
            self.instructionLabel.runAction(SKAction.waitForDuration(2), completion: {
                self.instructionLabel.runAction(SKAction.fadeOutWithDuration(fadingTiming))
            })
        })
        
        
        //Pointer/Label Thread
        let transition4pointer = SKAction.moveTo(CGPoint(x: self.touchableNodes[1].position.x, y: self.touchableNodes[1].position.y - 15), duration: 1.0)
        let transition4pointer2 = SKAction.moveTo(CGPoint(x: self.touchableNodes[1].position.x + (0.1 * screenSize.width), y: pointer.position.y), duration: 1)
        let transition4pointer3 = SKAction.moveTo(CGPoint(x: self.touchableNodes[1].position.x + (0.1 * screenSize.width), y: pointer.position.y), duration: 1)
        transition4pointer3.timingMode = .EaseOut
        
        pointer.runAction(transition4pointer, completion:{
            self.pointer.runAction(SKAction.waitForDuration(1), completion:{
                self.pointer.down()
                if soundOn {self.runAction(playClick)}
                self.circleLabel.text = "B"
                self.pointer.runAction(SKAction.waitForDuration(0.5), completion: {
                    self.pointer.runAction(transition4pointer2, completion: {
                        if soundOn {self.runAction(playClick)}
                        self.circleLabel.text = "C"
//                        self.pointer.runAction(transition4pointer3, completion: {
                            self.pointer.runAction(SKAction.waitForDuration(1), completion: {
                                self.pointer.up()
                                self.circle.fillColor = redColor
                                self.circle.strokeColor = redColor
                                if soundOn {self.circle.runAction(playWrong)}
                                completion()
                            })
//                        })
                    })
                })
            })
        })
    }
    
    func animationSequence5(completion: () -> ()) {
        //Label Thread
        let fadingTiming = 0.3
        instructionLabel.text = "If incorrect, the correct answer will be displayed in red."
        let scalingFactor = 0.8 * screenSize.width / instructionLabel.frame.width
        instructionLabel.fontSize *= scalingFactor
        let transition5Label = SKAction.fadeInWithDuration(fadingTiming)
        transition5Label.timingMode = .EaseOut
        tempLabel.text = "G"
        tempLabel.color = redColor
        
        instructionLabel.runAction(transition5Label, completion:{
            self.tempLabel.hidden = false
            self.instructionLabel.runAction(SKAction.waitForDuration(2), completion: {
                self.instructionLabel.runAction(SKAction.fadeOutWithDuration(fadingTiming), completion: completion)
            })
        })
    }
        
    func animationSequnce6(completion: () -> ()) {
        //Label Thread
        
        let fadingTiming = 1.0
        let fadeOut = SKAction.fadeOutWithDuration(fadingTiming)
        fadeOut.timingMode = .EaseOut
        
        let fasterFadingTiming = 0.5
        let fasterFadeIn = SKAction.fadeInWithDuration(fasterFadingTiming)
        fasterFadeIn.timingMode = .EaseOut
        
        let label1 = SKLabelNode(text: "")
        let label2 = SKLabelNode(text: "")
        let label3 = SKLabelNode(text: "")
        
        label1.position = CGPoint(x: screenSize.width / 2.0, y: screenSize.height * 0.8)
        label2.position = CGPoint(x: screenSize.width / 2.0, y: screenSize.height * 0.7)
        label3.position = CGPoint(x: screenSize.width / 2.0, y: screenSize.height * 0.5)
        
        label1.verticalAlignmentMode = .Center
        label1.horizontalAlignmentMode = .Center
        label2.verticalAlignmentMode = .Center
        label2.horizontalAlignmentMode = .Center
        label3.verticalAlignmentMode = .Center
        label3.horizontalAlignmentMode = .Center
        
        
        label1.fontName = "AvenirNextCondensed-BoldItalic"
        label2.fontName = "AvenirNextCondensed-BoldItalic"
        label3.fontName = "AvenirNextCondensed-BoldItalic"
        
        label1.fontColor = dotColor
        label2.fontColor = dotColor
        label3.fontColor = dotColor
        
        background.addChild(label1)
        background.addChild(label2)
        background.addChild(label3)
        
        userInput.runAction(fadeOut)
        circleLabel.text = ""
        fretBoard.runAction(fadeOut)
        pointer.runAction(fadeOut, completion:{
            label1.text = "Score bonus points with consecutive correct answers."
            let label1ScalingFactor = screenSize.width * 0.9 / label1.frame.width
            label1.fontSize *= label1ScalingFactor
            label1.runAction(fasterFadeIn, completion:{
                
                label2.text = "(applies only to 3 or more different tunings.)"
                let label2ScalingFactor = screenSize.width * 0.9 / label2.frame.width
                label2.fontSize *= label2ScalingFactor * 0.5
                label2.runAction(fasterFadeIn, completion: {
                    
                    label3.text = "Change tunings, number of strings and frets in \"Settings\" page."
                    let label3ScalingFactor = screenSize.width * 0.9 / label3.frame.width
                    label3.fontSize *= label3ScalingFactor
                    label3.runAction(fasterFadeIn, completion:{
                        self.runAction(SKAction.waitForDuration(2), completion:completion)
                    })
                })
            })
        })
    }
    
    func generatePick(string:Int, fret:Int){
        
        self.pick.position = self.noteCoordinates[string][fret].centerPoint
        pick.hidden = false
        
    }
    
    
}