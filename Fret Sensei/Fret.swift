//
//  Fret.swift
//  Fret Sensei
//
//  Created by Lubin Tan on 13/2/16.
//  Copyright © 2016 Lubz. All rights reserved.
//

//import Foundation

import SpriteKit

enum note: Int, CustomStringConvertible {
    
    
    case A = 1, Bflat = 2, B = 3, C = 4, Dflat = 5, D = 6, Eflat = 7, E = 8, F = 9, Gflat = 10, G = 11, Aflat = 0, err = -1
    
    var noteName: String {
        switch self {
        case .A:
            return "A"
        case .Bflat:
            return "Bb"
        case .B:
            return "B"
        case .C:
            return "C"
        case .Dflat:
            return "Db"
        case .D:
            return "D"
        case .Eflat:
            return "Eb"
        case .E:
            return "E"
        case .F:
            return "F"
        case .Gflat:
            return "Gb"
        case .G:
            return "G"
        case .Aflat:
            return "Ab"
        case .err:
            return "no selection"

        }
    }
    
    var description: String{
        return self.noteName
    }
    
    static func random() -> note {
        return note(rawValue:Int(arc4random_uniform(12)))!
    }
    
}


class Fret: CustomStringConvertible{
    var fretNote:note
    let centerPoint:CGPoint
    
    
    var noteName: String{
        return fretNote.noteName
    }
    
    var description: String{
        return"\(noteName):[x:\(centerPoint.x),y:\(centerPoint.y)]"
    }
    
    init(fretNote:note, centerPoint:CGPoint ){
        self.centerPoint = centerPoint
        self.fretNote = fretNote
    }
}
