// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let playerMatchesDatum = try PlayerMatchesDatum(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responsePlayerMatchesDatum { response in
//     if let playerMatchesDatum = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - PlayerMatchesDatum
class PlayerMatchesDatum: Codable {
    let type: PlayerType
    let id: String

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case id = "id"
    }

    init(type: PlayerType, id: String) {
        self.type = type
        self.id = id
    }
}

// MARK: PlayerMatchesDatum convenience initializers and mutators

extension PlayerMatchesDatum {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(PlayerMatchesDatum.self, from: data)
        self.init(type: me.type, id: me.id)
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
        type: PlayerType? = nil,
        id: String? = nil
    ) -> PlayerMatchesDatum {
        return PlayerMatchesDatum(
            type: type ?? self.type,
            id: id ?? self.id
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
