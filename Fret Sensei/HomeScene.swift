//
//  HomeScene.swift
//  Fret Sensei
//
//  Created by Lubin Tan on 11/3/16.
//  Copyright © 2016 Lubz. All rights reserved.
//

import Foundation
import SpriteKit

let circleDiameter = CGFloat(0.3 * screenSize.height)
let xLine1 = 0.25 * screenSize.width
let xLine2 = 0.5 * screenSize.width
let xLine3 = 0.75 * screenSize.width
let xLine1andHalf = 0.375 * screenSize.width
let xLine2andHalf = 0.625 * screenSize.width

let yLine1 = 0.3 * screenSize.height
let yLine2 = 0.7 * screenSize.height
let animationDuration = 0.4


class HomeScene: SKScene {
    let background:SKShapeNode = SKShapeNode(rect: CGRect(x: CGFloat(0), y: CGFloat(0), width: screenSize.width, height: screenSize.height))
    var playAction: (() -> ())?
    var setAction: (() -> ())?
    var achAction: (() -> ())?
    var howAction: (() -> ())?
    var fbkAction: (() -> ())?
    

    
    let playCircle = SKSpriteNode(imageNamed: "peach")
    let setCircle = SKSpriteNode(imageNamed: "peach")
    let achCircle = SKSpriteNode(imageNamed: "peach")
    let howCircle = SKSpriteNode(imageNamed: "peach")
    let fbkCircle = SKSpriteNode(imageNamed: "peach")
    
    
    let playAnimate = SKAction.moveTo(CGPoint(x: xLine1, y: yLine2), duration: animationDuration)
    let setAnimate = SKAction.moveTo(CGPoint(x: xLine2, y: yLine2), duration: animationDuration)
    let achAnimate = SKAction.moveTo(CGPoint(x: xLine3, y: yLine2), duration: animationDuration)
    let howAnimate = SKAction.moveTo(CGPoint(x: xLine1andHalf, y: yLine1), duration: animationDuration)
    let fbkAnimate = SKAction.moveTo(CGPoint(x: xLine2andHalf, y: yLine1), duration: animationDuration)

    
    
    required init(coder aDecoder: NSCoder){
        fatalError("NSCoder not supported")
    }
    
    override init(size: CGSize){
        super.init(size: size)
        self.userInteractionEnabled = false
        
        createBackground()
        

    }
    
    
    func createBackground(){
        background.fillColor = bgColor
        background.strokeColor = bgColor
        background.fillTexture = SKTexture(imageNamed: "background-fretsensei")
        background.strokeTexture = SKTexture(imageNamed: "background-fretsensei")
        addChild(background)
        
        
    }
    
    func createButtons(){
        
        playCircle.size = CGSize(width: circleDiameter , height: circleDiameter)
        setCircle.size = CGSize(width: circleDiameter , height: circleDiameter )
        achCircle.size = CGSize(width: circleDiameter , height: circleDiameter )
        howCircle.size = CGSize(width: circleDiameter , height: circleDiameter )
        fbkCircle.size = CGSize(width: circleDiameter , height: circleDiameter )
        
        playCircle.position = CGPoint(x: -100, y: yLine2)
        setCircle.position = CGPoint(x: xLine2, y: screenSize.height + 100)
        achCircle.position = CGPoint(x: xLine3, y: screenSize.height + 100)
        howCircle.position = CGPoint(x: xLine2, y: -100)
        fbkCircle.position = CGPoint(x: screenSize.width + 100, y: yLine1)
        

        
        let playButton = SimpleButton(defaultText: "play", size: CGSize(width: circleDiameter, height: circleDiameter), buttonAction: playAction!)
        let setButton = SimpleButton(defaultText: "settings", size: CGSize(width: circleDiameter, height: circleDiameter), buttonAction: setAction!)
        let achButton = SimpleButton(defaultText: "awards", size: CGSize(width: circleDiameter, height: circleDiameter), buttonAction: achAction!)
        let howButton = SimpleButton(defaultText: "demo", size: CGSize(width: circleDiameter, height: circleDiameter), buttonAction: howAction!)
        let fbkButton = SimpleButton(defaultText: "feedback", size: CGSize(width: circleDiameter, height: circleDiameter), buttonAction: fbkAction!)
        
        playButton.zPosition = 1
        setButton.zPosition = 1
        achButton.zPosition = 1
        howButton.zPosition = 1
        fbkButton.zPosition = 1
        
        playButton.noteLabel.fontSize = circleDiameter / 4
        setButton.noteLabel.fontSize = circleDiameter / 4
        achButton.noteLabel.fontSize = circleDiameter / 4
        howButton.noteLabel.fontSize = circleDiameter / 4
        fbkButton.noteLabel.fontSize = circleDiameter / 4
        
        
        playCircle.addChild(playButton)
        setCircle.addChild(setButton)
        achCircle.addChild(achButton)
        howCircle.addChild(howButton)
        fbkCircle.addChild(fbkButton)
        
        
        
        
        playAnimate.timingMode = .EaseOut
        setAnimate.timingMode = .EaseOut
        achAnimate.timingMode = .EaseOut
        howAnimate.timingMode = .EaseOut
        fbkAnimate.timingMode = .EaseOut
        
        background.addChild(playCircle)
        background.addChild(setCircle)
        background.addChild(achCircle)
        background.addChild(howCircle)
        background.addChild(fbkCircle)
        
        
        
    }
    
    func animateButtons(completion: (() -> ()) = {}){
        playCircle.position = CGPoint(x: -100, y: yLine2)
        setCircle.position = CGPoint(x: xLine2, y: screenSize.height + 100)
        achCircle.position = CGPoint(x: xLine3 + 100, y: screenSize.height + 100)
        howCircle.position = CGPoint(x: xLine1andHalf, y: -100)
        fbkCircle.position = CGPoint(x: screenSize.width + 100, y: yLine1)
        
        
        playCircle.runAction(playAnimate, completion: completion)
        setCircle.runAction(setAnimate)
        achCircle.runAction(achAnimate)
        howCircle.runAction(howAnimate)
        fbkCircle.runAction(fbkAnimate)
    }
}


//    func animateButtons(playCircle: SKNode, setCircle: SKNode, achCircle: SKNode, refCircle: SKNode, howCircle: SKNode,fbkCircle: SKNode, playAnimate: SKAction,setAnimate: SKAction,achAnimate: SKAction,refAnimate: SKAction,howAnimate: SKAction,fbkAnimate: SKAction)
