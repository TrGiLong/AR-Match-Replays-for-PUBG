//
//  Event.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 08.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation

enum EventType : String {
    case LogArmorDestroy
    case LogCarePackageLand
    case LogCarePackageSpawn
    case LogGameStatePeriodic
    case LogHeal
    case LogItemAttach
    case LogItemDetach
    case LogItemDrop
    case LogItemEquip
    case LogItemPickup
    case LogItemPickupFromCarepackage
    case LogItemPickupFromLootBox
    case LogItemUnequip
    case LogItemUse
    case LogMatchDefinition
    case LogMatchEnd
    case LogMatchStart
    case LogObjectDestroy
    case LogParachuteLanding
    case LogPlayerAttack
    case LogPlayerCreate
    case LogPlayerKill
    case LogPlayerLogin
    case LogPlayerLogout
    case LogPlayerPosition
    case LogPlayerTakeDamage
    case LogRedZoneEnded
    case LogSwimEnd
    case LogSwimStart
    case LogVaultStart
    case LogVehicleLeave
    case LogVehicleRide
    case LogWeaponFireCount
    case LogPlayerMakeGroggy
    case LogWheelDestroy
    case LogPlayerRevive
    case LogVehicleDestroy
}

class EventFactory {
    static func produce(json : [String : Any]) -> Event? {
        guard let _T = json["_T"] as? String else {
            print("Error: \(json)")
            return nil
            
        }
        
        guard let type = EventType(rawValue: _T) else {
            print("Wrong log type: \(_T)")
            return nil
            
        }
        switch type {
        case .LogArmorDestroy:
            return Logarmordestroy(json: json)
        case .LogCarePackageLand:
            return LogCarePackageland(json: json)
        case .LogCarePackageSpawn:
            return LogCarePackageland(json: json)
        case .LogGameStatePeriodic:
            return LogGameStatePeriodoc(json: json)
        case .LogHeal:
            return LogHeal(json: json)
        case .LogItemAttach:
            return LogItemAttach(json: json)
        case .LogItemDetach:
            return LogItemDeAttach(json: json)
        case .LogItemDrop:
            return LogItemDrop(json: json)
        case .LogItemEquip:
            return LogItemEquip(json: json)
        case .LogItemPickup:
            return LogItemPickup(json: json)
        case .LogItemPickupFromCarepackage:
            return LogItemPickupFromCarePackage(json: json)
        case .LogItemPickupFromLootBox:
            return LogItemPickupFromLootBox(json: json)
        case .LogItemUnequip:
            return LogItemUnEquip(json: json)
        case .LogItemUse:
            return LogItemUse(json: json)
        case .LogMatchDefinition:
            return LogMatchDefinition(json: json)
        case .LogMatchEnd:
            return LogMatchEnd(json: json)
        case .LogMatchStart:
            return LogMatchStart(json: json)
        case .LogObjectDestroy:
            return LogObjectDestroy(json: json)
        case .LogParachuteLanding:
            return LogObjectParachuteLanding(json: json)
        case .LogPlayerAttack:
            return LogPLayerAttack(json: json)
        case .LogPlayerCreate:
            return LogPLayerCreate(json: json)
        case .LogPlayerKill:
            return LogPllayerKill(json: json)
        case .LogPlayerLogin:
            return LogPlayerLogin(json: json)
        case .LogPlayerLogout:
            return LogPlayerLogout(json: json)
        case .LogPlayerPosition:
            return LogPlayerPosition(json: json)
        case .LogPlayerTakeDamage:
            return LogPlayerTakeDamage(json: json)
        case .LogRedZoneEnded:
            return LogRedZoneEnded(json: json)
        case .LogSwimEnd:
            return LogSwimend(json: json)
        case .LogSwimStart:
            return LogSwimStart(json: json)
        case .LogVaultStart:
            return LogVaultStart(json: json)
        case .LogVehicleLeave:
            return LogVehicleLeave(json: json)
        case .LogVehicleRide:
            return LogVehicleRide(json: json)
        case .LogWeaponFireCount:
            return LogWeaponFireCount(json: json)
        case .LogPlayerMakeGroggy:
            return LogPlayerMakeGroggy(json: json)
        case .LogWheelDestroy:
            return LogWheelDestroy(json: json)
        case .LogVehicleDestroy:
            return LogVehicleDestroy(json: json)
        case .LogPlayerRevive:
            return LogPlayerRevive(json: json)
        }
    }
}

