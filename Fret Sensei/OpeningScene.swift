//
//  OpeningScene.swift
//  Fret Sensei
//
//  Created by Lubin Tan on 2/3/16.
//  Copyright © 2016 Lubz. All rights reserved.
//

import SpriteKit

class OpeningScene:SKScene {
    let background:SKShapeNode = SKShapeNode(rect: CGRect(x: CGFloat(0), y: CGFloat(0), width: screenSize.width, height: screenSize.height))

    
        required init(coder aDecoder: NSCoder){
            fatalError("NSCoder not supported")
        }
    
        override init(size: CGSize){
            super.init(size: size)
            self.userInteractionEnabled = false
        }
    
    
    
    func createBackground(completion: () -> ()){
        background.fillColor = bgColor
        background.strokeColor = bgColor
        background.fillTexture = SKTexture(imageNamed: "background-plain")
        background.strokeTexture = SKTexture(imageNamed: "background-plain")
        addChild(background)
        background.runAction(SKAction.fadeOutWithDuration(0))
        background.runAction(SKAction.fadeInWithDuration(2))
        drawTitle(completion)
        
        
    }
    
    func drawTitle(completion: () -> ()){
        
        drawLetter( "F", origPos: CGPoint(x: 0.08 * screenSize.width, y:0.3 * screenSize.height) , completion: completion)
        drawLetter( "R", origPos: CGPoint(x: 2 * 0.08 * screenSize.width, y:0.4 * screenSize.height) , completion: completion)
        drawLetter( "E", origPos: CGPoint(x: 3 * 0.08 * screenSize.width, y:0.3 * screenSize.height) , completion: completion)
        drawLetter( "T", origPos: CGPoint(x: 4 * 0.08 * screenSize.width, y:0.4 * screenSize.height) , completion: completion)
        
        drawLetter( "S", origPos: CGPoint(x: 6 * 0.08 * screenSize.width, y:0.3 * screenSize.height) , completion: completion)
        drawLetter( "E", origPos: CGPoint(x: 7 * 0.08 * screenSize.width, y:0.4 * screenSize.height) , completion: completion)
        drawLetter( "N", origPos: CGPoint(x: 8 * 0.08 * screenSize.width, y:0.3 * screenSize.height) , completion: completion)
        drawLetter( "S", origPos: CGPoint(x: 9 * 0.08 * screenSize.width, y:0.4 * screenSize.height) , completion: completion)
        drawLetter( "E", origPos: CGPoint(x: 10 * 0.08 * screenSize.width, y:0.3 * screenSize.height) , completion: completion)
        drawLetter( "I", origPos: CGPoint(x: 11 * 0.08 * screenSize.width, y:0.4 * screenSize.height) , completion: completion)
        
        
    }

    
    func drawLetter(text: String, origPos: CGPoint, completion: () -> ()){
    let f = SKLabelNode(text: text)
    f.fontName = "Baskerville-Bold"
    f.fontColor = fretBoardColor
    f.position =  origPos
        
    let scalingFactor = 0.07 * screenSize.width / f.frame.width
    f.fontSize *= scalingFactor
    
    f.verticalAlignmentMode = .Center
    
    background.addChild(f)
    
    var numFrames: Int = 63
    
    //frames out of sync with sound on iPhone 6S Plus
    if deviceModel.containsString("iPhone8,2"){
        numFrames = 76
    }
    
    
    let duration = 0.02
        
    var positionActions: Array<SKAction>! = []
    
    for _ in 1..<numFrames {
    let x = origPos.x + CGFloat(random()%Int(screenSize.width * 0.06))
    let y = origPos.y + CGFloat(random()%Int(screenSize.width * 0.06))
    
    positionActions.append(SKAction.moveTo(CGPoint(x: x,y: y), duration: duration))
    }
    
    
    
    
    var rotationActions: Array<SKAction>! = []
    
    for i in 1..<numFrames {
        let rad = CGFloat(random()%10) / 100
        
        if i%2 == 0 {
        rotationActions.append(SKAction.rotateByAngle(rad, duration: duration))
        } else{
        rotationActions.append(SKAction.rotateByAngle(rad * -1, duration: duration))
        }
        
    }
    
    let randomRadius = CGFloat(random() % Int(screenSize.width * 0.5))
    let goLeft = Bool(random()%2)
    let point = CGPoint(x: f.position.x + (goLeft ? -randomRadius : randomRadius), y: f.position.y)
    var startAngle = CGFloat(M_PI)
    var endAngle = startAngle * 2
    if goLeft{
        endAngle = startAngle
        startAngle = 0
        }

    let arcPath = UIBezierPath(arcCenter: point, radius: randomRadius, startAngle: startAngle, endAngle: endAngle, clockwise: goLeft)
    let arcAction = SKAction.followPath(arcPath.CGPath, asOffset: false, orientToPath: true, duration: 1.4)
    arcAction.timingMode = .EaseOut
    
    
        
    positionActions.append(arcAction)
    rotationActions.append(SKAction.waitForDuration(0.8))
    let moveAction = SKAction.sequence(positionActions)
    moveAction.timingMode = .EaseIn
    let angleAction = SKAction.sequence(rotationActions)
    angleAction.timingMode = .EaseIn
    
    let fader = SKAction.fadeOutWithDuration(0.4)
    fader.timingMode = .EaseOut
    
        
    if soundOn {f.runAction(playJingle)}
    f.runAction(moveAction)
    f.runAction(angleAction, completion: {self.background.runAction(fader, completion: completion)})
    }
    
}

