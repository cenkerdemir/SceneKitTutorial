//
//  ViewController.swift
//  SceneKitTutorial
//
//  Created by Cenker Demir on 7/22/16.
//  Copyright © 2016 Cenker Demir. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController, SCNPhysicsContactDelegate {
    
    var scnView = SCNView()
    var primScn = PrimitivesScene()
    let swipeRecognizer = UIPanGestureRecognizer()
    var velocity = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scnView = self.view as! SCNView
        scnView.scene = primScn
        
        swipeRecognizer.addTarget(self, action: #selector(sceneSwiped))
        scnView.addGestureRecognizer(swipeRecognizer)
        
        primScn.physicsWorld.contactDelegate = self
        
//        scnView.allowsCameraControl = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sceneSwiped(recognizer: UISwipeGestureRecognizer) {
        self.velocity = swipeRecognizer.velocityInView(scnView)
        primScn.shootTheBall(primScn.sphereNode, velocity: self.velocity)
    }

    func physicsWorld(world: SCNPhysicsWorld, didUpdateContact contact: SCNPhysicsContact) {
        if (contact.nodeA == primScn.sphereNode || contact.nodeA == primScn.pokeNode) && (contact.nodeB == primScn.sphereNode || contact.nodeB == primScn.pokeNode) {
            let particleSystem = SCNParticleSystem(named: "Explosion", inDirectory: nil)
            let systemNode = SCNNode()
            systemNode.addParticleSystem(particleSystem!)
            systemNode.position = contact.nodeA.position
            primScn.rootNode.addChildNode(systemNode)
            
            contact.nodeA.removeFromParentNode()
            contact.nodeB.removeFromParentNode()
        }
    }

}

