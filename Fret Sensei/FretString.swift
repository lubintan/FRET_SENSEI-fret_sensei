//
//  FretString.swift
//  Fret Sensei
//
//  Created by Lubin Tan on 13/2/16.
//  Copyright © 2016 Lubz. All rights reserved.
//

import UIKit
import SpriteKit



class FretString {

    let startingNote: note
    let numberOfFrets:Int
    
    var stringFrets:Array<Fret> = []

    init(startingNote: note, numberOfFrets: Int, xArray:Array<CGFloat>, yValue: CGFloat){
        self.startingNote = startingNote
        self.numberOfFrets = numberOfFrets
        
        //initialize string
        
        
        for i in 0..<(xArray.count) {
            
     
            
            let thisNote = note(rawValue: ((i+startingNote.rawValue)%12))
            let thisFret = Fret(fretNote: thisNote!, centerPoint: CGPoint(x: xArray[i], y: yValue))
            
            stringFrets.append(thisFret)
            
        }
        
        
    }
    

    
//    func printArray() {
//        print(stringFrets)
//    }
    
}