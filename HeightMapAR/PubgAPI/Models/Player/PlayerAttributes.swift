// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let playerAttributes = try PlayerAttributes(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responsePlayerAttributes { response in
//     if let playerAttributes = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - PlayerAttributes
class PlayerAttributes: Codable {
    let stats: JSONNull?
    let titleID: String
    let shardID: String
    let createdAt: Date
    let updatedAt: Date
    let patchVersion: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case stats = "stats"
        case titleID = "titleId"
        case shardID = "shardId"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case patchVersion = "patchVersion"
        case name = "name"
    }

    init(stats: JSONNull?, titleID: String, shardID: String, createdAt: Date, updatedAt: Date, patchVersion: String, name: String) {
        self.stats = stats
        self.titleID = titleID
        self.shardID = shardID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.patchVersion = patchVersion
        self.name = name
    }
}

// MARK: PlayerAttributes convenience initializers and mutators

extension PlayerAttributes {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(PlayerAttributes.self, from: data)
        self.init(stats: me.stats, titleID: me.titleID, shardID: me.shardID, createdAt: me.createdAt, updatedAt: me.updatedAt, patchVersion: me.patchVersion, name: me.name)
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
        stats: JSONNull?? = nil,
        titleID: String? = nil,
        shardID: String? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        patchVersion: String? = nil,
        name: String? = nil
    ) -> PlayerAttributes {
        return PlayerAttributes(
            stats: stats ?? self.stats,
            titleID: titleID ?? self.titleID,
            shardID: shardID ?? self.shardID,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            patchVersion: patchVersion ?? self.patchVersion,
            name: name ?? self.name
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
