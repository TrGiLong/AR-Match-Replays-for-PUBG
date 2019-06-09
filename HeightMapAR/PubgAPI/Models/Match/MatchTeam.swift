// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let matchTeam = try MatchTeam(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMatchTeam { response in
//     if let matchTeam = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - MatchTeam
class MatchTeam: Codable {
    let data: JSONNull?

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }

    init(data: JSONNull?) {
        self.data = data
    }
}

// MARK: MatchTeam convenience initializers and mutators

extension MatchTeam {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(MatchTeam.self, from: data)
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
        data: JSONNull?? = nil
    ) -> MatchTeam {
        return MatchTeam(
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
