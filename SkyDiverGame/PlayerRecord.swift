//
//  ScoreModel.swift
//  SkyDiverGame
//
//  Created by Usman Shabir on 18/05/2022.
//

//struct PlayerRecord : Decodable {
//    var playerName: String
//    var distanceTravelled: Int
//    var rating: Int
//
////    func convertToDictionary()->[String: Any] {
////        let dic: [String: Any] = [
////            "playerName":
////        ]
////    }
// }

class PlayerRecord {
    private var playerName: String
    private var distanceTravelled: Int
    private var rating: Int
    
    public var PlayerName: String {
        get { return playerName }
    }
    
    public var DistanceTravelled: Int {
        get { return distanceTravelled }
    }
    
    public var Rating: Int {
        get { return rating }
    }

    init(playerName: String, distanceTravelled: Int, rating: Int) {
        self.playerName = playerName
        self.distanceTravelled = distanceTravelled
        self.rating = rating
    }

//    func convertToDictionary()->[String: Any] {
//        return [
//            "PlayerRecord": [
//                "playerName": self.playerName,
//                "distanceTravelled": self.distanceTravelled,
//                "rating": self.rating
//            ]
//        ]
//    }
//
//    static func createPlayerRecord(json: Dictionary<String, Any>)->PlayerRecord {
//        return PlayerRecord(playerName: json["playerName"] as! String, distanceTravelled: json["distanceTravelled"] as! Int, rating: json["rating"] as! Int)
//    }
//
//    enum CodingKeys: String, CodingKey {
//            case playerName = "playerName"
//            case distanceTravelled = "distanceTravelled"
//            case rating = "rating"
//        }

    func printResult()->String {
        return "\(playerName),\(distanceTravelled),\(rating),"
    }
}
