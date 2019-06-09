// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let matchIncludedAttributes = try MatchIncludedAttributes(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMatchIncludedAttributes { response in
//     if let matchIncludedAttributes = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - MatchIncludedAttributes
class MatchIncludedAttributes: Codable {
    let actor: String?
    let shardID: MatchShardID?
    let stats: MatchStats?
    let won: String?
    let url: String?
    let name: String?
    let attributesDescription: String?
    let createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case actor = "actor"
        case shardID = "shardId"
        case stats = "stats"
        case won = "won"
        case url = "URL"
        case name = "name"
        case attributesDescription = "description"
        case createdAt = "createdAt"
    }

    init(actor: String?, shardID: MatchShardID?, stats: MatchStats?, won: String?, url: String?, name: String?, attributesDescription: String?, createdAt: Date?) {
        self.actor = actor
        self.shardID = shardID
        self.stats = stats
        self.won = won
        self.url = url
        self.name = name
        self.attributesDescription = attributesDescription
        self.createdAt = createdAt
    }
}

// MARK: MatchIncludedAttributes convenience initializers and mutators

extension MatchIncludedAttributes {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(MatchIncludedAttributes.self, from: data)
        self.init(actor: me.actor, shardID: me.shardID, stats: me.stats, won: me.won, url: me.url, name: me.name, attributesDescription: me.attributesDescription, createdAt: me.createdAt)
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
        actor: String?? = nil,
        shardID: MatchShardID?? = nil,
        stats: MatchStats?? = nil,
        won: String?? = nil,
        url: String?? = nil,
        name: String?? = nil,
        attributesDescription: String?? = nil,
        createdAt: Date?? = nil
    ) -> MatchIncludedAttributes {
        return MatchIncludedAttributes(
            actor: actor ?? self.actor,
            shardID: shardID ?? self.shardID,
            stats: stats ?? self.stats,
            won: won ?? self.won,
            url: url ?? self.url,
            name: name ?? self.name,
            attributesDescription: attributesDescription ?? self.attributesDescription,
            createdAt: createdAt ?? self.createdAt
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
