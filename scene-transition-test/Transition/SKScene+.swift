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
    // This version also fades in the next scene elements!
    func transition(to otherScene: SKScene,
                    during duration: Double,
                    firstCompletion: (() -> Void)?,
                    delay: Double,
                    fullCompletion: (() -> Void)?) {
        let sceneActions = prepareActions(creatingTransitionTo: otherScene, during: duration)
        
        var allNodeGroups: [(SKNode, SKAction)] = []
        allNodeGroups += children.map({ node in
            // If a node with the same name is found in the same hierarchy
            if let nodeName = node.name,
               let otherNode = otherScene.childNode(withName: nodeName) {
                return (node, node.prepareActions(creatingTransitionTo: otherNode, during: duration))
            } 
                
            return (node, SKAction.fadeOut(withDuration: duration))
        })
        
        print("Moving first scene nodes...")
        run(sceneActions) {
            firstCompletion?()
        }
        
        allNodeGroups.forEach { node, action in
            node.run(action)
        }
        
        // Stores all the nodes from the other scene that were not matched during the transition
        var allOtherSceneUnmatchedNodeGroups: [(SKNode, SKAction)] = []
        allOtherSceneUnmatchedNodeGroups += otherScene.children.compactMap({ node in
            // If a node with the same name is found in the same hierarchy of the current scene, avoid doing anything
            guard let nodeName = node.name,
               childNode(withName: nodeName) == nil else {
                return nil
            }
            
            // If unmatched, return a fade in
            node.alpha = 0
            return (node, SKAction.fadeIn(withDuration: duration / 2))
        })
        
        // If we need to perform a second transition
        guard allOtherSceneUnmatchedNodeGroups.count > 0  else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + delay) {
            // Run the first node separately to trigger the completion
            print("Presenting second scene nodes...")
            let (firstNode, firstAction) = allOtherSceneUnmatchedNodeGroups.removeFirst()
            firstNode.run(firstAction) {
                fullCompletion?()
            }
            
            allOtherSceneUnmatchedNodeGroups.forEach { node, action in
                node.run(action)
            }
        }
    }
    
}
