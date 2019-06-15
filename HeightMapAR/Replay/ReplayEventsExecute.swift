//
//  ReplayEventsExecute.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 15.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import SceneKit

extension Replay {
    func processEvent(event : Event) {
        guard let eventType = EventType(rawValue: event._T) else {
            return
        }
        
        switch eventType {
        case .LogMatchStart:
            self.matchStart(event: event as! LogMatchStart)
        case .LogPlayerPosition:
            playerEventPosition(event: event as! LogPlayerPosition)
        case .LogPlayerTakeDamage:
            self.playerTakeDamage(event: event as! LogPlayerTakeDamage)
        case .LogPlayerLogin:
            self.playerLogin(event: event as! LogPlayerLogin)
        case .LogPlayerLogout:
            self.playerLogout(event: event as! LogPlayerLogout)
        case .LogPlayerCreate:
            self.playerCreated(event: event as! LogPLayerCreate)
        case .LogVehicleRide:
            self.vehicleRide(event: event as! LogVehicleRide)
        case .LogPlayerMakeGroggy:
            self.playerMakeGroggy(event: event as! LogPlayerMakeGroggy)
        case .LogPlayerKill:
            self.playerKill(event: event as! LogPllayerKill)
        case .LogArmorDestroy:
            self.armorDestry(event: event as! Logarmordestroy)
        case .LogPlayerAttack:
            self.logPlayyerAttack(event: event as! LogPLayerAttack)
        case .LogPlayerRevive:
            self.playerRevive(event: event as! LogPlayerRevive)
        case .LogHeal:
            self.heal(event: event as! LogHeal)
        case .LogGameStatePeriodic:
            self.gameStatePeriodic(event: event as! LogGameStatePeriodoc)
        case .LogItemUse:
            self.itemUse(event: event as! LogItemUse)
        default:
            return
        }
    }
    
    func processEventInFuture(time : TimeInterval = 10 ,execute : @escaping () -> Void) {
        mapInfo.map.runAction(
            SCNAction.sequence([
                SCNAction.wait(duration: time/speed),
                SCNAction.run({ (_) in
                    execute()
                })
                ])
        )
    }
    
    func firstFutureEvent(in duration : TimeInterval, compare : (Event) -> Bool) -> Event? {
        
        var ind = currentEventIndex + 1
        if (ind >= events.count) { return nil }
        
        while events[ind]._D < eventLoopTime + duration {
            
            let nextEvent = events[ind]
            
            if (compare(nextEvent)) {
                return nextEvent
            } else {
                ind+=1
                if (ind >= events.count) { return nil }
            }
            
        }
        
        return nil
    }
}

extension Replay {
    func matchStart(event : LogMatchStart) {
        self.blueZoneOptions = event.blueZoneCustomOptions
    }
    
    func gameStatePeriodic(event : LogGameStatePeriodoc) {
        
        //blue zone
        let blueZonePosition = locationToVector(location: event.gameStates.safetyZonePosition)
        let radius = event.gameStates.safetyZoneRadius/Float(mapRealSize(map: map).width)
        
        blueZone?.removeFromParentNode()
        blueZone = drawZone(position: blueZonePosition, radius: CGFloat(radius), color: UIColor(red: 0.1882, green: 0, blue: 0.8078, alpha: 0.4))
        blueZone?.position = blueZonePosition
        mapInfo.map.addChildNode(blueZone!)
        
        //red zone
        let redZonePosition = locationToVector(location: event.gameStates.redZonePosition)
        let redRadius = event.gameStates.redZoneRadius/Float(mapRealSize(map: map).width)
        
        redZone?.removeFromParentNode()
        redZone = drawZone(position: redZonePosition, radius: CGFloat(redRadius), color: UIColor(red: 1, green: 0, blue: 0, alpha: 0.4))
        redZone?.position = redZonePosition
        mapInfo.map.addChildNode(redZone!)
        
        //update ui
        ui?.numberAlive(event: event)
    }
    
    
    func heal(event : LogHeal) {
        if let node = getPlayer(character: event.character) {
            if let textNode = node.childNode(withName: kHP, recursively: false) {
                textNode.geometry = hpGeometry(health: event.character.health + event.healAmount)
            }
        }
    }
    
    func itemUse(event : LogItemUse) {
        _ = getPlayer(character: event.character)
    }
    
    func playerRevive(event : LogPlayerRevive) {
        _ = getPlayer(character: event.reviver)
    }
    
