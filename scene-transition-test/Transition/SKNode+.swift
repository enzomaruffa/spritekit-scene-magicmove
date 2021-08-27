//
//  SKNode_.swift
//  scene-transition-test
//
//  Created by Enzo Maruffa on 27/08/21.
//

import SpriteKit

extension SKNode {
    
    func prepareActions(creatingTransitionTo otherNode: SKNode, during duration: Double) -> SKAction {
        var actions: [SKAction] = []
        
        // TODO: Checks for possible downcasts
        if let _ = self as? SKScene,
           let otherScene = otherNode as? SKScene {
            
            let colorizeAction = SKAction.colorize(with: otherScene.backgroundColor, colorBlendFactor: 1, duration: duration)
            actions.append(colorizeAction)
            
            return SKAction.group(actions)
        }
        
        // Defaults to every the SKNode except SKScene
        let positionAction = SKAction.move(to: otherNode.position, duration: duration)
        actions.append(positionAction)
        
        let rotationAction = SKAction.rotate(toAngle: otherNode.zRotation, duration: duration)
        actions.append(rotationAction)
        
        let sizeAction = SKAction.resize(toWidth: otherNode.frame.width, height: otherNode.frame.height, duration: duration)
        actions.append(sizeAction)
        
        let scaleAction = SKAction.scaleX(to: otherNode.xScale, y: otherNode.yScale, duration: duration)
        actions.append(scaleAction)
        
        // Set the timing mode
        actions.forEach({ $0.timingMode = .easeInEaseOut })
        
        return SKAction.group(actions)
    }
    
}
