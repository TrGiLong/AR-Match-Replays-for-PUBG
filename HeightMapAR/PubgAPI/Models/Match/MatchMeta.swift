// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let matchMeta = try MatchMeta(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMatchMeta { response in
//     if let matchMeta = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - MatchMeta
class MatchMeta: Codable {

    init() {
    }
}

// MARK: MatchMeta convenience initializers and mutators

extension MatchMeta {
    convenience init(data: Data) throws {
        let _ = try newJSONDecoder().decode(MatchMeta.self, from: data)
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
    ) -> MatchMeta {
        return MatchMeta(
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