class Event {
    let _D : String // Event timestamp
    let _T : String // Event type
    var common : Common?
    
    init(json : [String : Any]) {
        _D = json["_D"] as! String
        _T = json["_T"] as! String
        if let commonJson = json["common"] {
            common = Common(json: commonJson as! [String : Any])
        }
        
    }
}

class Logarmordestroy : Event {
    let attackId :           Int
    var attacker :           Character
    var victim :             Character
    let damageTypeCategory : String
    let damageReason :       String
    let damageCauserName :   String
    var item :              Item
    let distance :           Float

    override init(json : [String : Any]) {
        
        self.attackId = (json["attackId"] as! NSNumber).intValue
        
        attacker = Character(json: json["attacker"] as! [String : Any])
        victim = Character(json: json["victim"] as! [String : Any])
        
        damageTypeCategory = json["damageTypeCategory"] as! String
        damageReason = json["damageReason"] as! String
        damageCauserName = json["damageCauserName"] as! String
        
        item = Item(json: json["item"] as! [String : Any])
        
        self.distance = (json["distance"] as! NSNumber).floatValue
        
        super.init(json: json)
    }
}

class LogCarePackageland : Event {
    var itemPackages : [ItemPackage] = []
    
    override init(json : [String : Any]) {
        
        for sb in json["itemPackage"] as! [Any] {
            itemPackages.append(ItemPackage(json: sb as! [String : Any]))
        }
        
        super.init(json: json)
    }
}

class LogCarePackageSpawn : Event {
    var itemPackages : [ItemPackage] = []
    
    override init(json : [String : Any]) {
        
        for sb in json["itemPackage"] as! [Any] {
            itemPackages.append(ItemPackage(json: sb as! [String : Any]))
        }
        
        super.init(json: json)
    }
}

class LogGameStatePeriodoc : Event {
    var gameStates : GameState
    
    override init(json : [String : Any]) {
        gameStates = GameState(json: json["gameState"] as! [String : Any])
        super.init(json: json)
    }
}

class LogHeal : Event {
    var character : Character
    var item : Item
    let healAmount : Float
    
    override init(json : [String : Any]) {
        
        character = Character(json: json["character"] as! [String : Any])
        
        item = Item(json: json["item"] as! [String : Any])
        
        self.healAmount = (json["healAmount"] as! NSNumber).floatValue
        
        super.init(json: json)
    }
}

class LogItemAttach : Event {
    var character : Character
    var parentitem : Item
    var childitem : Item
    
    override init(json : [String : Any]) {
        
        character = Character(json: json["character"] as! [String : Any])
        parentitem = Item(json: json["parentItem"] as! [String : Any])
        childitem = Item(json: json["childItem"] as! [String : Any])
        
        super.init(json: json)
    }
}

class LogItemDeAttach : Event {
    var character : Character
    var parentitem : Item
    var childitem : Item
    
    override init(json : [String : Any]) {
        
        character = Character(json: json["character"] as! [String : Any])
        
        parentitem = Item(json: json["parentItem"] as! [String : Any])
        childitem = Item(json: json["childItem"] as! [String : Any])
        
        super.init(json: json)
    }
}

class LogItemDrop : Event {
    var character : Character
    var item : Item
    
    override init(json : [String : Any]) {
        
        character = Character(json: json["character"] as! [String : Any])
        
        item = Item(json: json["item"] as! [String : Any])
        
        super.init(json: json)
    }
}

class LogItemEquip : Event {
    var character : Character
    var item : Item
    
    override init(json : [String : Any]) {
        
        character = Character(json: json["character"] as! [String : Any])
        
        item = Item(json: json["item"] as! [String : Any])
        
        super.init(json: json)
    }
}

class LogItemPickup : Event {
    var character : Character
    var item : Item
    
    override init(json : [String : Any]) {
        
        character = Character(json: json["character"] as! [String : Any])
        
        item = Item(json: json["item"] as! [String : Any])
        
        super.init(json: json)
    }
}

class LogItemPickupFromCarePackage : Event {
    var character : Character
    var item : Item
    
    override init(json : [String : Any]) {
        
        character = Character(json: json["character"] as! [String : Any])
        
        item = Item(json: json["item"] as! [String : Any])
        
        super.init(json: json)
    }
}

