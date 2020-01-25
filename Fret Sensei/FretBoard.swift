//
//  FretBoard.swift
//  Fret Sensei
//
//  Created by Lubin Tan on 14/2/16.
//  Copyright © 2016 Lubz. All rights reserved.
//

import SpriteKit


class FretBoard {
    let tunings:Array<note>
    let noOfStrings:Int
    let noOfFrets:Int
    let xArray:Array<CGFloat>
    let yArray:Array<CGFloat>
    var fretBoard:Array<Array<Fret>>
    
    
    init(tunings:Array<note>, noOfFrets:Int, xArray:Array<CGFloat>, yArray:Array<CGFloat>){
        self.tunings = tunings
        self.noOfStrings = tunings.count
        self.noOfFrets = noOfFrets
        self.xArray = xArray
        self.yArray = yArray
        self.fretBoard = []
        
        createStrings()
    }
    
    
    func createStrings(){
//        if tunings.count != yArray.count{
//            print ("tunings and strings mismatch")
//            exit(0)
//        }
        
        for i in 0..<(tunings.count){
            let thisString = FretString(startingNote: tunings[i], numberOfFrets: noOfFrets, xArray: self.xArray, yValue: self.yArray[i])
            fretBoard.append(thisString.stringFrets)
        }
        
        
    }
    
}
