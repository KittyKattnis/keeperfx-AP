from dataclasses import dataclass
from typing import Dict

from Options import OptionGroup, ItemDict, Toggle
from worlds.AutoWorld import PerGameCommonOptions
from .items import CREATURES, ROOMS, SPELLS, LEVELS
from .enums import KeeperLevelName, KeeperPowerName, KeeperRoomName, KeeperCreatureName

#to do:
# various options on and off e.g. temple recipes yes/find/no, bonus levels yes/no, FX exclusive creatures/spells/traps/doors yes/no, cruelty mode yes/no, creature type evil/good/both
# numbers of each progressive maybe
# starting player colour maybe idk

def get_val(key):
    return key.value if hasattr(key, "value") else str(key)

class secret_levels(Toggle):
    """Choose if you want secret levels to be available in the game."""
    display_name = "Secret Levels"

class KeeperFXCreatures(Toggle):
    """Choose if you want KeeperFX Creatures to be available in the game."""
    display_name = "KeeperFX Creatures"

class KeeperFXSpells(Toggle):
    """Choose if you want KeeperFX Spells to be available in the game."""
    display_name = "KeeperFX Spells"

class KeeperFXTraps(Toggle):
    """Choose if you want KeeperFX Traps to be available in the game."""
    display_name = "KeeperFX Traps"

class KeeperFXDoors(Toggle):
    """Choose if you want KeeperFX Doors to be available in the game."""
    display_name = "KeeperFX Doors"



class StartingLevels(ItemDict):
    """Levels available at the start of the game."""
    display_name = "Starting Levels"
    min = 1
    max = 5
    default: Dict[str, int] = {
        get_val(KeeperLevelName.LEVEL_001): 1,
        get_val(KeeperLevelName.LEVEL_002): 1,
        get_val(KeeperLevelName.LEVEL_003): 1,
    }
    valid_keys = set(get_val(k) for k in LEVELS.keys())

class StartingSpells(ItemDict):
    """Spells available at the start of the game."""
    display_name = "Starting Spells"
    min = 0
    max = 5
    default: Dict[str, int] = {
        get_val(KeeperPowerName.POWER_HAND): 1,
        get_val(KeeperPowerName.POWER_SLAP): 1,
        get_val(KeeperPowerName.POWER_POSSESS): 1,
        get_val(KeeperPowerName.POWER_IMP): 1,
    }
    valid_keys = set(get_val(k) for k in SPELLS.keys())

class StartingCreatures(ItemDict):
    """Creatures available at the start of the game."""
    display_name = "Starting Creatures"
    min = 1
    max = 5
    default: Dict[str, int] = {
        get_val(KeeperCreatureName.FLY): 1,
        get_val(KeeperCreatureName.BUG): 1,
        get_val(KeeperCreatureName.SPIDER): 1,
    }
    valid_keys = set(get_val(k) for k in CREATURES.keys())

class StartingRooms(ItemDict):
    """Rooms available at the start of the game."""
    display_name = "Starting Rooms"
    min = 0
    max = 5
    default: Dict[str, int] = {
        get_val(KeeperRoomName.TREASURE): 1,
        get_val(KeeperRoomName.LAIR): 1,
        get_val(KeeperRoomName.GARDEN): 1,
    }
    valid_keys = set(get_val(k) for k in ROOMS.keys())

@dataclass
class DungeonKeeperOptions(PerGameCommonOptions):
    secret_levels: secret_levels
    starting_levels: StartingLevels
    starting_spells: StartingSpells
    starting_rooms: StartingRooms
    starting_creatures: StartingCreatures
    KeeperFXCreatures: KeeperFXCreatures
    KeeperFXDoors: KeeperFXDoors
    KeeperFXSpells: KeeperFXSpells
    KeeperFXTraps: KeeperFXTraps

option_groups = [
    OptionGroup("KeeperFX Additions", [
        KeeperFXCreatures,
        KeeperFXSpells,
        KeeperFXDoors,
        KeeperFXTraps,
    ]),    
    OptionGroup("Starting Items", [
        StartingLevels,
        StartingSpells,
        StartingRooms,
        StartingCreatures,
    ])
]