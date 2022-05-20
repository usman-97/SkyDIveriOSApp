//
//  InstructionsViewController.swift
//  SkyDiverGame
//
//  Created by Usman Shabir on 18/05/2022.
//

import UIKit

class InstructionsViewController : UIViewController {
    
    @IBOutlet weak var playerNameField: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PageToGame" {
            let gameViewController = segue.destination as! GameViewController
            
            if (!playerNameField.text!.isEmpty) {
                gameViewController.playerName = playerNameField.text ?? "Unknown Player"
            }
            else {
                gameViewController.playerName = "Unknown Player"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
