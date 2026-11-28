local CreatureLocations = {
    -- Base creatures
    ["FLY"] = 12001,
    ["BUG"] = 12002,
    ["SPIDER"] = 12003,
    ["DEMONSPAWN"] = 12004,
    ["SORCEROR"] = 12005,
    ["TROLL"] = 12006,
    ["BILE_DEMON"] = 12007,
    ["ORC"] = 12008,
    ["DARK_MISTRESS"] = 12009,
    ["DRAGON"] = 12010,
    ["SKELETON"] = 12011,
    ["GHOST"] = 12012,
    ["TENTACLE"] = 12013,
    ["HELL_HOUND"] = 12014,
    ["HORNY"] = 12015,
    ["VAMPIRE"] = 12016,
    -- Imp
    ["IMP"] = 12017,
    -- KeeperFX creatures
    ["DRUID"] = 12018,
    ["MAIDEN"] = 12019,
}

local HeroLocations = {
    -- Base heroes
    ["THIEF"] = 12101,
    ["BARBARIAN"] = 12102,
    ["GIANT"] = 12103,
    ["WIZARD"] = 12104,
    ["FAIRY"] = 12105,
    ["ARCHER"] = 12106,
    ["DWARFA"] = 12107,
    ["MONK"] = 12108,
    ["SAMURAI"] = 12109,
    ["WITCH"] = 12110,
    -- Special ones
    ["TUNNELLER"] = 12111,
    ["KNIGHT"] = 12112,
    ["AVATAR"] = 12113,
    -- KeeperFX heroes
    ["TIME_MAGE"] = 12114,
}

local RoomLocations = {
    ["TREASURE"] = 13001,
    ["LAIR"] = 13002,
    ["GARDEN"] = 13003,
    ["TRAINING"] = 13004,
    ["RESEARCH"] = 13005,
    ["BRIDGE"] = 13006,
    ["GUARD_POST"] = 13007,
    ["WORKSHOP"] = 13008,
    ["PRISON"] = 13009,
    ["TORTURE"] = 13010,
    ["BARRACKS"] = 13011,
    ["TEMPLE"] = 13012,
    ["GRAVEYARD"] = 13013,
    ["SCAVENGER"] = 13014,
}

local SpellLocations = {
    -- Base spells
    -- POWER_HAND, POWER_SLAP, POWER_POSSESS, POWER_IMP not included in this list
    -- as they are given as default instead of being researchable.
    ["POWER_SIGHT"] = 14001,
    ["POWER_SPEED"] = 14002,
    ["POWER_OBEY"] = 14003,
    ["POWER_CALL_TO_ARMS"] = 14004,
    ["POWER_CONCEAL"] = 14005,
    ["POWER_HOLD_AUDIENCE"] = 14006,
    ["POWER_CAVE_IN"] = 14007,
    ["POWER_HEAL_CREATURE"] = 14008,
    ["POWER_LIGHTNING"] = 14009,
    ["POWER_PROTECT"] = 14010,
    ["POWER_CHICKEN"] = 14011,
    ["POWER_DISEASE"] = 14012,
    ["POWER_ARMAGEDDON"] = 14013,
    ["POWER_DESTROY_WALLS"] = 14014,

    -- KeeperFX spells
    ["POWER_TIME_BOMB"] = 14015,
    ["POWER_SLOW"] = 14016,
    ["POWER_FREEZE"] = 14017,
    ["POWER_REBOUND"] = 14018,
    ["POWER_FLIGHT"] = 14019,
    ["POWER_VISION"] = 14020,
    ["POWER_TUNNELLER"] = 14021,
    ["POWER_CLEANSE"] = 14022,
}

local TrapLocations = {
    -- Base traps
    ["ALARM"] = 15001,
    ["POISON_GAS"] = 15002,
    ["LIGHTNING"] = 15003,
    ["LAVA"] = 15004,
    ["BOULDER"] = 15005,
    ["WORD_OF_POWER"] = 15006,

    -- KeeperFX traps
    ["TNT"] = 15007,
    ["SENTRY"] = 15008,
    ["BALLISTA"] = 15009,
}

local DoorLocations = {
    -- Base doors
    ["WOOD"] = 15101,
    ["BRACED"] = 15102,
    ["STEEL"] = 15103,
    ["MAGIC"] = 15104,

    -- KeeperFX doors
    ["SECRET"] = 15105,
    ["MIDAS"] = 15106,
}

return {
    CreatureLocations = CreatureLocations,
    HeroLocations = HeroLocations,
    RoomLocations = RoomLocations,
    SpellLocations = SpellLocations,
    TrapLocations = TrapLocations,
    DoorLocations = DoorLocations,
}