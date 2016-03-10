import Foundation

enum Side {
    case Left, Right, None
}

class MainScene: CCNode {

    weak var piecesNode: CCNode!
    var pieces: [Piece] = []
    
    weak var character: Character!
    
    var pieceLastSide: Side = .Left
    
    var pieceIndex: Int = 0
    
    func didLoadFromCCB() {

        userInteractionEnabled = true
        
        for i in 0..<10 {
            
            let piece = CCBReader.load("Piece") as! Piece
            
            pieceLastSide = piece.setObstacle(pieceLastSide)
            
            let yPos = piece.contentSizeInPoints.height * CGFloat(i)
            piece.position = CGPoint(x: 0.0, y: yPos)
            piecesNode.addChild(piece)
            pieces.append(piece)
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    
        stepTower()
        
        let xTouch = touch.locationInWorld().x
        let screenHalf = CCDirector.sharedDirector().viewSize().width / 2
        
        if xTouch < screenHalf {
            character.left()
        }
        else {
            character.right()
        }
    }
    
    func stepTower() {
        
        let piece = pieces[pieceIndex]
        
        let yDiff = piece.contentSize.height * 10
        piece.position = ccpAdd(piece.position, CGPoint(x: 0, y: yDiff))
        
        piece.zOrder = piece.zOrder + 1
        
        pieceLastSide = piece.setObstacle(pieceLastSide)
        
        piecesNode.position = ccpSub(piecesNode.position,
            CGPoint(x: 0, y: piece.contentSize.height))
        
        pieceIndex = (pieceIndex + 1) % 10
    }
}
