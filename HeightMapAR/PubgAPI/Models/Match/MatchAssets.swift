// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let matchAssets = try MatchAssets(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMatchAssets { response in
//     if let matchAssets = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - MatchAssets
class MatchAssets: Codable {
    let data: [MatchDatum]

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }

    init(data: [MatchDatum]) {
        self.data = data
    }
}

// MARK: MatchAssets convenience initializers and mutators

extension MatchAssets {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(MatchAssets.self, from: data)
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
        data: [MatchDatum]? = nil
    ) -> MatchAssets {
        return MatchAssets(
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
