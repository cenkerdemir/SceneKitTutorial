//
//  PrimitivesScene.swift
//  SceneKitTutorial
//
//  Created by Cenker Demir on 7/22/16.
//  Copyright © 2016 Cenker Demir. All rights reserved.
//

import UIKit
import SceneKit

class PrimitivesScene: SCNScene, UIGestureRecognizerDelegate, SCNPhysicsContactDelegate {
    
    
    //nodes
    var myFloorNode = SCNNode()
    var sphereNode = SCNNode()
    
    //var secondNode = SCNNode()
    let pokeNode = SCNNode()
    let light = SCNNode()
    let cameraNode: SCNNode = SCNNode()
    
    //moves/animations
    let moveUp = SCNAction.moveByX(0.0, y: 1.0, z: -5.0, duration: 0.5)
    let moveDown = SCNAction.moveByX(0.0, y: -1.0, z: 0.0, duration: 0.5)
    let moveFwd1 = SCNAction.moveTo(SCNVector3( x:0, y: 4, z:-15), duration: 0.5)
    let moveFwd2 = SCNAction.moveTo(SCNVector3(x:0,y: 0.1, z:-30), duration: 0.5)
    let moveFwd3 = SCNAction.moveTo(SCNVector3(x:0, y:-40,z:13), duration: 0.2)
    let moveFwd4 = SCNAction.moveTo(SCNVector3(x:0.0, y:0.25,z:13), duration: 0.2)
    let hideCharacter = SCNAction.hide()
    let showCharacter = SCNAction.unhide()
    let waitForOne = SCNAction.waitForDuration(1.0)
    let fadeOut = SCNAction.fadeOutWithDuration(1.0)
    let fadeIn = SCNAction.fadeInWithDuration(1.0)
    let waitForFive = SCNAction.waitForDuration(5.0)
    let waitLonger = SCNAction.waitForDuration(5.0)
    let removeNode = SCNAction.removeFromParentNode()
    var sequenceBall = SCNAction()
    var sequenceExplosion = SCNAction()
    var sequenceForCharacter = SCNAction()
    
    let spin = SCNAction.rotateByAngle(90, aroundAxis: SCNVector3(0.0,0.0,-5.0), duration: 0.5)
    let moveMeOnX = CABasicAnimation(keyPath: "position.x")
//    let moveMeOnY = CABasicAnimation(keyPath: "position.y")
    //let swipeRecognizer = UIPanGestureRecognizer()
    //moveNode.duration = 1.0
    //sinonNode.addAnimation(move, forKey: "slide right")
    
    //explosion particle system
    let particleSystem = SCNParticleSystem(named: "Explosion", inDirectory: nil)
    let explosionNode = SCNNode()
    
    let collisionCategoryOne = 1 << 0
    let collisionCategoryTwo = 1 << 1
    let collisionCategoryThree = 1 << 2
    
    override init() {
        super.init()
        
        print("\(collisionCategoryOne) \(collisionCategoryTwo) \(collisionCategoryThree)")
        
        self.background.contents = UIImage(named: "blue-sky.jpg")
        physicsWorld.contactDelegate = self
        
        //floor
//        let myFloor = SCNFloor()
//        myFloor.reflectivity = 0
//        //myFloor.reflectionFalloffEnd = 5
//        myFloor.firstMaterial?.diffuse.contents = UIImage(named: "green.png")//UIColor.greenColor()
//        myFloor.firstMaterial?.lightingModelName = SCNLightingModelBlinn
//        myFloor.firstMaterial?.litPerPixel = false
//        myFloor.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat
//        myFloor.firstMaterial?.diffuse.wrapT = SCNWrapMode.Repeat
//        let myFloorNode = SCNNode(geometry: myFloor)
        myFloorNode.castsShadow = true
        myFloorNode = self.makeFloor()
        self.rootNode.addChildNode(myFloorNode)
        
        let lookAt = SCNLookAtConstraint(target: pokeNode)
        lookAt.gimbalLockEnabled = true
        
        //ambient light
        let ambientLight = SCNLight()
        ambientLight.color = UIColor.darkGrayColor()
        ambientLight.type = SCNLightTypeAmbient
        self.cameraNode.light = ambientLight
        
        
        // spotLight
        let spot = SCNLight()
        spot.type = SCNLightTypeSpot
        spot.castsShadow = true
        spot.spotInnerAngle = 70
        spot.spotOuterAngle = 90
        spot.zFar = 250
        let spotNode = SCNNode()
        spotNode.light = spot
        spotNode.position = SCNVector3(x: 20, y: 20, z: 30)
        spotNode.constraints = [lookAt]
        self.rootNode.addChildNode(spotNode)
        
        
//        moveMeOnY.byValue = 10
//        moveMeOnY.duration = 4
//        cameraNode.addAnimation(moveMeOnY, forKey: "slide up")
        
        //camera node
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.yFov = 50
        cameraNode.camera?.xFov = 50
        cameraNode.camera?.zFar = 300
        cameraNode.position = SCNVector3Make(0, 4, 20)
        cameraNode.constraints = [lookAt]
        self.rootNode.addChildNode(cameraNode)
        moveMeOnX.byValue = -20
        moveMeOnX.duration = 8
        cameraNode.addAnimation(moveMeOnX, forKey: "slide right")
        
        //ball
        let sphereGeometry = SCNSphere(radius: 0.3)
        sphereGeometry.firstMaterial?.diffuse.contents = UIImage(named: "pokeball.png")
        sphereGeometry.firstMaterial?.lightingModelName = SCNLightingModelBlinn
        self.sphereNode = SCNNode(geometry: sphereGeometry)
        self.sphereNode.position = SCNVector3(0.0, 0.25, 13)
        self.rootNode.addChildNode(self.sphereNode)
        
        //explosion
        explosionNode.addParticleSystem(particleSystem!)
        explosionNode.position = SCNVector3(x: 0.2, y:3.0, z:0)
        //explosionNode.runAction(hideCharacter)

        
        //action sequences
        self.sequenceBall = SCNAction.sequence([self.moveFwd1, self.moveFwd2, self.hideCharacter, self.waitForFive, self.moveFwd3, self.moveFwd4, self.showCharacter])
        self.sequenceExplosion = SCNAction.sequence([self.hideCharacter, self.waitForOne, self.showCharacter, self.waitForOne, self.hideCharacter])
        self.sequenceForCharacter = SCNAction.sequence([self.waitForOne, self.fadeOut, self.waitLonger, self.fadeIn])
        
        //sphereNode.runAction(sequence)
        //sphereNode.runAction(spin)
        
        //pokemon character
        let scene = SCNScene(named: "pik.dae")
        let nodeArray = scene!.rootNode.childNodes
        for childNode in nodeArray {
            pokeNode.addChildNode(childNode)
        }
        self.rootNode.addChildNode(pokeNode)
        pokeNode.position = SCNVector3(x: 0.0, y: -0.01, z: -20.0)
        //pokeNode.physicsBody?.applyForce( SCNVector3Make( 0, 2, 0), impulse: true)
        //pokeNode.orientation = SCNQuaternion(x: -0.26, y: -0.32, z: 0, w: 0.91)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(:coder) has not been implemented")
    }
    
