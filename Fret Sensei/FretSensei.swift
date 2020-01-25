//
//  FretSensei.swift
//  Fret Sensei
//
//  Created by Lubin Tan on 19/2/16.
//  Copyright © 2016 Lubz. All rights reserved.
//


var notePressed = ""
var noteSelected : note!
var currentCorrectNote : note!

var strings:Int!
var frets:Int!

var timerCounter:Int = timerLength

let deviceModel = platform()

func platform() -> String {
    var sysinfo = utsname()
    uname(&sysinfo) // ignore return value
    return NSString(bytes: &sysinfo.machine, length: Int(_SYS_NAMELEN), encoding: NSASCIIStringEncoding)! as String
}

