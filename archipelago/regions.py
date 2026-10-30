from __future__ import annotations

from typing import TYPE_CHECKING

from BaseClasses import Entrance, Region
from . import enums

if TYPE_CHECKING:
    from .world import DungeonKeeperWorld

# A region is a container for locations ("checks"), which connects to other regions via "Entrance" objects.
# Many games will model their Regions after physical in-game places, but you can also have more abstract regions.
# For a location to be in logic, its containing region must be reachable.
# The Entrances connecting regions can have rules - more on that in rules.py.
# This makes regions especially useful for traversal logic ("Can the player reach this part of the map?")

# Every location must be inside a region, and you must have at least one region.
# This is why we create regions first, and then later we create the locations (in locations.py).


def create_and_connect_regions(world: DungeonKeeperWorld) -> None:
    create_all_regions(world)
    connect_regions(world)


def create_all_regions(world: DungeonKeeperWorld) -> None:
    world.multiworld.regions += Region(enums.OVERWORLD, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_001.value, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_002.value, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_003.value, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_004.value, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_005.value, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_006.value, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_007.value, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_008.value, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_009.value, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_010.value, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_011.value, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_012.value, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_013.value, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_014.value, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_015.value, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_016.value, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_017.value, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_018.value, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_019.value, world.player, world.multiworld)
    world.multiworld.regions += Region(enums.KeeperLevelName.LEVEL_020.value, world.player, world.multiworld)

    if world.options.temple_locations:
        world.multiworld.regions += [Region(enums.KeeperRoomName.TEMPLE.value.value, world.player, world.multiworld)]

    if world.options.secret_levels:
        world.multiworld.regions += [
            Region(enums.KeeperSecretLevelName.LEVEL_100.value, world.player, world.multiworld),
            Region(enums.KeeperSecretLevelName.LEVEL_101.value, world.player, world.multiworld),
            Region(enums.KeeperSecretLevelName.LEVEL_102.value, world.player, world.multiworld),
            Region(enums.KeeperSecretLevelName.LEVEL_103.value, world.player, world.multiworld),
            Region(enums.KeeperSecretLevelName.LEVEL_104.value, world.player, world.multiworld),
            Region(enums.KeeperSecretLevelName.LEVEL_105.value, world.player, world.multiworld)]

