import Foundation

enum Side {
    case Left, Right, None
}

class MainScene: CCNode {

    weak var scoreLabel: CCLabelTTF!
    
    var gameOver = false
    weak var restartButton: CCButton!
    
    weak var piecesNode: CCNode!
    var pieces: [Piece] = []
    
    weak var character: Character!
    
    var pieceLastSide: Side = .Left
    
    var pieceIndex: Int = 0
    
    weak var lifeBar: CCSprite!
    
    var timeLeft: Float = 5 {
        didSet {
            timeLeft = max(min(timeLeft, 10), 0)
            lifeBar.scaleX = timeLeft / Float(10)
        }
    }
    
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
    
        if gameOver { return }
        
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
    
    func restart() {
        let scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(scene)
    }
    
    func stepTower() {
        
        if isGameOver() { return }
        
        let piece = pieces[pieceIndex]
        
        let yDiff = piece.contentSize.height * 10
        piece.position = ccpAdd(piece.position, CGPoint(x: 0, y: yDiff))
        
        piece.zOrder = piece.zOrder + 1
        
        pieceLastSide = piece.setObstacle(pieceLastSide)
        
        piecesNode.position = ccpSub(piecesNode.position,
            CGPoint(x: 0, y: piece.contentSize.height))
        
        pieceIndex = (pieceIndex + 1) % 10
        
        timeLeft = timeLeft + 0.25
    }
    
    func triggerGameOver() {
        gameOver = true
        restartButton.visible = true
    }
    
    func isGameOver() -> Bool {
        let newPiece = pieces[pieceIndex]
        
        if newPiece.side == character.side { triggerGameOver() }
        
        return gameOver
    }
    
    override func update(delta: CCTime) {
        if gameOver { return }
        timeLeft -= Float(delta)
        if timeLeft == 0 {
            triggerGameOver()
        }
    }
}
