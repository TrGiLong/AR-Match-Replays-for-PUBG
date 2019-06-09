// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let match = try Match(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMatch { response in
//     if let match = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - Match
class Match: Codable {
    let data: MatchData
    let included: [MatchIncluded]
    let links: MatchLinks
    let meta: MatchMeta

    enum CodingKeys: String, CodingKey {
        case data = "data"
        case included = "included"
        case links = "links"
        case meta = "meta"
    }

    init(data: MatchData, included: [MatchIncluded], links: MatchLinks, meta: MatchMeta) {
        self.data = data
        self.included = included
        self.links = links
        self.meta = meta
    }
}

// MARK: Match convenience initializers and mutators

extension Match {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Match.self, from: data)
        self.init(data: me.data, included: me.included, links: me.links, meta: me.meta)
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
        data: MatchData? = nil,
        included: [MatchIncluded]? = nil,
        links: MatchLinks? = nil,
        meta: MatchMeta? = nil
    ) -> Match {
        return Match(
            data: data ?? self.data,
            included: included ?? self.included,
            links: links ?? self.links,
            meta: meta ?? self.meta
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
