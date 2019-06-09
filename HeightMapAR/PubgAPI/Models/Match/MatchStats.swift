// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let matchStats = try MatchStats(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMatchStats { response in
//     if let matchStats = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - MatchStats
class MatchStats: Codable {
    let dbnOS: Int?
    let assists: Int?
    let boosts: Int?
    let damageDealt: Double?
    let deathType: MatchDeathType?
    let headshotKills: Int?
    let heals: Int?
    let killPlace: Int?
    let killPoints: Int?
    let killPointsDelta: Int?
    let killStreaks: Int?
    let kills: Int?
    let lastKillPoints: Int?
    let lastWinPoints: Int?
    let longestKill: Double?
    let mostDamage: Int?
    let name: String?
    let playerID: String?
    let rankPoints: Int?
    let revives: Int?
    let rideDistance: Double?
    let roadKills: Int?
    let swimDistance: Double?
    let teamKills: Int?
    let timeSurvived: Double?
    let vehicleDestroys: Int?
    let walkDistance: Double?
    let weaponsAcquired: Int?
    let winPlace: Int?
    let winPoints: Int?
    let winPointsDelta: Int?
    let rank: Int?
    let teamID: Int?

    enum CodingKeys: String, CodingKey {
        case dbnOS = "DBNOs"
        case assists = "assists"
        case boosts = "boosts"
        case damageDealt = "damageDealt"
        case deathType = "deathType"
        case headshotKills = "headshotKills"
        case heals = "heals"
        case killPlace = "killPlace"
        case killPoints = "killPoints"
        case killPointsDelta = "killPointsDelta"
        case killStreaks = "killStreaks"
        case kills = "kills"
        case lastKillPoints = "lastKillPoints"
        case lastWinPoints = "lastWinPoints"
        case longestKill = "longestKill"
        case mostDamage = "mostDamage"
        case name = "name"
        case playerID = "playerId"
        case rankPoints = "rankPoints"
        case revives = "revives"
        case rideDistance = "rideDistance"
        case roadKills = "roadKills"
        case swimDistance = "swimDistance"
        case teamKills = "teamKills"
        case timeSurvived = "timeSurvived"
        case vehicleDestroys = "vehicleDestroys"
        case walkDistance = "walkDistance"
        case weaponsAcquired = "weaponsAcquired"
        case winPlace = "winPlace"
        case winPoints = "winPoints"
        case winPointsDelta = "winPointsDelta"
        case rank = "rank"
        case teamID = "teamId"
    }

    init(dbnOS: Int?, assists: Int?, boosts: Int?, damageDealt: Double?, deathType: MatchDeathType?, headshotKills: Int?, heals: Int?, killPlace: Int?, killPoints: Int?, killPointsDelta: Int?, killStreaks: Int?, kills: Int?, lastKillPoints: Int?, lastWinPoints: Int?, longestKill: Double?, mostDamage: Int?, name: String?, playerID: String?, rankPoints: Int?, revives: Int?, rideDistance: Double?, roadKills: Int?, swimDistance: Double?, teamKills: Int?, timeSurvived: Double?, vehicleDestroys: Int?, walkDistance: Double?, weaponsAcquired: Int?, winPlace: Int?, winPoints: Int?, winPointsDelta: Int?, rank: Int?, teamID: Int?) {
        self.dbnOS = dbnOS
        self.assists = assists
        self.boosts = boosts
        self.damageDealt = damageDealt
        self.deathType = deathType
        self.headshotKills = headshotKills
        self.heals = heals
        self.killPlace = killPlace
        self.killPoints = killPoints
        self.killPointsDelta = killPointsDelta
        self.killStreaks = killStreaks
        self.kills = kills
        self.lastKillPoints = lastKillPoints
        self.lastWinPoints = lastWinPoints
        self.longestKill = longestKill
        self.mostDamage = mostDamage
        self.name = name
        self.playerID = playerID
        self.rankPoints = rankPoints
        self.revives = revives
        self.rideDistance = rideDistance
        self.roadKills = roadKills
        self.swimDistance = swimDistance
        self.teamKills = teamKills
        self.timeSurvived = timeSurvived
        self.vehicleDestroys = vehicleDestroys
        self.walkDistance = walkDistance
        self.weaponsAcquired = weaponsAcquired
        self.winPlace = winPlace
        self.winPoints = winPoints
        self.winPointsDelta = winPointsDelta
        self.rank = rank
        self.teamID = teamID
    }
}

