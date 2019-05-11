//
//  GameScene.swift
//  ColourGame
//
//  Created by Sunny Peebles on 6/05/19.
//  Copyright © 2019 Sunny Peebles. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var colourBall = SKShapeNode(circleOfRadius: 32);
    private var colourObstacle = SKSpriteNode();
    
    var deltaTime: CGFloat = 0;
    
    var possibleColours = [UIColor]();
    enum selectedColour: Int{
        case PURPLE = 0
        case GREEN = 1
        case YELLOW = 2
        case PINK = 3
    }
    
    var currentTopColour = selectedColour.PURPLE;
    var currentBallColour: selectedColour?;
    
    // Game Variables
    // baseBallMoveSpeed is easiest.
    // As you gain points, currentBallMoveSpeed is incremented making the game harder
    var baseBallMoveSpeed: CGFloat = 75;
    var currentBallMoveSpeed: CGFloat = 0;
    
    var currentScore: Int = 0;
    var pointGainAllowed = true;
    
    let userDef = UserDefaults.standard;
    let highscoreNode = SKLabelNode(fontNamed: "HelveticaNeue-Bold");
    var currentScoreTextNode = SKLabelNode(fontNamed: "HelveticaNeue-Bold");
    
    var ballStartPoint = CGPoint();
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.init(red: 0.225, green: 0.225, blue: 0.225, alpha: 1);
        
        InitialiseColourArray();
        CreateBallNode();
        CreateObstacle();
        CreateScoreLabels();
        
        pointGainAllowed = true;
        currentBallMoveSpeed = baseBallMoveSpeed;
    }
    
    func InitialiseColourArray()
    {
        // Populate the possibleColours array with possible colours the ball can be
        // Using UIColor.init to get colours most similar to the actual colour wheel colours
        possibleColours.append(UIColor.init(red: 0.473, green: 0.06, blue: 0.984, alpha: 1)); // Purple
        possibleColours.append(UIColor.init(red: 0.26, green: 0.715, blue: 0.219, alpha: 1)); // Green
        possibleColours.append(UIColor.init(red: 0.984, green: 0.96, blue: 0.273, alpha: 1)); // Yellow
        possibleColours.append(UIColor.init(red: 0.895, green: 0.23, blue: 0.67, alpha: 1));  // Pink
    }
    
    func CreateBallNode()
    {
        RandomiseBallColour();
        
        colourBall.strokeColor = UIColor.black;
        //colourBall.size = CGSize(width: 64, height: 64);
        //colourBall.color = possibleColours.randomElement()!;
        ballStartPoint = CGPoint(x: self.frame.midX, y: self.frame.height);
        colourBall.position = ballStartPoint;
        self.addChild(colourBall);
    }
    
    func CreateObstacle()
    {
        colourObstacle.size = CGSize(width: 160, height: 160);
        let obstacleTexture = SKTexture(imageNamed: "colourWheel");
        colourObstacle.texture = obstacleTexture;
        colourObstacle.position = CGPoint(x: self.frame.midX, y: self.frame.size.height * 0.2);
        self.addChild(colourObstacle);
    }
    
    func RandomElement(_ maxSize: Int) -> Int
    {
        return Int(arc4random_uniform(UInt32(maxSize)));
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self)
        {
            if (pointGainAllowed != false)
            {
                // If tapping on the left side of the screen
                // Rotate left
                if location.x < (self.view?.bounds.midX)!
                {
                    let action = SKAction.rotate(byAngle: CGFloat((Float.pi * 90)/180), duration: 0.1);
                    colourObstacle.run(action);
                    
                    switch (currentTopColour){
                        
                    case .PURPLE:
                        currentTopColour = selectedColour.GREEN;
                    case .GREEN:
                        currentTopColour = selectedColour.YELLOW;
                    case .YELLOW:
                        currentTopColour = selectedColour.PINK;
                    case .PINK:
                        currentTopColour = selectedColour.PURPLE;
                        //@unknown default:
                        //print("Top Colour may be messed up");
                    }
                }
                else if location.x > (self.view?.bounds.midX)!
                {
                    let action = SKAction.rotate(byAngle: CGFloat((Float.pi * -90)/180), duration: 0.1);
                    colourObstacle.run(action);
                    
                    switch (currentTopColour){
                        
                    case .PURPLE:
                        currentTopColour = selectedColour.PINK;
                    case .GREEN:
                        currentTopColour = selectedColour.PURPLE;
                    case .YELLOW:
                        currentTopColour = selectedColour.GREEN;
                    case .PINK:
                        currentTopColour = selectedColour.YELLOW;
                        //@unknown default:
                        //print("Top Colour may be messed up");
                    }
                }
            }
        }
    }
    
    /*
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self)
        {
    
        }
    }
    */
    
    var lastUpdateTime: CFTimeInterval = 0;
    
    override func update(_ currentTime: CFTimeInterval) {
        // Called before each frame is rendered
        // Calculate deltaTime
        deltaTime = CGFloat(currentTime - lastUpdateTime);
        if deltaTime > 1
        {
            deltaTime = 1 / 60;
        }
        lastUpdateTime = currentTime;
        
        // Is the ball radius and wheel radius in range of eachother
        if ((colourBall.position.y - 32) <= (colourObstacle.position.y + 80))
        {
            // If the top colour of the wheel is not the same as the ball
            if (currentTopColour != currentBallColour)
            {
                // Points cannot be gained currently - temporarily | Player failed
                pointGainAllowed = false;
                // Fade the ball out here
                if (colourBall.alpha > 0)
                {
                    colourBall.alpha -= (deltaTime / 0.3);
                }
                else if (colourBall.alpha <= 0)
                {
                    // Player failed. Go back to main menu
                    let newScene = MainMenu(size: (self.view?.bounds.size)!);
                    let transition = SKTransition.crossFade(withDuration: 0.3);
                    self.view?.presentScene(newScene, transition: transition);
                    transition.pausesOutgoingScene = false;
                    transition.pausesIncomingScene = true;
                }
            }
        }
        // Move the ball closer to the colour dial
        if ((colourBall.position.y > colourObstacle.position.y))
        {
            if (pointGainAllowed)
            {
                colourBall.position.y -= currentBallMoveSpeed * deltaTime;
            }
        }
        else    // If the ball has reach the centre of the colour wheel, fade it out
        {
            if (colourBall.alpha > 0)
            {
                colourBall.alpha -= (deltaTime / 0.3);
            }
                // When the ball has fully faded out, update currentScore and highscore if necessary
            else if (colourBall.alpha <= 0)
            {
                if (currentTopColour == currentBallColour)
                {
                    pointGainAllowed = true;
                    // Increment the score
                    currentScore += 1;
                    currentBallMoveSpeed += 15;
                    currentScoreTextNode.text = String(currentScore);
                    
                    // See if it's a new Highscore, if so update the highscore
                    if (GetHighscore() < currentScore)
                    {
                        SetHighscore(newHighscore: currentScore);
                    }
                    
                    // Possibly change the colour of the ball
                    RandomiseBallColour();
                    
                    colourBall.position = ballStartPoint;
                    colourBall.alpha = 1;
                }
            }
        }
        
    }
    
    func SetHighscore(newHighscore: Int)
    {
        userDef.setValue(newHighscore, forKey: "highscore");
        highscoreNode.text = "Highscore: " + String(newHighscore);
        userDef.synchronize();
    }
    
    func GetHighscore()->Int
    {
        if let highscore = userDef.value(forKey: "highscore") {
            // do something here when a highscore exists
            return highscore as! Int;
        }
        else
        {
            return 0;
        }
    }
    
    func RandomiseBallColour()
    {
        let randIndex = RandomElement(possibleColours.count);
        colourBall.fillColor = possibleColours[randIndex];
        
        switch (randIndex)
        {
        case 0:
            currentBallColour = .PURPLE;
        case 1:
            currentBallColour = .GREEN;
        case 2:
            currentBallColour = .YELLOW;
        case 3:
            currentBallColour = .PINK;
        default:
            print("Index appears out of range");
        }
    }
    
    func CreateScoreLabels()
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
        highscoreNode.position = CGPoint(x: (self.view?.bounds.midX)!, y: (self.view?.bounds.minY)! + 40);
        self.addChild(highscoreNode);
        
        currentScoreTextNode.fontSize = 32;
        currentScoreTextNode.fontColor = UIColor.white;
        currentScoreTextNode.horizontalAlignmentMode = .center;
        currentScoreTextNode.text = String(currentScore);
        currentScoreTextNode.position = CGPoint(x: (self.view?.bounds.midX)!, y: (self.view?.bounds.midY)!);
        self.addChild(currentScoreTextNode);
    }
}
