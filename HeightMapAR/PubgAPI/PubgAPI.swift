//
//  PubgAPI.swift
//  pubgAPI
//
//  Created by Tran Giang Long on 08.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum PubgPlatform : String {
    case steam  = "steam"
    case psn    = "psn"
    case xbox   = "xbox"
    case kakao  = "kakao"
}

class PubgAPI {
    
    static private let headers: HTTPHeaders = [
        "Authorization": "Bearer \(apiKey)",
        "Accept": "application/vnd.api+json"
    ]
    
    static let apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIwNzgxYmFmMC02YmNlLTAxMzctZmI1My0wNmRjMWRmNzRmNjMiLCJpc3MiOiJnYW1lbG9ja2VyIiwiaWF0IjoxNTU5OTY1NjM1LCJwdWIiOiJibHVlaG9sZSIsInRpdGxlIjoicHViZyIsImFwcCI6InRyYW5naWFuZ2xvbmc0In0.WdDvbuPud7KauTK69VrgxUJsYt8k-DdbyiPm5VKteZ4"
    
    static let host = "https://api.pubg.com/shards"
    
    static func getPlayer(name : String, platform : PubgPlatform) -> Single<Player> {
        
        return Single.create {single in
            let params : Parameters = ["filter[playerNames]" : name]
            
            Alamofire.request("\(host)/\(platform.rawValue)/players", method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON() { (response) in
                
                if response.response?.statusCode == 404 {
                    // Player not found
                    single(.error(PlayerException.notFound))
                }
                
                if let json = response.result.value as? [String : Any] {
                    do {
                        
                        single(.success(try Player(json: json)))
                    } catch PlayerException.initFailed {
                        single(.error(PlayerException.initFailed))
                    } catch {
                        single(.error(error))
                    }
                }
                
            }
            return Disposables.create();
        }
    }
}