// MARK: MatchStats convenience initializers and mutators

extension MatchStats {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(MatchStats.self, from: data)
        self.init(dbnOS: me.dbnOS, assists: me.assists, boosts: me.boosts, damageDealt: me.damageDealt, deathType: me.deathType, headshotKills: me.headshotKills, heals: me.heals, killPlace: me.killPlace, killPoints: me.killPoints, killPointsDelta: me.killPointsDelta, killStreaks: me.killStreaks, kills: me.kills, lastKillPoints: me.lastKillPoints, lastWinPoints: me.lastWinPoints, longestKill: me.longestKill, mostDamage: me.mostDamage, name: me.name, playerID: me.playerID, rankPoints: me.rankPoints, revives: me.revives, rideDistance: me.rideDistance, roadKills: me.roadKills, swimDistance: me.swimDistance, teamKills: me.teamKills, timeSurvived: me.timeSurvived, vehicleDestroys: me.vehicleDestroys, walkDistance: me.walkDistance, weaponsAcquired: me.weaponsAcquired, winPlace: me.winPlace, winPoints: me.winPoints, winPointsDelta: me.winPointsDelta, rank: me.rank, teamID: me.teamID)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        dbnOS: Int?? = nil,
        assists: Int?? = nil,
        boosts: Int?? = nil,
        damageDealt: Double?? = nil,
        deathType: MatchDeathType?? = nil,
        headshotKills: Int?? = nil,
        heals: Int?? = nil,
        killPlace: Int?? = nil,
        killPoints: Int?? = nil,
        killPointsDelta: Int?? = nil,
        killStreaks: Int?? = nil,
        kills: Int?? = nil,
        lastKillPoints: Int?? = nil,
        lastWinPoints: Int?? = nil,
        longestKill: Double?? = nil,
        mostDamage: Int?? = nil,
        name: String?? = nil,
        playerID: String?? = nil,
        rankPoints: Int?? = nil,
        revives: Int?? = nil,
        rideDistance: Double?? = nil,
        roadKills: Int?? = nil,
        swimDistance: Double?? = nil,
        teamKills: Int?? = nil,
        timeSurvived: Double?? = nil,
        vehicleDestroys: Int?? = nil,
        walkDistance: Double?? = nil,
        weaponsAcquired: Int?? = nil,
        winPlace: Int?? = nil,
        winPoints: Int?? = nil,
        winPointsDelta: Int?? = nil,
        rank: Int?? = nil,
        teamID: Int?? = nil
    ) -> MatchStats {
        return MatchStats(
            dbnOS: dbnOS ?? self.dbnOS,
            assists: assists ?? self.assists,
            boosts: boosts ?? self.boosts,
            damageDealt: damageDealt ?? self.damageDealt,
            deathType: deathType ?? self.deathType,
            headshotKills: headshotKills ?? self.headshotKills,
            heals: heals ?? self.heals,
            killPlace: killPlace ?? self.killPlace,
            killPoints: killPoints ?? self.killPoints,
            killPointsDelta: killPointsDelta ?? self.killPointsDelta,
            killStreaks: killStreaks ?? self.killStreaks,
            kills: kills ?? self.kills,
            lastKillPoints: lastKillPoints ?? self.lastKillPoints,
            lastWinPoints: lastWinPoints ?? self.lastWinPoints,
            longestKill: longestKill ?? self.longestKill,
            mostDamage: mostDamage ?? self.mostDamage,
            name: name ?? self.name,
            playerID: playerID ?? self.playerID,
            rankPoints: rankPoints ?? self.rankPoints,
            revives: revives ?? self.revives,
            rideDistance: rideDistance ?? self.rideDistance,
            roadKills: roadKills ?? self.roadKills,
            swimDistance: swimDistance ?? self.swimDistance,
            teamKills: teamKills ?? self.teamKills,
            timeSurvived: timeSurvived ?? self.timeSurvived,
            vehicleDestroys: vehicleDestroys ?? self.vehicleDestroys,
            walkDistance: walkDistance ?? self.walkDistance,
            weaponsAcquired: weaponsAcquired ?? self.weaponsAcquired,
            winPlace: winPlace ?? self.winPlace,
            winPoints: winPoints ?? self.winPoints,
            winPointsDelta: winPointsDelta ?? self.winPointsDelta,
            rank: rank ?? self.rank,
            teamID: teamID ?? self.teamID
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
