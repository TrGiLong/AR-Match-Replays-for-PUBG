// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let matchData = try MatchData(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMatchData { response in
//     if let matchData = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - MatchData
class MatchData: Codable {
    let type: String
    let id: String
    let attributes: MatchDataAttributes
    let relationships: MatchDataRelationships
    let links: MatchDataLinks

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case id = "id"
        case attributes = "attributes"
        case relationships = "relationships"
        case links = "links"
    }

    init(type: String, id: String, attributes: MatchDataAttributes, relationships: MatchDataRelationships, links: MatchDataLinks) {
        self.type = type
        self.id = id
        self.attributes = attributes
        self.relationships = relationships
        self.links = links
    }
}

// MARK: MatchData convenience initializers and mutators

extension MatchData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(MatchData.self, from: data)
        self.init(type: me.type, id: me.id, attributes: me.attributes, relationships: me.relationships, links: me.links)
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
        type: String? = nil,
        id: String? = nil,
        attributes: MatchDataAttributes? = nil,
        relationships: MatchDataRelationships? = nil,
        links: MatchDataLinks? = nil
    ) -> MatchData {
        return MatchData(
            type: type ?? self.type,
            id: id ?? self.id,
            attributes: attributes ?? self.attributes,
            relationships: relationships ?? self.relationships,
            links: links ?? self.links
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
