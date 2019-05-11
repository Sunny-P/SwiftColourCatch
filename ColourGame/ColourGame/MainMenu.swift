//
//  MainMenu.swift
//  ColourGame
//
//  Created by Sunny Peebles on 6/05/19.
//  Copyright © 2019 Sunny Peebles. All rights reserved.
//

import SpriteKit
//import GameplayKit

class MainMenu : SKScene {
    let playSpriteNode = SKSpriteNode();
    let quitSpriteNode = SKSpriteNode();
    let highscoreNode = SKLabelNode(fontNamed: "HelveticaNeue-Bold");
    let logoNode = SKSpriteNode();
    
    // Used for grabbing Highscore
    let userDef = UserDefaults.standard;
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.init(red: 0.225, green: 0.225, blue: 0.225, alpha: 1);
        
        CreatePlayButtonNode();
        CreateQuitButtonNode();
        CreateHighscoreNode();
        CreateLogoNode();
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self)
        {
            // Scale-up each pressed button
            if playSpriteNode.contains(location)
            {
                playSpriteNode.size.width *= 1.2;
                playSpriteNode.size.height *= 1.2;
            }
            else if quitSpriteNode.contains(location)
            {
                quitSpriteNode.size.width *= 1.2;
                quitSpriteNode.size.height *= 1.2;
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self)
        {
            if playSpriteNode.contains(location)
            {
                // Scale down button on end-touch (if necessary?)
                playSpriteNode.size.width /= 1.2;
                playSpriteNode.size.height /= 1.2;
                
                // Play button transitions to GameScene
                let newScene = GameScene(size: (self.view?.bounds.size)!);
                let transition = SKTransition.crossFade(withDuration: 1);
                self.view?.presentScene(newScene, transition: transition);
                transition.pausesOutgoingScene = false;
                transition.pausesIncomingScene = true;
            }
            else if quitSpriteNode.contains(location)
            {
                // Scale down button on end-touch (if necessary?)
                quitSpriteNode.size.width /= 1.2;
                quitSpriteNode.size.height /= 1.2;
                
                exit(0);
            }
        }
    }
    
    func CreatePlayButtonNode()
    {
        playSpriteNode.size = CGSize(width: 128, height: 64);
        
        let buttonTexture = SKTexture(imageNamed: "PlayButton_1");
        playSpriteNode.texture = buttonTexture;
        playSpriteNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.6);
        self.addChild(playSpriteNode);
    }
    
    func CreateQuitButtonNode()
    {
        quitSpriteNode.size = CGSize(width: 128, height: 64);
        
        let buttonTexture = SKTexture(imageNamed: "QuitButton");
        quitSpriteNode.texture = buttonTexture;
        quitSpriteNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.4);
        self.addChild(quitSpriteNode);
    }
    
    func CreateHighscoreNode()
    {
        highscoreNode.fontSize = 32;
        highscoreNode.fontColor = UIColor.white;
        highscoreNode.horizontalAlignmentMode = .center;
        if let highscore = userDef.value(forKey: "highscore") {
            // do something here when a highscore exists
            highscoreNode.text = "Highscore: " + String(highscore as! Int);
        }
        else
        {
            highscoreNode.text = "Highscore: " + String(0);
        }
        highscoreNode.position = CGPoint(x: (self.view?.bounds.midX)!, y: (self.view?.bounds.midY)! - 16);
        self.addChild(highscoreNode);
    }
    
    func CreateLogoNode()
    {
        logoNode.size = CGSize(width: 160, height: 160);
        
        let logoTexture = SKTexture(imageNamed: "colourWheel");
        logoNode.texture = logoTexture;
        logoNode.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.2);
        self.addChild(logoNode);
        
        let rotate = SKAction.rotate(byAngle: CGFloat((Float.pi * 30)/180), duration: 1);
        logoNode.run(SKAction.repeatForever(rotate));
    }
}
