//
//  GameScene.swift
//  SkyBounce
//
//  Created by Robert Martinez on 12/21/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var playerNode: SKSpriteNode!
    var platform: SKSpriteNode!
    var initialTouchPosition: CGPoint?

    let playerCategory: UInt32 = 0x1 << 0
    let platformCategory: UInt32 = 0x1 << 1

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
//        physicsBody = SKPhysicsBody(edgeLoopFrom: frame.insetBy(dx: 0, dy: -200))

        playerNode = SKSpriteNode(color: .blue, size: CGSize(width: 100, height: 100))
        playerNode.position = CGPoint(x: frame.midX, y: frame.minY + playerNode.size.height / 2)

        playerNode.physicsBody = SKPhysicsBody(rectangleOf: playerNode.size)
        playerNode.physicsBody?.isDynamic = false
        playerNode.physicsBody?.categoryBitMask = playerCategory
        addChild(playerNode)

        addPlatform()

        let ceiling = SKNode()
        ceiling.position = CGPoint(x: frame.midX, y: frame.maxY)
        ceiling.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -frame.width / 2, y: 0, width: frame.width, height: 1))
        addChild(ceiling)

    }

    func addPlatform() {
        let platform = SKSpriteNode(color: .green, size: CGSize(width: frame.width, height: 20))
        platform.position = CGPoint(x: frame.midX, y: frame.minY + 50)
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.categoryBitMask = platformCategory
        addChild(platform)

//        let scaleFactor = 1.0 - (playerNode.position.y / frame.height)
//        platform.size.width *= scaleFactor
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        initialTouchPosition = touches.first?.location(in: self)

        playerNode.physicsBody?.isDynamic = true
        playerNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 200))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let initialTouchPosition = initialTouchPosition,
           let currentTouchPosition = touches.first?.location(in: self) {
            let deltaY = currentTouchPosition.y - initialTouchPosition.y

            let jumpHeight = deltaY * 0.1
            playerNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpHeight))
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        if(contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == platformCategory) || (contact.bodyA.categoryBitMask == platformCategory && contact.bodyB.categoryBitMask == playerCategory) {
            playerNode.physicsBody?.applyForce(CGVector(dx: 0, dy: 200))
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        initialTouchPosition = nil

        let jumpAction = SKAction.move(by: CGVector(dx: 0, dy: 100), duration: 0.5)
        playerNode.run(jumpAction)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }


    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
