// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let playerMeta = try PlayerMeta(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responsePlayerMeta { response in
//     if let playerMeta = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - PlayerMeta
class PlayerMeta: Codable {

    init() {
    }
}

// MARK: PlayerMeta convenience initializers and mutators

extension PlayerMeta {
    convenience init(data: Data) throws {
        let _ = try newJSONDecoder().decode(PlayerMeta.self, from: data)
        self.init()
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
    ) -> PlayerMeta {
        return PlayerMeta(
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
