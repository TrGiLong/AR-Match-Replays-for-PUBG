// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let playerAssets = try PlayerAssets(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responsePlayerAssets { response in
//     if let playerAssets = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - PlayerAssets
class PlayerAssets: Codable {
    let data: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }

    init(data: [JSONAny]) {
        self.data = data
    }
}

// MARK: PlayerAssets convenience initializers and mutators

extension PlayerAssets {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(PlayerAssets.self, from: data)
        self.init(data: me.data)
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
        data: [JSONAny]? = nil
    ) -> PlayerAssets {
        return PlayerAssets(
            data: data ?? self.data
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
