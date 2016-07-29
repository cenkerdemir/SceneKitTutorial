//
//  PrimitivesScene.swift
//  SceneKitTutorial
//
//  Created by Cenker Demir on 7/22/16.
//  Copyright © 2016 Cenker Demir. All rights reserved.
//

import UIKit
import SceneKit

class PrimitivesScene: SCNScene, UIGestureRecognizerDelegate {
    
    
    //nodes
    var myFloorNode = SCNNode()
    var sphereNode = SCNNode()
    
    var secondNode = SCNNode()
    let sinonNode = SCNNode()
    let light = SCNNode()
    let cameraNode: SCNNode = SCNNode()
    
    //moves/animations
    let moveUp = SCNAction.moveByX(0.0, y: 1.0, z: -5.0, duration: 0.5)
    let moveDown = SCNAction.moveByX(0.0, y: -1.0, z: 0.0, duration: 0.5)
    let moveFwd1 = SCNAction.moveTo(SCNVector3( x:0, y: 4, z:-30), duration: 0.5)
    let moveFwd2 = SCNAction.moveTo(SCNVector3(x:0,y: 0.1, z:-30), duration: 0.5)
    var sequence = SCNAction()
    let spin = SCNAction.rotateByAngle(90, aroundAxis: SCNVector3(0.0,0.0,-5.0), duration: 0.5)
    let moveMe = CABasicAnimation(keyPath: "position.x")
    
    //let swipeRecognizer = UIPanGestureRecognizer()
    
    
    //moveNode.duration = 1.0
    //sinonNode.addAnimation(move, forKey: "slide right")
    
    override init() {
        super.init()
        
        self.background.contents = UIImage(named: "blue-sky.jpg")
        
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
        
        let lookAt = SCNLookAtConstraint(target: sinonNode)
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
        spotNode.position = SCNVector3(x: 4, y: 10, z: 25)
        spotNode.constraints = [lookAt]
        self.rootNode.addChildNode(spotNode)
        
        moveMe.byValue = -20
        moveMe.duration = 7.0
        cameraNode.addAnimation(moveMe, forKey: "slide right")
        
        //camera node
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.yFov = 50
        cameraNode.camera?.xFov = 50
        cameraNode.camera?.zFar = 300
        cameraNode.position = SCNVector3Make(0, 4, 20)
        cameraNode.constraints = [lookAt]
        self.rootNode.addChildNode(cameraNode)
        
        let sphereGeometry = SCNSphere(radius: 0.25)
        sphereGeometry.firstMaterial?.diffuse.contents = UIImage(named: "pokeball.png")
        sphereGeometry.firstMaterial?.lightingModelName = SCNLightingModelBlinn
        
        
        self.sphereNode = SCNNode(geometry: sphereGeometry)
        self.sphereNode.position = SCNVector3(0.0, 0.25,13)
        self.rootNode.addChildNode(self.sphereNode)
        
        
        self.secondNode = SCNNode(geometry: sphereGeometry)
        self.secondNode.position = SCNVector3(0.0, 0.25,13)
        self.rootNode.addChildNode(self.secondNode)
        
        self.sequence = SCNAction.sequence([moveFwd1, moveFwd2])
        //let repeatedSequence = SCNAction.repeatAction(sequence, count: 1)
        
        
        //sphereNode.runAction(sequence)
        //sphereNode.runAction(spin)
        

//
//        let secondSphereGeometry = SCNSphere(radius: 0.5)
//        secondSphereGeometry.firstMaterial?.diffuse.contents = UIColor.whiteColor()
//        let secondSphereNode = SCNNode(geometry: secondSphereGeometry)
//        secondSphereNode.position = SCNVector3(x:2.0, y:0.0, z:0.0)
//          self.rootNode.addChildNode(secondSphereNode)
        
        //goal
//        let pipeGeometry = SCNCylinder(radius: 0.2, height: 20)
//        
//        pipeGeometry.firstMaterial?.diffuse.contents = UIColor.whiteColor()
//        pipeGeometry.firstMaterial?.lightingModelName = SCNLightingModelBlinn
//        let pipe1Node = SCNNode(geometry: pipeGeometry)
//        pipe1Node.position = SCNVector3(-10, 0.0, -21.0)
//        self.rootNode.addChildNode(pipe1Node)
//        
//        let pipe2Node = SCNNode(geometry: pipeGeometry)
//        pipe2Node.position = SCNVector3(10, 0.0, -21.0)
//        self.rootNode.addChildNode(pipe2Node)
//        
//
//        let pipe3Node = SCNNode(geometry: pipeGeometry)
//        pipe3Node.position = SCNVector3(0, 2.0, -25.0)
//        self.rootNode.addChildNode(pipe3Node)
//
        //sinon character
        let scene = SCNScene(named: "tree-new.dae")
        let nodeArray = scene!.rootNode.childNodes
        for childNode in nodeArray {
            sinonNode.addChildNode(childNode)
        }
        self.rootNode.addChildNode(sinonNode)
        sinonNode.position = SCNVector3(x: 0.0, y: -0.01, z: -20.0)
        //sinonNode.physicsBody?.applyForce( SCNVector3Make( 0, 2, 0), impulse: true)
        
        //swipeRecognizer.addTarget(sphereNode, action: #selector(shootTheBall))
        
        //sinonNode.orientation = SCNQuaternion(x: -0.26, y: -0.32, z: 0, w: 0.91)
        
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
        print("x: \(velocity.x) ... y: \(velocity.y)")
        ball.runAction(self.sequence)
    }
    
}
