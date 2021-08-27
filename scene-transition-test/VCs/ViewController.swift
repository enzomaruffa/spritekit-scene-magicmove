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
        
        // Gets the scene we want to transition to
        let nextScene = getNextScene()
        nextScene.scaleMode = .aspectFit
        
        // Sets the delay between the first part of the transition (moving stuff from the first scene to the second scene) and the second part of the transition (fading in unmatched elements)
        let delay = 0.05
        
        currentScene?.transition(to: nextScene, during: 0.8, firstCompletion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                print("Presenting second scene...")
                self?.skView.presentScene(nextScene)
            }
        }, fadeInDelay: delay, fullCompletion: nil)
    }
}
