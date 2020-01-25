


import SpriteKit

var tuningKnobIndex: Int = -1

class SettingsButton: SKNode {
    var noteLabel: SKLabelNode
    var rangeRect: SKShapeNode
    
    var actionRight: () -> Void
    var actionLeft: () -> Void
    var actionRelease: () -> Void
    var touchStartPoint:CGPoint?
    
    var buffer = 0.005 * screenSize.width
    
    
    var rightSwipe = false
    var leftSwipe = false
    
    
    init(defaultText: String, size: CGSize, buttonRight: () -> Void, buttonLeft: () -> Void, buttonRelease: () -> Void) {
        
        
        noteLabel = SKLabelNode(text: defaultText)
        noteLabel.fontName = "AvenirNext-Bold"
        rangeRect = SKShapeNode(rectOfSize: size)
        rangeRect.fillColor = UIColor.clearColor()
        rangeRect.strokeColor = UIColor.clearColor()
        
        actionRight = buttonRight
        actionLeft = buttonLeft
        actionRelease = buttonRelease
        
        

        
        super.init()
        
        rangeRect.addChild(noteLabel)
        noteLabel.horizontalAlignmentMode = .Center
        noteLabel.verticalAlignmentMode = .Center
        
        self.userInteractionEnabled = true
        self.addChild(rangeRect)
        
            }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchStartPoint = touches.first?.locationInNode(self)
        selfTouchBegan()
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        if let touch = touches.first{
            
            let location = touch.locationInNode(self)
            
            
            if ((location.x - touchStartPoint!.x) > buffer) &&  !rightSwipe{
                if soundOn {self.runAction(playClick)}
                rightSwipe = true
                leftSwipe = false
                actionRight()
                selfRightSwipe()
                
            } else if ((touchStartPoint!.x - location.x) > buffer)  && !leftSwipe{
                if soundOn {self.runAction(playClick)}
                rightSwipe = false
                leftSwipe = true
                actionLeft()
                selfLeftSwipe()
            }
        }
    }
    
//    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
//    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        rightSwipe = false
        leftSwipe = false
        actionRelease()
        selfTouchEnd()
    }
    
    func selfTouchBegan(){}
    func selfRightSwipe(){}
    func selfLeftSwipe(){}
    func selfTouchEnd(){}
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TuningKnobButton: SettingsButton{
    let stringIndex:Int
    
    init(defaultText: String, size: CGSize, buttonRight: () -> Void, buttonLeft: () -> Void, buttonRelease: () -> Void, stringIndex: Int) {
        
        self.stringIndex = stringIndex
        super.init(defaultText: defaultText, size: size, buttonRight: buttonRight, buttonLeft: buttonLeft, buttonRelease: buttonRelease)
    }

    override func selfTouchBegan() {
        tuningKnobIndex = self.stringIndex
    }
    
    override func selfLeftSwipe() {
        let currentTuning = tunings[self.stringIndex].rawValue
        tunings[self.stringIndex] = note(rawValue: (currentTuning + 11)%12)!
        self.noteLabel.text = getTuningLabel(self.stringIndex)
        

    }
    
    override func selfRightSwipe() {
        let currentTuning = tunings[self.stringIndex].rawValue
        tunings[self.stringIndex] = note(rawValue: (currentTuning + 1)%12)!
        self.noteLabel.text = getTuningLabel(self.stringIndex)
        
        
    }
    
    override func selfTouchEnd() {
        storeTunings()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}