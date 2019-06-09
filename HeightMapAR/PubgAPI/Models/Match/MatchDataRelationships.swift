// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let matchDataRelationships = try MatchDataRelationships(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMatchDataRelationships { response in
//     if let matchDataRelationships = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - MatchDataRelationships
class MatchDataRelationships: Codable {
    let rosters: MatchRosters
    let assets: MatchAssets

    enum CodingKeys: String, CodingKey {
        case rosters = "rosters"
        case assets = "assets"
    }

    init(rosters: MatchRosters, assets: MatchAssets) {
        self.rosters = rosters
        self.assets = assets
    }
}

// MARK: MatchDataRelationships convenience initializers and mutators

extension MatchDataRelationships {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(MatchDataRelationships.self, from: data)
        self.init(rosters: me.rosters, assets: me.assets)
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
        rosters: MatchRosters? = nil,
        assets: MatchAssets? = nil
    ) -> MatchDataRelationships {
        return MatchDataRelationships(
            rosters: rosters ?? self.rosters,
            assets: assets ?? self.assets
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