class LogItemPickupFromLootBox : Event {
    var character : Character
    var item : Item
    let ownerTeamId : Int
    
    override init(json : [String : Any]) {
        
        character = Character(json: json["character"] as! [String : Any])
        
        item = Item(json: json["item"] as! [String : Any])
        
        self.ownerTeamId = (json["ownerTeamId"] as! NSNumber).intValue
        
        super.init(json: json)
    }
}

class LogItemUnEquip : Event {
    var character : Character
    var item : Item
    
    override init(json : [String : Any]) {
        
        character = Character(json: json["character"] as! [String : Any])
        
        item = Item(json: json["item"] as! [String : Any])
        
        super.init(json: json)
    }
}

class LogItemUse : Event {
    var character : Character
    var item : Item
    
    override init(json : [String : Any]) {
        
        character = Character(json: json["character"] as! [String : Any])
        item = Item(json: json["item"] as! [String : Any])
        
        super.init(json: json)
    }
}

class LogMatchDefinition : Event {
    let matchId : String
    let pingQuality : String
    let seasonState : String
    
    override init(json : [String : Any]) {
        
        matchId = json["MatchId"] as! String
        pingQuality = json["PingQuality"] as! String
        seasonState = json["SeasonState"] as! String
        
        super.init(json: json)
    }
}

class LogMatchEnd : Event {
    var characters : [Character] = []
    
    override init(json : [String : Any]) {
        
        for sb in json["characters"] as! [Any] {
            characters.append(Character(json: sb as! [String : Any]))
        }
        
        super.init(json: json)
    }
}

class LogMatchStart : Event {
    var characters : [Character] = []
    
    let mapName : String
    let weatherId : String
    let cameraViewBehaviour : String
    let teamSize : Int
    let isCustomGame : Bool
    let isEventMode : Bool
    let blueZoneCustomOptions : String
    
    override init(json : [String : Any]) {
        
        for sb in json["characters"] as! [Any] {
            characters.append(Character(json: sb as! [String : Any]))
        }
        
        mapName = json["mapName"] as! String
        weatherId = json["weatherId"] as! String
        cameraViewBehaviour = json["cameraViewBehaviour"] as! String
        blueZoneCustomOptions = json["blueZoneCustomOptions"] as! String
        
        self.teamSize = (json["teamSize"] as! NSNumber).intValue
        
        self.isCustomGame = (json["isCustomGame"] as! NSNumber).boolValue
        self.isEventMode = (json["isEventMode"] as! NSNumber).boolValue
        
        super.init(json: json)
    }
}

class LogObjectDestroy : Event {
    var character : Character
    let objectType : String
    var objectLocations : Location
    
    override init(json : [String : Any]) {
        
        character = Character(json: json["character"] as! [String : Any])
        objectType = json["objectType"] as! String
        objectLocations = Location(json: json["objectLocation"] as! [String : Any])
        
        super.init(json: json)
    }
}

class LogObjectParachuteLanding : Event {
    var character : Character
    let distance : Float
    
    override init(json : [String : Any]) {
        
        character = Character(json: json["character"] as! [String : Any])
        self.distance = (json["distance"] as! NSNumber).floatValue
        
        super.init(json: json)
    }
}

class LogPLayerAttack : Event {
    let attackId : Int
    let fireWeaponStackCount : Int
    
    var attacker : Character
    let attackType : String
    
    let weapon : Item
    let vehicle : Vehicle?
    
    override init(json : [String : Any]) {
        
        self.attackId = (json["attackId"] as! NSNumber).intValue
        self.fireWeaponStackCount = (json["fireWeaponStackCount"] as! NSNumber).intValue
        
        attacker = Character(json: json["attacker"] as! [String : Any])
        self.attackType = json["attackType"] as! String
        
        self.weapon = Item(json: json["weapon"] as! [String : Any])
        
        if let vehicleJson = json["vehicle"] as? [String : Any] {
            self.vehicle = Vehicle(json: vehicleJson)
        } else {
            self.vehicle = nil
        }
        
        super.init(json: json)
    }
}

class LogPLayerCreate : Event {
    var character : Character
    
    override init(json : [String : Any]) {
        character = Character(json: json["character"] as! [String : Any])

        super.init(json: json)
    }
}

