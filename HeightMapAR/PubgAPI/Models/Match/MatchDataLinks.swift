// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let matchDataLinks = try MatchDataLinks(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMatchDataLinks { response in
//     if let matchDataLinks = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - MatchDataLinks
class MatchDataLinks: Codable {
    let linksSelf: String
    let schema: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case schema = "schema"
    }

    init(linksSelf: String, schema: String) {
        self.linksSelf = linksSelf
        self.schema = schema
    }
}

// MARK: MatchDataLinks convenience initializers and mutators

extension MatchDataLinks {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(MatchDataLinks.self, from: data)
        self.init(linksSelf: me.linksSelf, schema: me.schema)
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
        linksSelf: String? = nil,
        schema: String? = nil
    ) -> MatchDataLinks {
        return MatchDataLinks(
            linksSelf: linksSelf ?? self.linksSelf,
            schema: schema ?? self.schema
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
