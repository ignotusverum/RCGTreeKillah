import Foundation

enum Side {
    case Left, Right, None
}

enum GameState {
    case Title, Ready, Playing, GameOver
}

class MainScene: CCNode {

    weak var scoreLabel: CCLabelTTF!
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
        }
    }
    
    weak var readyButton: CCButton!
    
    var gameState: GameState = .Title
    weak var restartButton: CCButton!
    
    weak var gameLogo: CCEffectNode!
    
    weak var piecesNode: CCNode!
    var pieces: [Piece] = []
    
    weak var tapButtons: CCNode!
    
    weak var character: Character!
    
    var pieceLastSide: Side = .Left
    
    var pieceIndex: Int = 0
    
    weak var lifeBar: CCSprite!
    weak var lifeBarNode: CCNode!
    
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
            piece.position = CGPoint(x: 50.0, y: yPos)
            piecesNode.addChild(piece)
            pieces.append(piece)
        }
        
        self.animationManager.runAnimationsForSequenceNamed("Initial Timeline")
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    
        if gameState == .GameOver || gameState == .Title { return }
        
        if gameState == .Ready { start() }
        
        stepTower()
        
        let xTouch = touch.locationInWorld().x
        let screenHalf = CCDirector.sharedDirector().viewSize().width / 2
        
        if xTouch < screenHalf {
            character.left()
        }
        else {
            character.right()
        }
        
        score = score + 1
    }
    
    func restart() {
        
        let mainScene = CCBReader.load("MainScene") as! MainScene
        mainScene.ready()
        
        let scene = CCScene()
        scene.addChild(mainScene)
        
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
    
    func start() {
        
        gameState = .Playing
    }
    
    func ready() {
        
        gameState = .Ready
        
        self.readyButton.userInteractionEnabled = false
        
        tapButtons.cascadeOpacityEnabled = true
        tapButtons.opacity = 0.0
        
        gameLogo.cascadeOpacityEnabled = true
        gameLogo.opacity = 0.0
        
        gameLogo.runAction(CCActionFadeOut(duration: 0.2))
        tapButtons.runAction(CCActionFadeOut(duration: 0.2))
        
        scoreLabel.visible = true
        lifeBarNode.visible = true
    }
    
    func triggerGameOver() {
        
        if gameState == .Playing { return }
        
        restartButton.visible = true
    }
    
    func isGameOver() -> Bool {
        let newPiece = pieces[pieceIndex]
        
        if newPiece.side == character.side { triggerGameOver() }
        
        return gameState == .GameOver
    }
    
    override func update(delta: CCTime) {
        
        if gameState == .GameOver || gameState == .Title { return }
        
        timeLeft -= Float(delta)
        if timeLeft == 0 {
            triggerGameOver()
        }
    }
}