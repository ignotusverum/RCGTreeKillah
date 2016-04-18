//
//  Character.swift
//  RCGTreeKillah
//
//  Created by Vladislav Zagorodnyuk on 3/10/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

class Character: CCSprite {

    var side: Side = .Left
    
    func left() {
        side = .Left
        scaleX = 1
    }
    
    func right() {
        side = .Right
        scaleX = -1
    }
}