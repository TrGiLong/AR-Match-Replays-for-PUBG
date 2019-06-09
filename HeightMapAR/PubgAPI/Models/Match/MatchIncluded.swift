// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let matchIncluded = try MatchIncluded(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMatchIncluded { response in
//     if let matchIncluded = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - MatchIncluded
class MatchIncluded: Codable {
    let type: MatchType
    let id: String
    let attributes: MatchIncludedAttributes
    let relationships: MatchIncludedRelationships?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case id = "id"
        case attributes = "attributes"
        case relationships = "relationships"
    }

    init(type: MatchType, id: String, attributes: MatchIncludedAttributes, relationships: MatchIncludedRelationships?) {
        self.type = type
        self.id = id
        self.attributes = attributes
        self.relationships = relationships
    }
}

// MARK: MatchIncluded convenience initializers and mutators

extension MatchIncluded {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(MatchIncluded.self, from: data)
        self.init(type: me.type, id: me.id, attributes: me.attributes, relationships: me.relationships)
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
        type: MatchType? = nil,
        id: String? = nil,
        attributes: MatchIncludedAttributes? = nil,
        relationships: MatchIncludedRelationships?? = nil
    ) -> MatchIncluded {
        return MatchIncluded(
            type: type ?? self.type,
            id: id ?? self.id,
            attributes: attributes ?? self.attributes,
            relationships: relationships ?? self.relationships
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
