//
//  ViewController.swift
//  scene-transition-test
//
//  Created by Enzo Maruffa on 27/08/21.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    @IBOutlet weak var skView: SKView!
    
    var currentScene: SKScene? {
        skView.scene
    }
    
    var transitioning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let scene1 = Scene1.create()
        scene1.scaleMode = .aspectFit
        scene1.transitionDelegate = self
        skView.presentScene(scene1)
    }
    
    func getNextScene() -> SKScene {
        Scene2.create()
    }

}

extension ViewController: TransitionDelegate {
    var canTransition: Bool {
        !transitioning
    }
    
    func startTransition() {
        guard canTransition else { return }
        
        transitioning = true
        
        let nextScene = getNextScene()
        nextScene.scaleMode = .aspectFit
        
        currentScene?.transition(to: nextScene, during: 1.5, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.skView.presentScene(nextScene)
            }
        })
    }
}