    func logPlayyerAttack(event : LogPLayerAttack) {
        let nextEvent = firstFutureEvent(in: 50, compare: { (future) -> Bool in
            
            if let makeGroggy = future as? LogPlayerMakeGroggy {
                return makeGroggy.attackId == event.attackId
            }
            
            if let takeDamage = future as? LogPlayerTakeDamage {
                return takeDamage.attackId == event.attackId
            }
            
            if let armorDestroy = future as? Logarmordestroy {
                return armorDestroy.attackId == event.attackId
            }
            
            if let kill = future as? LogPllayerKill {
                return kill.attackId == event.attackId
            }
            
            return false
        })
        
        if let future = nextEvent as? LogPllayerKill {
            playerKill(event: future, repeatAnimation: event.fireWeaponStackCount)
        }
        
        //TODO: remove
        if let future = nextEvent as? LogPlayerMakeGroggy {
            playerMakeGroggy(event: future, repeatAnimation: event.fireWeaponStackCount)
        }
        
        //TODO: remove
        if let future = nextEvent as? LogPlayerTakeDamage {
            playerTakeDamage(event: future, repeatAnimation: event.fireWeaponStackCount)
        }
        
        if let future = nextEvent as? Logarmordestroy {
            armorDestry(event: future, repeatAnimation: event.fireWeaponStackCount)
        }
    }
    
    func armorDestry(event : Logarmordestroy, repeatAnimation : Int = 1) {
        guard let attackerNode = getPlayer(character: event.attacker) else { return }
        guard let victimNode = getPlayer(character: event.victim) else { return }
        
        var from = attackerNode.position
        var to   = victimNode.position
        
        from.y += 0.002
        to.y   += 0.002
        
        drawLine(from: from, to: to, duration: 1)
    }
    
    func playerKill(event : LogPllayerKill, repeatAnimation : Int = 1) {
        guard let attackerNode = getPlayer(character: event.killer) else { return }
        guard let victimNode = getPlayer(character: event.victim) else { return }
        
        var from = attackerNode.position
        var to   = victimNode.position
        
        from.y += 0.002
        to.y   += 0.002
        
        ui?.showKillEvent(event: event)
        
        drawLine(from: from, to: to, duration: 1)
        victimNode.runAction(SCNAction.sequence([
            SCNAction.run({ (node) in
                node.addParticleSystem(self.assetPreload.smoke)
            }),
            SCNAction.wait(duration: 3),
            SCNAction.removeFromParentNode()
            ]))
    }
    
    func playerMakeGroggy(event : LogPlayerMakeGroggy, repeatAnimation : Int = 1) {
        guard let attackerNode = getPlayer(character: event.attacker) else { return }
        guard let victimNode = getPlayer(character: event.victim) else { return }
        
        var from = attackerNode.position
        var to   = victimNode.position
        
        from.y += 0.002
        to.y   += 0.002
        
        drawLine(from: from, to: to, duration: 1)
    }
    
    
    func playerTakeDamage(event : LogPlayerTakeDamage, repeatAnimation : Int = 1) {
        guard let attacker = event.attacker else { return }
        //        guard let victim  = event.victim else { return }
        
        guard let attackerNode = getPlayer(character: attacker) else { return }
        guard let victimNode = getPlayer(character: event.victim) else { return }
        
        var from = attackerNode.position
        var to   = victimNode.position
        
        if let node = getPlayer(character: event.victim) {
            if let textNode = node.childNode(withName: kHP, recursively: false) {
                textNode.geometry = hpGeometry(health: event.victim.health - event.damage)
            }
        }
        
        from.y += 0.002
        to.y   += 0.002
        
        drawLine(from: from, to: to, duration: 1)
    }
    
    func vehicleRide(event : LogVehicleRide) {
        guard let node = getPlayer(character: event.attacker) else { return }
        
        let newLocation = locationToVector(location: event.attacker.location)
        node.removeAction(forKey: kMovingActionKey)
        node.position = newLocation
    }
    
    func playerCreated(event : LogPLayerCreate) {
        let node = getPlayerNodeOrCreated(character: event.character)
        mapInfo.map.addChildNode(node)
        
        node.removeAction(forKey: kMovingActionKey)
        let newLocation = locationToVector(location: event.character.location)
        node.position = newLocation
    }
    
    func playerLogin(event : LogPlayerLogin) {
        if let node = getPlayer(id: event.accountId) {
            mapInfo.map.addChildNode(node)
        }
    }
    
    func playerLogout(event : LogPlayerLogout) {
        if let node = getPlayer(id: event.accountId) {
            node.removeFromParentNode()
        }
    }
    
    func playerEventPosition(event : LogPlayerPosition) {
        guard let node = getPlayer(character: event.character) else { return }
        let newLocation = locationToVector(location: event.character.location)
        
        if let nextEvent = firstFutureEvent(in: 11, compare: { (futureEvent) -> Bool in
            guard let futureEvent = futureEvent as? LogPlayerPosition else { return false }
            return futureEvent.character.accountId == event.character.accountId
        }) as? LogPlayerPosition {
            node.position = newLocation
            let nexLocation = locationToVector(location: nextEvent.character.location)
            node.runAction(SCNAction.move(to: nexLocation, duration: 10/speed),forKey: kMovingActionKey)
        }
        
    }
}
