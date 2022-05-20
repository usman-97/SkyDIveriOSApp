//
//  GameViewController.swift
//  SkyDiverGame
//
//  Created by user192046 on 5/13/22.
//

import SpriteKit
import UIKit
import SwiftUI

class GameViewController : UIViewController {
    private var scene: GameScene = GameScene()
    private var isGamePaused = false
    var playerName: String = ""
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var netForceChanger: UISlider! {
        didSet {
            netForceChanger.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        }
    }
    
    // Get force value from UISlider
    @IBAction func changeNetForce(_ sender: UISlider) {
        scene.NewNetForceValue = Int(sender.value)
    }
    
    // Pause to game when pause button is pressed
    @IBAction func pauseGame(_ sender: UIButton) {
        isGamePaused = isGamePaused ? false : true
        scene.view?.isPaused = isGamePaused
        
        // Show buttons when game is paused
        homeButton.isHidden = !isGamePaused
        exitButton.isHidden = !isGamePaused
    }
    
    // Send some data to score view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameToScore" {
            let scoreViewController = segue.destination as! ScoreViewController
            scoreViewController.totalDistance = scene.Distance
            scoreViewController.totalDistanceTravelled = scene.DistanceTravelled
            
            // Get result message depending on player achievement
            if scene.Distance <= scene.DistanceTravelled {
                scoreViewController.endMessage = "Mission Passed!"
            }
            else {
                scoreViewController.endMessage = "Mission Failed :("
            }
            
            let rating = calculateRating() // Calculate rating using remaining distance and travelled distance
            let playerRecord: PlayerRecord = PlayerRecord(playerName: playerName, distanceTravelled: scene.DistanceTravelled, rating: rating)
            writeSaveFile(data: playerRecord.printResult())
            
            let allPlayerRecords: [PlayerRecord] = readSaveFile()
            scoreViewController.playerRecords = allPlayerRecords.sorted {
                $0.DistanceTravelled > $1.DistanceTravelled
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Game Scene from SKView
        // scene = GameScene(size: view.bounds.size)
        scene.size = view.bounds.size
        let skView = view as! SKView
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        // scene.view?.showsPhysics = true
        
        homeButton.isHidden = !isGamePaused
        exitButton.isHidden = !isGamePaused
        
//        let player: PlayerRecord = PlayerRecord(playerName: playerName, distanceTravelled: scene.DistanceTravelled, rating: 2)
//
//        writeSaveFile(data: player.printResult())
//
//        let r: [PlayerRecord] = readSaveFile()
        // print(r.count)
    }
    
    private func calculateRating()->Int {
        var rating: Int = 0
        
        if scene.DistanceTravelled == scene.Distance {
            rating = 10
        }
        else if scene.DistanceTravelled > (scene.Distance / 4) * 3 {
            rating = 8
        }
        else if scene.DistanceTravelled > scene.Distance / 2 {
            rating = 6
        }
        else if scene.DistanceTravelled > scene.Distance / 4 {
            rating = 4
        }
        else {
            rating = 2
        }
        
        return rating
    }
    
    func writeSaveFile(data: String) {
        let filename: String = "saveFile"
        let docDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = docDirURL.appendingPathComponent(filename).appendingPathExtension("txt")
        // let isFileExist = FileManager.default.isReadableFile(atPath: fileURL.absoluteString)
        // print(fileURL.absoluteString)
        
        do {
            var dataStr: String = ""
            let previousPlayersRecord: [PlayerRecord] = readSaveFile()
            for record in previousPlayersRecord {
                dataStr += "\(record.printResult())\n"
            }
            dataStr += data
//            if isFileExist {
//                dataStr = "\(readSaveFile())\n\(data)"
//                // print(dataStr)
//            }
            
            try dataStr.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print(error.code)
        }
    }
    
    func readSaveFile()->[PlayerRecord] {
        let filename: String = "saveFile"
        let docDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = docDirURL.appendingPathComponent(filename).appendingPathExtension("txt")
        
        // let isFileExist = FileManager.default.isReadableFile(atPath: fileURL.absoluteString)
        // print(isFileExist)
        
        var playerRecords: [PlayerRecord] = [PlayerRecord]()
        var savedPlayerRecords: String = ""
            do {
                savedPlayerRecords = try String(contentsOf: fileURL)
                let playerRecord = savedPlayerRecords.components(separatedBy: .newlines)
                for record in playerRecord {
                    let playerStats = record.components(separatedBy: ",")
                    // print(playerStats)
                    let playerName: String = playerStats[0]
                    let distanceTravelled: Int = Int(playerStats[1]) ?? 0
                    let rating: Int = Int(playerStats[2]) ?? 0

                    playerRecords.append(PlayerRecord(playerName: playerName, distanceTravelled: distanceTravelled, rating: rating))
                }
            }
            catch let error as NSError {
                // print(error.code)
            }
        
        return playerRecords
    }
}