class LogPllayerKill : Event  {
    let attackId : Int
    
    var killer : Character
    var victim : Character
    var assistant : Character
    
    var damageTypeCategory : String
    var damageCauserName : String
    var damageCauserAdditionalInfo : [String]
    var damageReason : String
    var distance : Float
    var victimGameResult : GameResult
    
    let dBNOId : Int
    
    override init(json : [String : Any]) {
        
        self.attackId = (json["attackId"] as! NSNumber).intValue
        
        killer = Character(json: json["killer"] as! [String : Any])
        victim = Character(json: json["victim"] as! [String : Any])
        assistant = Character(json: json["assistant"] as! [String : Any])
        
        self.dBNOId = (json["dBNOId"] as! NSNumber).intValue
        
        self.damageTypeCategory = json["damageTypeCategory"] as! String
        self.damageCauserName = json["damageCauserName"] as! String
        self.damageCauserAdditionalInfo = json["damageCauserAdditionalInfo"] as! [String]
        self.damageReason = json["damageReason"] as! String
        self.distance = (json["distance"] as! NSNumber).floatValue
        self.victimGameResult = GameResult(json: json["victimGameResult"] as! [String : Any] )
        
        super.init(json: json)
    }
}

class LogPlayerLogin : Event {
    var accountId : String
    
    override init(json : [String : Any]) {
        self.accountId = json["accountId"] as! String
        
        super.init(json: json)
    }
}

class LogPlayerLogout : Event {
    var accountId : String
    
    override init(json : [String : Any]) {
        self.accountId = json["accountId"] as! String
        
        super.init(json: json)
    }
}

class LogPlayerMakeGroggy : Event {
    let attackId :                   Int
    let attacker :                   Character
    let victim :                     Character
    let damageReason :               String
    let damageTypeCategory :         String
    let damageCauserName :           String
    let damageCauserAdditionalInfo : [String]
    let distance :                   Float
    let isAttackerInVehicle :        Bool
    let dBNOId :                     Int
    
    override init(json : [String : Any]) {
        
        self.attackId = (json["attackId"] as! NSNumber).intValue
        
        attacker = Character(json: json["attacker"] as! [String : Any])
        victim = Character(json: json["victim"] as! [String : Any])
        
        self.dBNOId = (json["dBNOId"] as! NSNumber).intValue
        
        self.damageTypeCategory = json["damageTypeCategory"] as! String
        self.damageCauserName = json["damageCauserName"] as! String
        self.damageCauserAdditionalInfo = json["damageCauserAdditionalInfo"] as! [String]
        self.damageReason = json["damageReason"] as! String
        self.distance = (json["distance"] as! NSNumber).floatValue
        self.isAttackerInVehicle = (json["isAttackerInVehicle"] as! NSNumber).boolValue
        
        super.init(json: json)
    }
}

class LogPlayerPosition : Event {
    let character :        Character
    let vehicle :          Vehicle
    let elapsedTime :      Float
    let numAlivePlayers :  Int
    
    override init(json : [String : Any]) {
        character = Character(json: json["character"] as! [String : Any])
        vehicle = Vehicle(json: json["vehicle"] as! [String : Any])
        self.elapsedTime = (json["elapsedTime"] as! NSNumber).floatValue
        self.numAlivePlayers = (json["numAlivePlayers"] as! NSNumber).intValue
        
        super.init(json: json)
    }
}

class LogPlayerRevive : Event {
     let reviver :              Character
     let victim :               Character
     let dBNOId :               Int
    
    override init(json : [String : Any]) {
        reviver = Character(json: json["reviver"] as! [String : Any])
        victim = Character(json: json["victim"] as! [String : Any])
        self.dBNOId = (json["dBNOId"] as! NSNumber).intValue
        
        super.init(json: json)
    }
}

class LogPlayerTakeDamage : Event {
    let attackId :            Int
    let attacker :            Character?
    let victim :              Character
    let damageTypeCategory :  String
    let damageReason :        String
    let damage :              Float       // 1.0 damage = 1.0 health
    // Net damage after armor; damage to health
    let damageCauserName :    String
    
