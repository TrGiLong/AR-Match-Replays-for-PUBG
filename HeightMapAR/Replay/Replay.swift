//
//  Replay.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 11.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import SceneKit

class Replay {
    
    var map : Map
    let mapInfo : MapInfo
    let events : [Event]
    
    var currentEventIndex : Int = 0
    
    let assetPreload = AssetPreload()
    
    var isReplayPause = true
    
    let kAttackLifeTime : TimeInterval = 1
    
    var players : Set<SCNNode> = []
    var blueZone : SCNNode?
    var redZone  : SCNNode?
    
    var blueZoneOptions : [BlueZoneCustomOption] = []
    
    var mainPlayerId : String
    
    let kMovingActionKey = "movingActionKey"
    let kHP = "HP"
    
    let ui : UIController?
    
    init(_ mapInfo : MapInfo,_ map : Map,_ events : [Event],_ ui : UIController? = nil, _ mainPlayer : String) {
        self.mapInfo = mapInfo
        self.map = map
        self.events = events
        eventLoopTime = events[0]._D
        self.mainPlayerId = mainPlayer
        self.ui = ui
    }
    
    func play() {
        isReplayPause = false
    }
    
    func pause() {
        isReplayPause = true
    }
    
    var eventLoopTime : TimeInterval = 0
    var eventLoopTimeInterval : TimeInterval = 0.1
    var previousTime : TimeInterval?
    var speed = 1.0
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let deltaTime = time - (previousTime ?? time)
        previousTime = time
        
        if !isReplayPause {
            while (events[currentEventIndex]._D < eventLoopTime) {
                processEvent(event: events[currentEventIndex])
                currentEventIndex+=1
                if (currentEventIndex >= events.count) {
                    isReplayPause = true
                    break;
                }
            }
        }
        
        eventLoopTime += deltaTime * speed
    }
    
    

}
