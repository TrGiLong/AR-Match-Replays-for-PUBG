// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let matchDataAttributes = try MatchDataAttributes(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMatchDataAttributes { response in
//     if let matchDataAttributes = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - MatchDataAttributes
class MatchDataAttributes: Codable {
    let isCustomMatch: Bool
    let seasonState: String
    let gameMode: String
    let mapName: String
    let stats: JSONNull?
    let titleID: String
    let shardID: MatchShardID
    let tags: JSONNull?
    let createdAt: Date
    let duration: Int

    enum CodingKeys: String, CodingKey {
        case isCustomMatch = "isCustomMatch"
        case seasonState = "seasonState"
        case gameMode = "gameMode"
        case mapName = "mapName"
        case stats = "stats"
        case titleID = "titleId"
        case shardID = "shardId"
        case tags = "tags"
        case createdAt = "createdAt"
        case duration = "duration"
    }

    init(isCustomMatch: Bool, seasonState: String, gameMode: String, mapName: String, stats: JSONNull?, titleID: String, shardID: MatchShardID, tags: JSONNull?, createdAt: Date, duration: Int) {
        self.isCustomMatch = isCustomMatch
        self.seasonState = seasonState
        self.gameMode = gameMode
        self.mapName = mapName
        self.stats = stats
        self.titleID = titleID
        self.shardID = shardID
        self.tags = tags
        self.createdAt = createdAt
        self.duration = duration
    }
}

// MARK: MatchDataAttributes convenience initializers and mutators

extension MatchDataAttributes {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(MatchDataAttributes.self, from: data)
        self.init(isCustomMatch: me.isCustomMatch, seasonState: me.seasonState, gameMode: me.gameMode, mapName: me.mapName, stats: me.stats, titleID: me.titleID, shardID: me.shardID, tags: me.tags, createdAt: me.createdAt, duration: me.duration)
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
        isCustomMatch: Bool? = nil,
        seasonState: String? = nil,
        gameMode: String? = nil,
        mapName: String? = nil,
        stats: JSONNull?? = nil,
        titleID: String? = nil,
        shardID: MatchShardID? = nil,
        tags: JSONNull?? = nil,
        createdAt: Date? = nil,
        duration: Int? = nil
    ) -> MatchDataAttributes {
        return MatchDataAttributes(
            isCustomMatch: isCustomMatch ?? self.isCustomMatch,
            seasonState: seasonState ?? self.seasonState,
            gameMode: gameMode ?? self.gameMode,
            mapName: mapName ?? self.mapName,
            stats: stats ?? self.stats,
            titleID: titleID ?? self.titleID,
            shardID: shardID ?? self.shardID,
            tags: tags ?? self.tags,
            createdAt: createdAt ?? self.createdAt,
            duration: duration ?? self.duration
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
