from __future__ import annotations

from collections import defaultdict
from typing import TYPE_CHECKING, Literal

from .items import CREATURES, ROOMS, SPELLS, LEVELS
from .enums import KeeperLevelName, KeeperPowerName, KeeperRoomName, KeeperCreatureName

from rule_builder.rules import (Rule, CanReachEntrance, CanReachLocation, Has, HasAll, HasAny, HasFromListUnique, HasGroupUnique,
                                OptionFilter, True_, HasFromList)

if TYPE_CHECKING:
    from .world import DungeonKeeperWorld

def get_val(key):
    return key.value if hasattr(key, "value") else str(key)


def set_all_rules(world: DungeonKeeperWorld) -> None:

    location_rules: defaultdict[str, Rule] = defaultdict(True_)

#Requires Bridge to get

    location_rules["Eversmile Water Patch"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Cosyton East Water"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Cosyton Hero Fortress"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Waterdream Warm South Water"] = HasAll("Bridge Researchable", "Library Researchable")  
    location_rules["Waterdream Warm Hero Fortress"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Flowerhat Hero Fortress NE"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Flowerhat Hero Fortress SE"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Flowerhat Lava Island"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Flowerhat Spider Cave"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Lushmeadow-On-Down East Fort"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Lushmeadow-On-Down West Fort"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Lushmeadow-On-Down West Islet"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Snuggledell East Water"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Snuggledell West Water"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Snuggledell Southeast Water"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Wishvale NE Hero Fortress"] = HasAll("Bridge Researchable", "Library Researchable") #Technically Blue could bridge to you
    location_rules["Wishvale East Hero Fortress"] = HasAll("Bridge Researchable", "Library Researchable") #Technically Blue could bridge to you
    location_rules["Wishvale SE Hero Fortress"] = HasAll("Bridge Researchable", "Library Researchable") #Technically Blue could bridge to you
    location_rules["Wishvale Blue Keeper"] = HasAll("Bridge Researchable", "Library Researchable") #Technically Blue could bridge to you
    location_rules["Tickle Northeast Fortress"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Moonbrush Wood SW Library"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Moonbrush Wood SE Library"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Moonbrush Wood NE Library"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Moonbrush Wood NW Library"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Moonbrush Wood Neutral Fort"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Nevergrim East Island"] = HasAll("Bridge Researchable", "Library Researchable") #Technically Blue could bridge to you
    location_rules["Nevergrim West Island"] = HasAll("Bridge Researchable", "Library Researchable") #Technically Blue could bridge to you
    location_rules["Nevergrim Blue Keeper"] = HasAll("Bridge Researchable", "Library Researchable") #Technically Blue could bridge to you
    location_rules["Hearth NE Water"] = Has("Bridge Researchable") #Have Library from beginning on non-cruelty mode
    location_rules["Hearth SE Water"] = Has("Bridge Researchable") #Have Library from beginning on non-cruelty mode
    location_rules["Hearth SW Water"] = Has("Bridge Researchable") #Have Library from beginning on non-cruelty mode
    location_rules["Hearth NW Water"] = Has("Bridge Researchable") #Have Library from beginning on non-cruelty mode
    location_rules["Buffy Oak Poison Cavern"] = HasAll("Bridge Researchable", "Library Researchable") #Technically Blue/Green could bridge to you
    location_rules["Buffy Oak Lava Cavern"] = HasAll("Bridge Researchable", "Library Researchable") #Technically Blue/Green could bridge to you
    location_rules["Buffy Oak South Gold Seam"] = HasAll("Bridge Researchable", "Library Researchable") #Technically Blue/Green could bridge to you
    location_rules["Sleepiburgh NW Cavern"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Sleepiburgh NE Cavern"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Woodly Rhyme Hero Fortress North"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Woodly Rhyme Hero Fortress South"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Woodly Rhyme Hero Checkerboard 1"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Woodly Rhyme Hero Checkerboard 2"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Woodly Rhyme Southern Tunnel"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Tulipscent NW Hero Fortress 1"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Tulipscent NW Hero Fortress 2"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Blaise End NW Lava"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Mistle Central Water 1"] = Has("Bridge Researchable") #Have Library from beginning on non-cruelty mode
    location_rules["Mistle Central Water 2"] = Has("Bridge Researchable") #Have Library from beginning on non-cruelty mode
    location_rules["Secret 2 In Water"] = Has("Bridge Researchable") #Have Library from beginning on non-cruelty mode
    location_rules["Secret 4 Lava Pool"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Secret 4 Next to Witch"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Secret 4 Next to Boulder"] = HasAll("Bridge Researchable", "Library Researchable")
    location_rules["Secret 5 Goal Area"] = HasAll("Bridge Researchable", "Library Researchable")



    location_rules["Blaise End Central Portal"] = HasAll("Destroy Walls Researchable", "Library Researchable") #If FX traps are on, could be this OR workshop and TNT trap

#Scaling requirements for difficult levels

    location_rules["Level 20 Beaten"] = HasFromListUnique(*[f"{key}" for key in CREATURES], 
                                 count=9).resolve(world)

# temple recipes
    location_rules["Recipe Cheaper Imps"] = Has("Create Imp")
    location_rules["Recipe Complete Manufacturing"] = Has("Workshop") & HasAny("Level 20 Unlocked", "Attract Beetle")
    location_rules["Recipe Complete Research"] = Has("Library") & HasAny("Level 20 Unlocked", "Level 10 Unlocked", "Attract Fly")
    location_rules["Recipe Bile Demon"] = HasAny("Attract Spider", "Level 4 Unlocked", "Level 5 Unlocked", "Level 18 Unlocked")
    location_rules["Recipe Warlock"] = HasAll("Attract Spider", "Attract Fly") | HasAll("Attract Fly", "Level 4 Unlocked") | HasAll("Attract Fly", "Level 5 Unlocked") | HasAll("Attract Fly", "Level 18 Unlocked") | HasAll("Attract Spider", "Level 10 Unlocked") | HasAll("Attract Spider", "Level 20 Unlocked")
    location_rules["Recipe Mistress"] = HasAll("Attract Beetle", "Attract Spider") | HasAll("Attract Spider", "Level 10 Unlocked") | HasAll("Attract Spider", "Level 20 Unlocked") | HasAll("Attract Beetle", "Level 4 Unlocked") | HasAll("Attract Beetle", "Level 5 Unlocked") | HasAll("Attract Beetle", "Level 18 Unlocked")
    location_rules["Recipe Horned Reaper"] = HasAll("Attract Mistress", "Attract Bile Demon", "Attract Troll") | Has("Level 9 Unlocked")
    location_rules["Recipe Make Angry"] = Has("Attract Horned Reaper") | CanReachLocation("Recipe Horned Reaper")
    location_rules["Recipe Kill Chickens"] = HasAny("Attract Ghost", "Level 6 Unlocked", "Level 15 Unlocked", "Level 19 Unlocked", "Torture Chamber") & Has("Hatchery")
    location_rules["Recipe Disease Creatures"] = HasAny("Attract Vampire", "Graveyard", "Level 12 Unlocked", "Level 19 Unlocked")
    location_rules["Recipe Chicken Creatures"] = HasAny("Attract Bile Demon", "Level 4 Unlocked", "Level 5 Unlocked","Level 9 Unlocked", "Level 11 Unlocked", "Level 18 Unlocked") | CanReachLocation("Recipe Bile Demon")
    location_rules["Recipe Tentacle"] = HasAll("Attract Troll", "Attract Spider") | HasAll("Attract Troll", "Level 4 Unlocked") | HasAll("Attract Troll", "Level 5 Unlocked") | HasAll("Attract Troll", "Level 18 Unlocked") | HasAll("Attract Spider", "Level 9 Unlocked") | HasAll("Attract Spider", "Level 11 Unlocked")
    location_rules["Recipe Hellhound"] = HasAll("Attract Dragon", "Attract Fly") | Has("Level 10 Unlocked") | HasAll("Attract Dragon", "Level 20 Unlocked") | HasAll("Attract Fly", "Level 10 Unlocked") | HasAll("Attract Fly", "Level 13 Unlocked") | HasAll("Attract Fly", "Level 18 Unlocked")
    location_rules["Recipe Speed"] = Has("Attract Fly") & HasAny("Level 8 Unlocked", "Attract Hellhound")
    location_rules["Recipe Conceal"] = HasAll("Attract Troll", "Attract Fly") | HasAll("Attract Troll", "Level 10 Unlocked") | HasAll("Attract Troll", "Level 20 Unlocked") | HasAll("Attract Fly", "Level 9 Unlocked") | HasAll("Attract Fly", "Level 11 Unlocked") | HasAll("Attract Fly", "Level 14 Unlocked")
    location_rules["Recipe Heal"] = HasAll("Attract Orc", "Attract Spider") | HasAll("Attract Orc", "Level 4 Unlocked") | HasAll("Attract Orc", "Level 5 Unlocked") | HasAll("Attract Orc", "Level 18 Unlocked")
    location_rules["Recipe Rebound"] = HasAll("Attract Mistress", "Attract Beetle") | HasAll("Attract Mistress", "Level 20 Unlocked") | HasAll("Attract Beetle", "Level 4 Unlocked") | HasAll("Attract Beetle", "Level 5 Unlocked") | HasAll("Attract Beetle", "Level 6 Unlocked") | HasAll("Attract Beetle", "Level 9 Unlocked") | HasAll("Attract Beetle", "Level 18 Unlocked")
    location_rules["Recipe Protect"] = HasAll("Attract Bile Demon", "Attract Beetle") | HasAll("Attract Bile Demon", "Level 20 Unlocked") | HasAll("Attract Beetle", "Level 4 Unlocked") | HasAll("Attract Bile Demon", "Level 5 Unlocked") | HasAll("Attract Beetle", "Level 9 Unlocked") | HasAll("Attract Beetle", "Level 11 Unlocked") | HasAll("Attract Beetle", "Level 15 Unlocked") | HasAll("Attract Beetle", "Level 18 Unlocked")   
    location_rules["Recipe Flight"] = HasAll("Attract Demon Spawn", "Attract Fly") | HasAll("Attract Demon Spawn", "Level 10 Unlocked") | HasAll("Attract Demon Spawn", "Level 10 Unlocked") | HasAll("Attract Fly", "Level 8 Unlocked") | HasAll("Attract Fly", "Level 11 Unlocked")
    location_rules["Recipe Freeze"] = HasAll("Attract Vampire", "Attract Spider") | HasAll("Attract Vampire", "Level 4 Unlocked") | HasAll("Attract Vampire", "Level 5 Unlocked") | HasAll("Attract Vampire", "Level 18 Unlocked") | HasAll("Attract Spider", "Level 12 Unlocked") | HasAll("Attract Spider", "Level 19 Unlocked")
    location_rules["Recipe Slow"] = HasAll("Attract Vampire", "Attract Demon Spawn") | HasAll("Attract Vampire", "Level 8 Unlocked") | HasAll("Attract Vampire", "Level 12 Unlocked") | HasAll("Attract Demon Spawn", "Level 12 Unlocked") | HasAll("Attract Demon Spawn", "Level 19 Unlocked")

    for location_name, rule_logic in location_rules.items():
        try:
            location_obj = world.get_location(location_name)
            
            world.set_rule(location_obj, rule_logic)
            
        except KeyError:
            print(f"Warning: Could not find location '{location_name}' to apply rules.")


    set_completion_condition(world)




def set_completion_condition(world: DungeonKeeperWorld) -> None:
    world.multiworld.completion_condition[world.player] = lambda state: (
        state.can_reach("Level 20 Beaten", "Location", world.player)
    )

    # In our case, we went for the Victory event design pattern (see create_events() in locations.py).
    # So lets undo what we just did, and instead set the completion condition to:



# One final comment about rules:
# If your world exclusively uses Rule Builder rules (like APQuest), it's worth trying CachedRuleBuilderWorld.
# CachedRuleBuilderWorld is a subclass of World that has a bunch of caching magic to make rules faster.
# Just have your world class subclass CachedRuleBuilderWorld instead of World:
#   class APQuestWorld(CachedRuleBuilderWorld): ...
# This may speed up your world, or it may make it slower.
# The exact factors are complex and not well understood, but there is no harm in trying it.
# Generate a few seeds and see if there is a noticeable difference!
# If you're wondering, author has checked: APQuest is too simple to see any benefits, so we'll stick with "World".