    func makeFloor() -> SCNNode {
        let floor = SCNFloor()
        floor.reflectivity = 0
        let floorNode = SCNNode()
        floorNode.geometry = floor
        let floorMaterial = SCNMaterial()
        //floorMaterial.litPerPixel = false
        floorMaterial.diffuse.contents = UIImage(named:"green.png")
        floorMaterial.diffuse.wrapS = SCNWrapMode.Repeat
        floorMaterial.diffuse.wrapT = SCNWrapMode.Repeat
        floor.materials = [floorMaterial]
        return floorNode
    }
    
    func shootTheBall(ball: SCNNode, velocity: CGPoint) {
        //print("x: \(ball.physicsBody!.velocity.y) ... y: \(pokeNode.position.z)")
        self.rootNode.addChildNode(explosionNode)
        sphereNode.runAction(self.sequenceBall)
        explosionNode.runAction(self.sequenceExplosion)
        pokeNode.runAction(self.sequenceForCharacter)
    }
    
    func physicsBodies() {
        //add physics bodies
        if let floorGeometry = myFloorNode.geometry {
            let floorShape = SCNPhysicsShape(geometry: floorGeometry, options: nil)
            let floorBody = SCNPhysicsBody(type: .Static, shape: floorShape)
            myFloorNode.physicsBody = floorBody
            print("floor's physics body: \(floorBody)")
        }
        
        if let sphereGeometry = sphereNode.geometry {
            let ballPhysicsShape = SCNPhysicsShape(geometry: sphereGeometry, options: nil)
            let sphereBody = SCNPhysicsBody(type: .Dynamic, shape: ballPhysicsShape)
            sphereNode.physicsBody = sphereBody
            sphereNode.physicsBody!.categoryBitMask = self.collisionCategoryOne
            sphereNode.physicsBody!.collisionBitMask = self.collisionCategoryTwo
            sphereNode.physicsBody!.affectedByGravity = true
            print("ball's physics body: \(sphereBody)")
        }
        else {
            print("could not get the pokeBall geometry?")
        }
        
        let pokeGeometry = SCNBox(width: 4, height: 10, length: 5, chamferRadius: 0.3)
        let pokeShape = SCNPhysicsShape(geometry: pokeGeometry, options: nil)
        let pokeBody = SCNPhysicsBody(type: .Kinematic, shape: pokeShape)
        pokeNode.physicsBody = pokeBody
        pokeNode.physicsBody!.categoryBitMask = self.collisionCategoryTwo
        pokeNode.physicsBody!.collisionBitMask = self.collisionCategoryOne
        print("pokemon character's body: \(pokeBody)")
    }
    
    func physicsWorld(world: SCNPhysicsWorld, didBeginContact contact: SCNPhysicsContact) {
        let contactMask = contact.nodeA.physicsBody!.categoryBitMask | contact.nodeB.physicsBody!.categoryBitMask
        if contactMask == self.collisionCategoryOne | self.collisionCategoryTwo {
            print("collision")
        }
        
        print("did the contact being?")
    }
    
    func physicsWorld(world: SCNPhysicsWorld, didUpdateContact contact: SCNPhysicsContact) {
        print("is there a contact? is there a contact? is there a contact?")
        if (contact.nodeA == sphereNode || contact.nodeA == pokeNode) && (contact.nodeB == sphereNode || contact.nodeB == pokeNode) {
            print("contact made")
            let particleSystem = SCNParticleSystem(named: "Explosion", inDirectory: nil)
            let systemNode = SCNNode()
            systemNode.addParticleSystem(particleSystem!)
            systemNode.position = contact.nodeA.position
            self.rootNode.addChildNode(systemNode)
            
            //contact.nodeA.removeFromParentNode()
            //contact.nodeB.removeFromParentNode()
        }
    }

    
}
