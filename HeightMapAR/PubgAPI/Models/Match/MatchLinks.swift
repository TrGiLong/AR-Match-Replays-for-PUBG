// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let matchLinks = try MatchLinks(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMatchLinks { response in
//     if let matchLinks = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - MatchLinks
class MatchLinks: Codable {
    let linksSelf: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }

    init(linksSelf: String) {
        self.linksSelf = linksSelf
    }
}

// MARK: MatchLinks convenience initializers and mutators

extension MatchLinks {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(MatchLinks.self, from: data)
        self.init(linksSelf: me.linksSelf)
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
        linksSelf: String? = nil
    ) -> MatchLinks {
        return MatchLinks(
            linksSelf: linksSelf ?? self.linksSelf
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