def connect_regions(world: DungeonKeeperWorld) -> None:
    # We have regions now, but still need to connect them to each other.
    # But wait, we no longer have access to the region variables we created in create_all_regions()!
    # Luckily, once you've submitted your regions to multiworld.regions,
    # you can get them at any time using world.get_region(...).
    overworld = world.get_region(enums.OVERWORLD)
    eversmile = world.get_region(enums.KeeperLevelName.LEVEL_001.value)
    cosyton = world.get_region(enums.KeeperLevelName.LEVEL_002.value)
    waterdreamwarm = world.get_region(enums.KeeperLevelName.LEVEL_003.value)
    flowerhat = world.get_region(enums.KeeperLevelName.LEVEL_004.value)
    lushmeadow = world.get_region(enums.KeeperLevelName.LEVEL_005.value)
    snuggledell = world.get_region(enums.KeeperLevelName.LEVEL_006.value)
    wishvale = world.get_region(enums.KeeperLevelName.LEVEL_007.value)
    tickle = world.get_region(enums.KeeperLevelName.LEVEL_008.value)
    moonbrushwood = world.get_region(enums.KeeperLevelName.LEVEL_009.value)
    nevergrim = world.get_region(enums.KeeperLevelName.LEVEL_010.value)
    hearth = world.get_region(enums.KeeperLevelName.LEVEL_011.value)
    elfsdance = world.get_region(enums.KeeperLevelName.LEVEL_012.value)
    buffyoak = world.get_region(enums.KeeperLevelName.LEVEL_013.value)
    sleepiburgh = world.get_region(enums.KeeperLevelName.LEVEL_014.value)
    woodlyrhyme = world.get_region(enums.KeeperLevelName.LEVEL_015.value)
    tulipscent = world.get_region(enums.KeeperLevelName.LEVEL_016.value)
    mirthshire = world.get_region(enums.KeeperLevelName.LEVEL_017.value)
    blaiseend = world.get_region(enums.KeeperLevelName.LEVEL_018.value)
    mistle = world.get_region(enums.KeeperLevelName.LEVEL_019.value)
    skybirdtrill = world.get_region(enums.KeeperLevelName.LEVEL_020.value)

    # Okay, now we can get connecting. For this, we need to create Entrances.
    # Entrances are inherently one-way, but crucially, AP assumes you can always return to the origin region.
    # One way to create an Entrance is by calling the Entrance constructor.
    overworld.connect(eversmile, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_001.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_001.value, world.player))
    overworld.connect(cosyton, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_002.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_002.value, world.player))
    overworld.connect(waterdreamwarm, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_003.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_003.value, world.player))
    overworld.connect(flowerhat, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_004.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_004.value, world.player))
    overworld.connect(lushmeadow, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_005.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_005.value, world.player))
    overworld.connect(snuggledell, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_006.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_006.value, world.player))
    overworld.connect(wishvale, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_007.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_007.value, world.player))
    overworld.connect(tickle, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_008.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_008.value, world.player))
    overworld.connect(moonbrushwood, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_009.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_009.value, world.player))
    overworld.connect(nevergrim, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_010.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_010.value, world.player))
    overworld.connect(hearth, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_011.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_011.value, world.player) & (state.count(enums.KeeperProgressiveName.PROGRESSIVE_LEVEL_CAP.value, world.player) >= 2))
    overworld.connect(elfsdance, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_012.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_012.value, world.player))
    overworld.connect(buffyoak, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_013.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_013.value, world.player))
    overworld.connect(sleepiburgh, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_014.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_014.value, world.player))
    overworld.connect(woodlyrhyme, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_015.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_015.value, world.player))
    overworld.connect(tulipscent, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_016.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_016.value, world.player))
    overworld.connect(mirthshire, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_017.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_017.value, world.player) & (state.count(enums.KeeperProgressiveName.PROGRESSIVE_LEVEL_CAP.value, world.player) >= 3))
    overworld.connect(blaiseend, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_018.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_018.value, world.player) & (state.count(enums.KeeperProgressiveName.PROGRESSIVE_LEVEL_CAP.value, world.player) >= 5) & state.has_group("Creatures", world.player, count=10))
    overworld.connect(mistle, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_019.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_019.value, world.player))
    overworld.connect(skybirdtrill, f"{enums.OVERWORLD} to {enums.KeeperLevelName.LEVEL_020.value}", lambda state: state.has(enums.KeeperLevelName.LEVEL_020.value, world.player) & (state.count(enums.KeeperProgressiveName.PROGRESSIVE_LEVEL_CAP.value, world.player) >= 5) & state.has_group("Creatures", world.player, count=10))

    if world.options.temple_locations:
        temple = world.get_region(enums.KeeperRoomName.TEMPLE.value)
        overworld.connect(temple, f"{enums.OVERWORLD} to {enums.KeeperRoomName.TEMPLE.value}", lambda state: state.has_all({enums.KeeperRoomName.TEMPLE.value, enums.KeeperRoomName.RESEARCH.value}, world.player))

    if world.options.secret_levels:
        secret1 = world.get_region(enums.KeeperSecretLevelName.LEVEL_100.value)
        secret2 = world.get_region(enums.KeeperSecretLevelName.LEVEL_101.value)
        secret3 = world.get_region(enums.KeeperSecretLevelName.LEVEL_102.value)
        secret4 = world.get_region(enums.KeeperSecretLevelName.LEVEL_103.value)
        secret5 = world.get_region(enums.KeeperSecretLevelName.LEVEL_104.value)
        secret6 = world.get_region(enums.KeeperSecretLevelName.LEVEL_105.value)
        overworld.connect(secret1, f"{enums.OVERWORLD} to {enums.KeeperSecretLevelName.LEVEL_100.value}", lambda state: state.has(enums.KeeperSecretLevelName.LEVEL_100.value, world.player))
        overworld.connect(secret2, f"{enums.OVERWORLD} to {enums.KeeperSecretLevelName.LEVEL_101.value}", lambda state: state.has(enums.KeeperSecretLevelName.LEVEL_101.value, world.player))
        overworld.connect(secret3, f"{enums.OVERWORLD} to {enums.KeeperSecretLevelName.LEVEL_102.value}", lambda state: state.has(enums.KeeperSecretLevelName.LEVEL_102.value, world.player))
        overworld.connect(secret4, f"{enums.OVERWORLD} to {enums.KeeperSecretLevelName.LEVEL_103.value}", lambda state: state.has(enums.KeeperSecretLevelName.LEVEL_103.value, world.player))
        overworld.connect(secret5, f"{enums.OVERWORLD} to {enums.KeeperSecretLevelName.LEVEL_104.value}", lambda state: state.has(enums.KeeperSecretLevelName.LEVEL_104.value, world.player))
        overworld.connect(secret6, f"{enums.OVERWORLD} to {enums.KeeperSecretLevelName.LEVEL_105.value}", lambda state: state.has(enums.KeeperSecretLevelName.LEVEL_105.value, world.player))

    # You can then connect the Entrance to the target region.


    # An even easier way is to use the region.connect helper.


    # The region.connect helper even allows adding a rule immediately.
    # We'll talk more about rule creation in the set_all_rules() function in rules.py.
  

    # Some Entrances may only exist if the player enables certain options.
    # In our case, the Hammer locks the top middle chest in its own room if the hammer option is enabled.
    # In this case, we previously created an extra "Top Middle Room" region that we now need to connect to Overworld.

