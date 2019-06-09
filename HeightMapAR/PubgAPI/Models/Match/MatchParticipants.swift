// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let matchParticipants = try MatchParticipants(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMatchParticipants { response in
//     if let matchParticipants = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - MatchParticipants
class MatchParticipants: Codable {
    let data: [MatchDatum]

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }

    init(data: [MatchDatum]) {
        self.data = data
    }
}

// MARK: MatchParticipants convenience initializers and mutators

extension MatchParticipants {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(MatchParticipants.self, from: data)
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
    ) -> MatchParticipants {
        return MatchParticipants(
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
