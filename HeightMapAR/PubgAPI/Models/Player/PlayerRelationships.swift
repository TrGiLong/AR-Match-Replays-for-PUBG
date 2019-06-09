// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let playerRelationships = try PlayerRelationships(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responsePlayerRelationships { response in
//     if let playerRelationships = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - PlayerRelationships
class PlayerRelationships: Codable {
    let assets: PlayerAssets
    let matches: PlayerMatches

    enum CodingKeys: String, CodingKey {
        case assets = "assets"
        case matches = "matches"
    }

    init(assets: PlayerAssets, matches: PlayerMatches) {
        self.assets = assets
        self.matches = matches
    }
}

// MARK: PlayerRelationships convenience initializers and mutators

extension PlayerRelationships {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(PlayerRelationships.self, from: data)
        self.init(assets: me.assets, matches: me.matches)
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
        assets: PlayerAssets? = nil,
        matches: PlayerMatches? = nil
    ) -> PlayerRelationships {
        return PlayerRelationships(
            assets: assets ?? self.assets,
            matches: matches ?? self.matches
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
