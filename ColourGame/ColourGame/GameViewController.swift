//
//  GameViewController.swift
//  ColourGame
//
//  Created by Sunny Peebles on 6/05/19.
//  Copyright © 2019 Sunny Peebles. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    let userDef = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            let scene = MainMenu(size: view.bounds.size);
            scene.scaleMode = .aspectFill;
            
            view.presentScene(scene);
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            
            /*if let highscore = userDef.value(forKey: "highscore") {
                // do something here when a highscore exists
                userDef.setValue(0, forKey: "highscore");
                userDef.synchronize();
            }
            else
            {
                userDef.setValue(0, forKey: "highscore");
                userDef.synchronize();
            }*/
        }
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
