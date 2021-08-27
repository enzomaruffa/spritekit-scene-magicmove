//
//  Transition.swift
//  scene-transition-test
//
//  Created by Enzo Maruffa on 27/08/21.
//

import Foundation

protocol TransitionDelegate: AnyObject {
    var canTransition: Bool { get }
    
    func startTransition()
}
