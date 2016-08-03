//
//  ViewController.swift
//  SceneKitTutorial
//
//  Created by Cenker Demir on 7/22/16.
//  Copyright © 2016 Cenker Demir. All rights reserved.
//

import UIKit
import SceneKit
import AVFoundation

class ViewController: UIViewController, SCNPhysicsContactDelegate {
    
    var scnView = SCNView()
    var primScn = PrimitivesScene()
    let swipeRecognizer = UIPanGestureRecognizer()
    var velocity = CGPoint()
    var backgroundMusic : AVAudioPlayer = AVAudioPlayer()
    var audioPlayerTimer = NSTimer()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scnView = self.view as! SCNView
        scnView.scene = primScn
        
        swipeRecognizer.addTarget(self, action: #selector(sceneSwiped))
        scnView.addGestureRecognizer(swipeRecognizer)
        
        //create physics bodies for the floor, character, and the ball
        primScn.physicsBodies()
        
        let bgMusicURL:NSURL = NSBundle.mainBundle().URLForResource("POL-find-the-exit-short", withExtension: "wav")!
        backgroundMusic = try! AVAudioPlayer(contentsOfURL: bgMusicURL)
        //backgroundMusic.numberOfLoops = -1
        backgroundMusic.prepareToPlay()
        backgroundMusic.volume = 0.6
        backgroundMusic.play()
        audioPlayerTimer = NSTimer.scheduledTimerWithTimeInterval(7, target: self, selector: #selector(stopAfter3seconds), userInfo: nil, repeats: false)
        
      //scnView.allowsCameraControl = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sceneSwiped(recognizer: UISwipeGestureRecognizer) {
        self.velocity = swipeRecognizer.velocityInView(scnView)
        primScn.shootTheBall(primScn.sphereNode, velocity: self.velocity)
    }
    
    func stopAfter3seconds(){
        while backgroundMusic.volume > 0 {
            backgroundMusic.volume -= 0.00001
        }
        backgroundMusic.stop()
    }
}

