import Foundation

enum MatchDeathType: String, Codable {
    case alive = "alive"
    case byplayer = "byplayer"
    case suicide = "suicide"
    case logout = "logout"
    case byzone = "byzone"
}
