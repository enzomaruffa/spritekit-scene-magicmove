//
//  Scene1.swift
//  scene-transition-test
//
//  Created by Enzo Maruffa on 27/08/21.
//

import SpriteKit

class Scene1: SKScene {
    
    weak var transitionDelegate: TransitionDelegate?
    
    lazy var nextLabel : SKLabelNode = { [unowned self] in
        return childNode(withName : "next") as! SKLabelNode
    }()
    
    static func create() -> Scene1 {
        Scene1(fileNamed: "Scene1")!
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
        let touchPosition = firstTouch.location(in: self)
        
        if (nextLabel.contains(touchPosition)) {
            transitionDelegate?.startTransition()
        }
    }
    
}
