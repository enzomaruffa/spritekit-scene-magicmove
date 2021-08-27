//
//  SKScene+.swift
//  scene-transition-test
//
//  Created by Enzo Maruffa on 27/08/21.
//

import SpriteKit

extension SKScene {
    
    // It would be possible to add a new object called TransitionSettings that contains settings about what to do in specific scenarios (e.g. unmatched elements, node hierarchy)
    // Current implementation only checks for the scene properties + top nodes
    // Using the transition settings and the \ operator, dynamic property transitioning could be implemented
    func transition(to otherScene: SKScene, during duration: Double, completion: (() -> Void)?) {
        let sceneActions = prepareActions(creatingTransitionTo: otherScene, during: duration)
        
        var allNodeGroups: [(SKNode, SKAction)] = []
        allNodeGroups += children.map({ node in
            // If a node with the same name is found in the same hierarchy
            if let nodeName = node.name,
               let otherNode = otherScene.childNode(withName: nodeName) {
                return (node, node.prepareActions(creatingTransitionTo: otherNode, during: duration))
            } else {
                return (node, SKAction.fadeOut(withDuration: duration))
            }
        })
        
        run(sceneActions) {
            completion?()
        }
        
        allNodeGroups.forEach { node, action in
            node.run(action)
        }
        
    }
    
}
