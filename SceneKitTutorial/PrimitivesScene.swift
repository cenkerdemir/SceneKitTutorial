//
//  PrimitivesScene.swift
//  SceneKitTutorial
//
//  Created by Cenker Demir on 7/22/16.
//  Copyright © 2016 Cenker Demir. All rights reserved.
//

import UIKit
import SceneKit

class PrimitivesScene: SCNScene {
    
    //nodes
    let myFloor = SCNFloor()
    var sphereNode = SCNNode()
    let sinonNode = SCNNode()
    let light = SCNNode()
    let cameraNode: SCNNode = SCNNode()
    
    //moves/animations
    let moveUp = SCNAction.moveByX(0.0, y: 1.0, z: -5.0, duration: 0.5)
    let moveDown = SCNAction.moveByX(0.0, y: -1.0, z: 0.0, duration: 0.5)
    let moveFwd1 = SCNAction.moveTo(SCNVector3( x:-0.5, y: 1.1, z:-25), duration: 1.0)
    let moveFwd2 = SCNAction.moveTo(SCNVector3(x:-1.0,y: 0.1, z:-50), duration: 1.0)
    var sequence = SCNAction()
    let spin = SCNAction.rotateByAngle(90, aroundAxis: SCNVector3(0.0,0.0,-5.0), duration: 0.5)
    let moveMe = CABasicAnimation(keyPath: "position.x")
    
    

    
    //moveNode.duration = 1.0
    //sinonNode.addAnimation(move, forKey: "slide right")
    
    override init() {
        super.init()
        
        self.background.contents = UIImage(named: "blue-sky.jpg")
        
        //floor
        myFloor.reflectivity = 0
        myFloor.reflectionFalloffEnd = 5
        myFloor.firstMaterial?.diffuse.contents = UIColor.greenColor()
        myFloor.firstMaterial?.lightingModelName = SCNLightingModelBlinn
        let myFloorNode = SCNNode(geometry: myFloor)
        myFloorNode.castsShadow = true
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
        spot.zFar = 200
        let spotNode = SCNNode()
        spotNode.light = spot
        spotNode.position = SCNVector3(x: 4, y: 5, z: 10)
        spotNode.constraints = [lookAt]
        self.rootNode.addChildNode(spotNode)
        
        moveMe.byValue = -20
        moveMe.duration = 3.0
        cameraNode.addAnimation(moveMe, forKey: "slide right")
        
        //camera node
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.yFov = 20
        cameraNode.camera?.xFov = 20
        cameraNode.camera?.zFar = 200
        cameraNode.position = SCNVector3Make(0, 1, -5)
        cameraNode.constraints = [lookAt]
        self.rootNode.addChildNode(cameraNode)
        
        let sphereGeometry = SCNSphere(radius: 0.1)
        sphereGeometry.firstMaterial?.diffuse.contents = UIImage(named: "football.png")
        sphereGeometry.firstMaterial?.lightingModelName = SCNLightingModelBlinn
        self.sphereNode = SCNNode(geometry: sphereGeometry)
        self.sphereNode.position = SCNVector3(0.0, 0.1,-10)
        self.rootNode.addChildNode(self.sphereNode)
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
        let pipeGeometry = SCNCylinder(radius: 0.03, height: 4)
        
        pipeGeometry.firstMaterial?.diffuse.contents = UIColor.whiteColor()
        pipeGeometry.firstMaterial?.lightingModelName = SCNLightingModelBlinn
        let pipe1Node = SCNNode(geometry: pipeGeometry)
        pipe1Node.position = SCNVector3(-2, 0.0, -21.0)
        self.rootNode.addChildNode(pipe1Node)
        
        let pipe2Node = SCNNode(geometry: pipeGeometry)
        pipe2Node.position = SCNVector3(2, 0.0, -21.0)
        self.rootNode.addChildNode(pipe2Node)
        
//        
//        let pipe3Node = SCNNode(geometry: pipeGeometry)
//        pipe3Node.position = SCNVector3(0, 2.0, -25.0)
//        self.rootNode.addChildNode(pipe3Node)
//
        //sinon character
        let scene = SCNScene(named: "sinon.dae")
        let nodeArray = scene!.rootNode.childNodes
        for childNode in nodeArray {
            sinonNode.addChildNode(childNode)
        }
        self.rootNode.addChildNode(sinonNode)
        sinonNode.position = SCNVector3(x: 0.0, y: -0.01, z: -20.0)
        //sinonNode.physicsBody?.applyForce( SCNVector3Make( 0, 2, 0), impulse: true)
    
        //sinonNode.orientation = SCNQuaternion(x: -0.26, y: -0.32, z: 0, w: 0.91)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(:coder) has not been implemented")
    }
    
    func shootTheBall(ball: SCNNode) {
        ball.runAction(self.sequence)
    }
    
}
