// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let matchIncludedRelationships = try MatchIncludedRelationships(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMatchIncludedRelationships { response in
//     if let matchIncludedRelationships = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - MatchIncludedRelationships
class MatchIncludedRelationships: Codable {
    let team: MatchTeam
    let participants: MatchParticipants

    enum CodingKeys: String, CodingKey {
        case team = "team"
        case participants = "participants"
    }

    init(team: MatchTeam, participants: MatchParticipants) {
        self.team = team
        self.participants = participants
    }
}

// MARK: MatchIncludedRelationships convenience initializers and mutators

extension MatchIncludedRelationships {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(MatchIncludedRelationships.self, from: data)
        self.init(team: me.team, participants: me.participants)
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
        team: MatchTeam? = nil,
        participants: MatchParticipants? = nil
    ) -> MatchIncludedRelationships {
        return MatchIncludedRelationships(
            team: team ?? self.team,
            participants: participants ?? self.participants
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
