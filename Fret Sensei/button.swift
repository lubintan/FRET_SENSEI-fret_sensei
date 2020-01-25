//
//  button.swift
//  Fret Sensei
//
//  Created by Lubin Tan on 27/2/16.
//  Copyright © 2016 Lubz. All rights reserved.
//


import SpriteKit

class TriangleButton: SKNode{
    var action: () -> Void
    
    
    init(size: CGSize, buttonAction: () -> Void) {

        
        let triangle = SKSpriteNode(imageNamed: "triangle")
        triangle.size.width = size.width
        triangle.size.height = size.height 
        
        action = buttonAction
        super.init()
        
        self.userInteractionEnabled = true
        self.addChild(triangle)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if soundOn {self.runAction(playClick)}
        action()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SimpleImageButton: SKNode {
    var imageButton: SKSpriteNode!
    var rangeRect: SKShapeNode
    
    var action: () -> Void
    
    let buffer = CGFloat(10.0)
    
    
    init(imageFile: String, size: CGSize, buttonAction: () -> Void) {
        
        
        imageButton = SKSpriteNode(imageNamed: imageFile)
        rangeRect = SKShapeNode(rectOfSize: size)
        rangeRect.fillColor = UIColor.clearColor()
        rangeRect.strokeColor = UIColor.clearColor()
        
        action = buttonAction
        super.init()

       imageButton.position = CGPoint(x: rangeRect.frame.midX, y: rangeRect.frame.midY)
       imageButton.setScale(rangeRect.frame.height/imageButton.frame.height)
       rangeRect.addChild(imageButton)
        
        self.userInteractionEnabled = true
        self.addChild(rangeRect)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        action()
        if soundOn {self.runAction(playClick)}
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class SimpleButton: SKNode {
    var noteLabel: SKLabelNode
    var rangeRect: SKShapeNode
    
    var action: () -> Void
    
    let labelName:String
    let buffer = CGFloat(10.0)
    
    
    init(defaultText: String, size: CGSize, buttonAction: () -> Void) {
        
        self.labelName = defaultText
        
        noteLabel = SKLabelNode(text: labelName)
        noteLabel.fontName = "AvenirNextCondensed-DemiBold"
        rangeRect = SKShapeNode(rectOfSize: size)
        rangeRect.fillColor = UIColor.clearColor()
        rangeRect.strokeColor = UIColor.clearColor()
        
        action = buttonAction
        super.init()
        rangeRect.addChild(noteLabel)
        noteLabel.horizontalAlignmentMode = .Center
        noteLabel.verticalAlignmentMode = .Center
        
        self.userInteractionEnabled = true
        self.addChild(rangeRect)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if soundOn {self.runAction(playClick)}
        action()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class SKButton: SKNode {
    var noteLabel: SKLabelNode
    var rangeRect: SKShapeNode
    var noteIndex: Int
    
    var action: () -> Void
    var action2: () -> Void
    var touchStartPoint:CGPoint?
    
    let labelName:String
    let buffer = 0.07 * screenSize.width
    
    var counter = 10
    
    
    init(defaultText: String, noteIndex: Int, size: CGSize, buttonAction: () -> Void, buttonRelease: () -> Void) {
        
        self.labelName = defaultText
        self.noteIndex = noteIndex
        
        noteLabel = SKLabelNode(text: labelName)
        noteLabel.fontName = "AvenirNext-Bold"
        rangeRect = SKShapeNode(rectOfSize: size)
        rangeRect.fillColor = UIColor.clearColor()
        rangeRect.strokeColor = UIColor.clearColor()
        
        action = buttonAction
        action2 = buttonRelease
   
        super.init()
        
        rangeRect.addChild(noteLabel)
        noteLabel.horizontalAlignmentMode = .Center
        noteLabel.verticalAlignmentMode = .Center
        
        self.userInteractionEnabled = true
        self.addChild(rangeRect)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchStartPoint = touches.first?.locationInNode(self)
        noteSelected = note(rawValue: self.noteIndex)
        notePressed = noteSelected.noteName
        if soundOn {self.runAction(playClick)}
        counter = 0
        action()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first{
            
            let location = touch.locationInNode(self)
            
     
            if (abs(location.x - touchStartPoint!.x) < buffer){
                if soundOn {
                    if counter != 0{
                        self.runAction(playClick)
                        counter = 0
                    }
                }
                noteSelected = note(rawValue: self.noteIndex)
                notePressed = noteSelected.noteName
                
            } else if ((location.x - touchStartPoint!.x) > buffer) && !notePressed.containsString("#") {
                if soundOn {
                    if counter != 1 {
                        self.runAction(playClick)
                        counter = 1
                    }
                }
                noteSelected = note(rawValue: (self.noteIndex + 1)%12)
                
                if ((self.noteIndex == 3) || (self.noteIndex == 8)){
                    notePressed = noteSelected.noteName
                }else{
                    notePressed =  note(rawValue: self.noteIndex)!.noteName + "#"
                }
                
            } else if ((touchStartPoint!.x - location.x) > buffer)  && !notePressed.containsString("b"){
                if soundOn {
                    if counter != -1{
                        self.runAction(playClick)
                        counter = -1
                    }
                }
                noteSelected = note(rawValue: (self.noteIndex + 11)%12)
                
                if ((self.noteIndex == 4) || (self.noteIndex == 9)){
                    notePressed = noteSelected.noteName
                }else{
                    notePressed = note(rawValue: self.noteIndex)!.noteName + "b"
                }
            }
            action()
            
        }
        
    }
    
//    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
//    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        action2()
        counter = 10
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

