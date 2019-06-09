// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let player = try Player(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responsePlayer { response in
//     if let player = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - Player
class Player: Codable {
    let data: [PlayerDatum]
    let links: PlayerLinks
    let meta: PlayerMeta

    enum CodingKeys: String, CodingKey {
        case data = "data"
        case links = "links"
        case meta = "meta"
    }

    init(data: [PlayerDatum], links: PlayerLinks, meta: PlayerMeta) {
        self.data = data
        self.links = links
        self.meta = meta
    }
}

// MARK: Player convenience initializers and mutators

extension Player {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Player.self, from: data)
        self.init(data: me.data, links: me.links, meta: me.meta)
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
        data: [PlayerDatum]? = nil,
        links: PlayerLinks? = nil,
        meta: PlayerMeta? = nil
    ) -> Player {
        return Player(
            data: data ?? self.data,
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
