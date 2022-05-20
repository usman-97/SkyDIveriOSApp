//
//  ScoreViewController.swift
//  SkyDiverGame
//
//  Created by Usman Shabir on 17/05/2022.
//

import UIKit

class ScoreViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    var totalDistance: Int = 0
    var totalDistanceTravelled: Int = 0
    var endMessage: String = ""
    
    let cellIdentifier = "resultCellIdentifier"
    // let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var playerRecords = [PlayerRecord]()
    let icons = [UIImage(systemName: "person.fill"), UIImage(systemName: "bookmark.fill"), UIImage(systemName: "location.fill"), UIImage(systemName: "star.fill")]
    
    @IBOutlet weak var resultMessage: UILabel!
    
    // Return total number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Custom cell in table view
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
        // cell.imageView?.image = icons[indexPath.row] // Assign icon to cell
        if (indexPath.row == 0) {
            cell.imageView?.image = UIImage(systemName: "star.fill")
        }
        
        let playerName: String = playerRecords[indexPath.row].PlayerName
        let distanceTravelled: String = String(playerRecords[indexPath.row].DistanceTravelled)
        let rating: String = String(playerRecords[indexPath.row].Rating)
        
        cell.textLabel?.text = "\(playerName) | \(distanceTravelled)KM | \(rating)" // Assign value to cell
        cell.textLabel?.font = UIFont.systemFont(ofSize: 30.0)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.backgroundColor = UIColor(red: 179/255, green: 229/255, blue: 252/255, alpha: 1.0)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultMessage.text = endMessage
        resultMessage.adjustsFontSizeToFitWidth = true
    }
}
