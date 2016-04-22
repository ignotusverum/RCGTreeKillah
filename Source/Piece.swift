//
//  Piece.swift
//  RCGTreeKillah
//
//  Created by Vladislav Zagorodnyuk on 3/10/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

class Piece: CCNode {

    weak var left: CCSprite!
    weak var right: CCSprite!
    
    var side: Side = .None {
        didSet {
            left.visible = false
            right.visible = false
            if side == .Right {
                right.visible = true
            } else if side == .Left {
                left.visible = true
            }
        }
    }
    
    func setObstacle(lastSide: Side) -> Side {
        
        if lastSide != .None {
            
            side = .None
        }
        else {
            
            let rand = CCRANDOM_0_1()
            if rand < 0.45 {
                side = .Left
            } else if rand < 0.9 {
                side = .Right
            } else {
                side = .None
            }
        }
        
        return side
    }
}