    override init(json : [String : Any]) {
        
        self.attackId = (json["attackId"] as! NSNumber).intValue
        
        if let attackerJson = json["attacker"] as? [String : Any]{
            attacker = Character(json: attackerJson)
        } else {
            attacker = nil
        }
        victim = Character(json: json["victim"] as! [String : Any])
        
        self.damageTypeCategory = json["damageTypeCategory"] as! String
        self.damageReason = json["damageReason"] as! String
        self.damageCauserName = json["damageCauserName"] as! String
        
        self.damage = (json["damage"] as! NSNumber).floatValue
        
        super.init(json: json)
    }
}

class LogRedZoneEnded : Event  {
    var drivers : [Character] = []
    
    override init(json : [String : Any]) {
        for sb in json["drivers"] as! [Any] {
            drivers.append(Character(json: sb as! [String : Any]))
        }
        
        super.init(json: json)
    }
    
}

class LogSwimend : Event {
    let character :           Character
    let swimDistance :        Float
    let maxSwimDepthOfWater : Float
    
    override init(json : [String : Any]) {
        
        character = Character(json: json["character"] as! [String : Any])

        self.swimDistance = (json["swimDistance"] as! NSNumber).floatValue
        self.maxSwimDepthOfWater = (json["maxSwimDepthOfWater"] as! NSNumber).floatValue
        
        super.init(json: json)
    }
}

class LogSwimStart : Event {
    var character : Character
    
    override init(json : [String : Any]) {
        character = Character(json: json["character"] as! [String : Any])
        
        super.init(json: json)
    }
}

class LogVaultStart : Event {
    var character : Character
    
    override init(json : [String : Any]) {
        character = Character(json: json["character"] as! [String : Any])
        
        super.init(json: json)
    }
}

class LogVehicleDestroy : Event {
    let attackId :            Int
    let attacker :           Character
    let vehicle :            Vehicle
    let damageTypeCategory : String
    let damageCauserName :   String
    let distance :           Float
    
    override init(json : [String : Any]) {
        self.attackId = (json["attackId"] as! NSNumber).intValue
        attacker = Character(json: json["attacker"] as! [String : Any])
        vehicle = Vehicle(json: json["vehicle"] as! [String : Any])
        self.damageCauserName = json["damageCauserName"] as! String
        self.damageTypeCategory = json["damageTypeCategory"] as! String
        self.distance = (json["distance"] as! NSNumber).floatValue
        
        super.init(json: json)
    }
}

class LogVehicleLeave : Event {
    let character :           Character
    let vehicle :            Vehicle
    let rideDistance :          Float
    let seatIndex :           Int
    let maxSpeed :           Float
    
    override init(json : [String : Any]) {
        character = Character(json: json["character"] as! [String : Any])
        vehicle = Vehicle(json: json["vehicle"] as! [String : Any])
        self.rideDistance = (json["rideDistance"] as! NSNumber).floatValue
        self.seatIndex = (json["seatIndex"] as! NSNumber).intValue
        self.maxSpeed = (json["maxSpeed"] as! NSNumber).floatValue
        
        super.init(json: json)
    }
}

class LogVehicleRide : Event {
    let attacker :           Character
    let vehicle :            Vehicle

    let seatIndex :           Int

    
    override init(json : [String : Any]) {
        attacker = Character(json: json["character"] as! [String : Any])
        vehicle = Vehicle(json: json["vehicle"] as! [String : Any])

        self.seatIndex = (json["seatIndex"] as! NSNumber).intValue
        
        super.init(json: json)
    }
}

class LogWeaponFireCount : Event {
    let character :           Character
    let weaponId :            String
    let fireCount :           Int
    
    override init(json : [String : Any]) {
        character = Character(json: json["character"] as! [String : Any])
        self.weaponId = json["weaponId"] as! String
        self.fireCount = (json["fireCount"] as! NSNumber).intValue
        super.init(json: json)
    }
}

class LogWheelDestroy : Event {
    let attackId :            Int
    let attacker :           Character
    let vehicle :            Vehicle
    let damageTypeCategory : String
    let damageCauserName :   String
    
    override init(json : [String : Any]) {
        self.attackId = (json["attackId"] as! NSNumber).intValue
        
        attacker = Character(json: json["attacker"] as! [String : Any])
        self.damageCauserName = json["damageCauserName"] as! String
        vehicle = Vehicle(json: json["vehicle"] as! [String : Any])
        self.damageTypeCategory = json["damageTypeCategory"] as! String
        
        super.init(json: json)
    }
}
