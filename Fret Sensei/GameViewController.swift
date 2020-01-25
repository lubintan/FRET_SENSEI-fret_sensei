//
//  GameViewController.swift
//  Fret Sensei
//
//  Created by Lubin Tan on 10/2/16.
//  Copyright (c) 2016 Lubz. All rights reserved.
//

import UIKit
import SpriteKit


var skView:SKView!
let playModeFrameInterval = 5

let playClick = SKAction.playSoundFileNamed("fretSenseiClick.m4a", waitForCompletion: false)
let playCorrect = SKAction.playSoundFileNamed("fretSenseiCorrect.m4a", waitForCompletion: false)
let playWrong = SKAction.playSoundFileNamed("fretSenseiWrong.m4a", waitForCompletion: false)
let playJingle = SKAction.playSoundFileNamed("fretSenseiJingle.m4a", waitForCompletion: false)

class GameViewController: UIViewController {
    
    var gameScene: GameScene!
    var openingScene:OpeningScene!
    var settingScene:SettingScene!
    
    var homeScene:HomeScene!
    var accScene:AccScene!
    var demoScene:DemoScene!
    let firstTimeKey = "firstTime"

    


    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //retrieve tuning
        retrieveTunings()
        
        let tempNumFrets = memoryRetrieve(kFret)
        if tempNumFrets != -1{
            numFrets = tempNumFrets
        }
        
        skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        
        skView.userInteractionEnabled = false

        skView.multipleTouchEnabled = false
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = false
        
        
        openingScene = OpeningScene(size: skView.bounds.size)
        
        /* Set the scale mode to scale to fit the window */
        openingScene.scaleMode = .AspectFill
        
        skView.presentScene(openingScene)
        
//        demoScene = DemoScene(size: skView.bounds.size)
//        demoScene.scaleMode = .AspectFill
//        demoScene.homeAction = {memoryStore(1, key: self.firstTimeKey); self.transToHome()}
        
        
//        homeScene = HomeScene(size: skView.bounds.size)
//        homeScene.scaleMode = .AspectFill
//        homeScene.playAction = transToPlay
//        homeScene.setAction = transToSet
//        homeScene.achAction = transToAcc
//        homeScene.howAction = transToHow
//        homeScene.fbkAction = {Instabug.invoke()}
//        homeScene.createButtons()
        
        settingScene = SettingScene(size: skView.bounds.size)
        settingScene.scaleMode = .AspectFill
        settingScene.homeAction = {self.transToHome()}
        settingScene.playAction = {self.transToPlay()}
        
        gameScene = GameScene(size: skView.bounds.size)
        gameScene.scaleMode = .AspectFill
        gameScene.noteCoordinates = gameScene.requiredDrawing()
        gameScene.tick = didTick
        gameScene.settingsAction = {self.transToSet(); }
        gameScene.homeAction = {self.transToHome(); }
        
//        accScene = AccScene(size: skView.bounds.size)
//        accScene.scaleMode = .AspectFill
//        accScene.homeAction = transToHome
//        accScene.playAction = transToPlay
//        accScene.createLabels()
  
        skView.frameInterval = 1
        
        openingScene.didMoveToView(skView)

        openingScene.createBackground({
            
            
            if memoryRetrieve(self.firstTimeKey) != 1{
                self.transToHow()
                
            }else{
                self.transToHome()
            }
            
            self.openingScene = nil
            
        })

        
        skView.userInteractionEnabled = true
        
    }
    
    func transToAcc(){
        skView.frameInterval = 1
        accScene = AccScene(size: skView.bounds.size)
        accScene.scaleMode = .AspectFill
        accScene.homeAction = {self.transToHome(); self.accScene = nil}
        accScene.playAction = {self.transToPlay(); self.accScene = nil}
        accScene.createLabels()
        accScene.accColors()
        
        
        
        let trans = SKTransition.flipHorizontalWithDuration(0.8)
        skView.presentScene(self.accScene, transition: trans)
        accScene.runAction(SKAction.waitForDuration(0.8), completion: {skView.frameInterval = playModeFrameInterval})
        
        
        
    }
    
    func transToPlay(){

//        gameScene = GameScene(size: skView.bounds.size)
//        gameScene.scaleMode = .AspectFill
//        gameScene.noteCoordinates = gameScene.requiredDrawing()
//        gameScene.tick = didTick
//        gameScene.settingsAction = {self.transToSet(); self.gameScene = nil}
//        gameScene.homeAction = {self.transToHome(); self.gameScene = nil}
        
        skView.frameInterval = 1
        
        gameScene.fretBoard.removeFromParent()
        gameScene.noteCoordinates = gameScene.drawFretBoard(completion: {skView.frameInterval = playModeFrameInterval})
        gameScene.noteCoordinatesCopy = gameScene.noteCoordinates
        
        gameScene.getNewCoords()
        
        checkIfTuningsDifferent()
        
        gameScene.startButton.hidden = false
        gameScene.scoreValue.text = "SCORE: "+"0"
        gameScene.timerValue.text = "TIMER: " + String(timerLength)

        
        let trans = SKTransition.fadeWithDuration(1)
        skView.presentScene(self.gameScene, transition: trans)
    }
    
    func transToSet(){
        skView.frameInterval = 1
//        settingScene = SettingScene(size: skView.bounds.size)
//        settingScene.scaleMode = .AspectFill
//        settingScene.homeAction = {self.transToHome(); self.settingScene = nil}
//        settingScene.playAction = {self.transToPlay(); self.settingScene = nil}
        
        if gameScene != nil {gameScene.gameStopped(false)}

        
        
        let trans = SKTransition.flipHorizontalWithDuration(0.8)
        skView.presentScene(self.settingScene, transition: trans)
        settingScene.runAction(SKAction.waitForDuration(0.8), completion: {skView.frameInterval = playModeFrameInterval})
        
        
    }
    
    func transToHome(){
        skView.frameInterval = 1
        
        homeScene = HomeScene(size: skView.bounds.size)
        homeScene.scaleMode = .AspectFill
        homeScene.playAction = {self.transToPlay(); self.homeScene = nil}
        homeScene.setAction = {self.transToSet(); self.homeScene = nil}
        homeScene.achAction = {self.transToAcc(); self.homeScene = nil}
        homeScene.howAction = {self.transToHow(); self.homeScene = nil}
        homeScene.fbkAction = {Instabug.invoke()}
        homeScene.createButtons()
        
        
        if gameScene != nil {gameScene.gameStopped(false)}
        
        
        
        skView.presentScene(homeScene, transition: SKTransition.flipHorizontalWithDuration(0.8))
        homeScene.animateButtons({skView.frameInterval = playModeFrameInterval})
        
    }
    
    func transToHow(){
        
        skView.frameInterval = 1
        
        demoScene = DemoScene(size: skView.bounds.size)
        demoScene.scaleMode = .AspectFill
        demoScene.homeAction = {memoryStore(1, key: self.firstTimeKey); self.transToHome(); self.demoScene = nil}
        
        skView.presentScene(demoScene, transition: SKTransition.flipHorizontalWithDuration(0.8))
        demoScene.runAnimation({self.demoScene.homeAction!()})
    }
    

    func didTick() {
        if !(timerCounter <= 1){
            
            timerCounter -= 1
            gameScene.timerValue.text = "TIMER: " + String(timerCounter)
            
        } else {
            gameScene.gameStopped()
            gameScene.timerValue.text = "TIMER: 0"
        }
        
        
        
    }


    
    override func shouldAutorotate() -> Bool {
        return true
    }

    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return .Landscape
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
}
