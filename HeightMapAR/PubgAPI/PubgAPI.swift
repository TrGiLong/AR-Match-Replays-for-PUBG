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

enum PubgError : Error {
    case notFound
}

class PubgAPI {
 
    static let apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIwNzgxYmFmMC02YmNlLTAxMzctZmI1My0wNmRjMWRmNzRmNjMiLCJpc3MiOiJnYW1lbG9ja2VyIiwiaWF0IjoxNTU5OTY1NjM1LCJwdWIiOiJibHVlaG9sZSIsInRpdGxlIjoicHViZyIsImFwcCI6InRyYW5naWFuZ2xvbmc0In0.WdDvbuPud7KauTK69VrgxUJsYt8k-DdbyiPm5VKteZ4"
    
    static let host = "https://api.pubg.com/shards"
    
    static func getPlayer(name : String, platform : PubgPlatform) -> Single<Player> {
        
        return Single.create {single in
            let params : Parameters = ["filter[playerNames]" : name]
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(apiKey)",
                "Accept": "application/vnd.api+json"
            ]
            
            Alamofire.request("\(host)/\(platform.rawValue)/players", method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responsePlayer(completionHandler: { (response) in
                if let player = response.result.value {
                    single(.success(player))
                } else {
                    single(.error(PubgError.notFound))
                }
            })
            
            return Disposables.create();
        }
    }
    
    static func getMatch(playerMatch : PlayerMatchesDatum, platform : PubgPlatform) -> Single<Match> {
        
        return Single.create {single in
            
            let headers: HTTPHeaders = [
                "Accept": "application/vnd.api+json"
            ]
            
            Alamofire.request("\(host)/\(platform.rawValue)/matches/\(playerMatch.id)", method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).responseMatch(completionHandler: { (response) in
                if let match = response.result.value {
                    single(.success(match))
                } else {
                    single(.error(PubgError.notFound))
                }
            })
            
            return Disposables.create();
        }
    }
    
    static func getTelemtry(url : String) -> Single<[Event]> {
        return Single.create {single in
            
            let headers: HTTPHeaders = [
                "Accept": "application/vnd.api+json"
            ]
            
            Alamofire.request(url, method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
                
                if let data = response.result.value as? [Any] {
                    
                    var events : [Event] = []
                    for eventJson in data {
                        if let event = EventFactory.produce(json: eventJson as! [String : Any]) {
                            events.append(event)
                        }
                    }
                    
                    single(.success(events))
                } else {
                    single(.error(PubgError.notFound))
                }
                
            })
            
            return Disposables.create();
        }
    }
}
