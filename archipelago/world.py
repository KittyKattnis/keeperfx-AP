from collections.abc import Mapping
from typing import Any

# Imports of base Archipelago modules must be absolute.
from worlds.AutoWorld import World

# Imports of your world's files must be relative.
from . import items, locations, regions, rules, web_world, enums
from . import options as dungeonkeeper_options  # rename due to a name conflict with World.options

# APQuest will go through all the parts of the world api one step at a time,
# with many examples and comments across multiple files.
# If you'd rather read one continuous document, or just like reading multiple sources,
# we also have this document specifying the entire world api:
# https://github.com/ArchipelagoMW/Archipelago/blob/main/docs/world%20api.md


# The world class is the heart and soul of an apworld implementation.
# It holds all the data and functions required to build the world and submit it to the multiworld generator.
# You could have all your world code in just this one class, but for readability and better structure,
# it is common to split up world functionality into multiple files.
# This implementation in particular has the following additional files, each covering one topic:
# regions.py, locations.py, rules.py, items.py, options.py and web_world.py.
# It is recommended that you read these in that specific order, then come back to the world class.
class DungeonKeeperWorld(World):
    """
    Dungeon Keeper is a game.
    """

    # The docstring should contain a description of the game, to be displayed on the WebHost.

    # You must override the "game" field to say the name of the game.
    game = enums.GAME_NAME

    # The WebWorld is a definition class that governs how this world will be displayed on the website.
    web = web_world.DungeonKeeperWebWorld()

    # This is how we associate the options defined in our options.py with our world.
    # (Note: options.py has been imported as "apquest_options" at the top of this file to avoid a name conflict)
    options_dataclass = dungeonkeeper_options.DungeonKeeperOptions
    options: dungeonkeeper_options.DungeonKeeperOptions  # Common mistake: This has to be a colon (:), not an equals sign (=).

    # Our world class must have a static location_name_to_id and item_name_to_id defined.
    # We define these in regions.py and items.py respectively, so we just set them here.
    location_name_to_id = locations.LOCATION_NAME_TO_ID
    item_name_to_id = items.ITEM_NAME_TO_ID

    # There is always one region that the generator starts from & assumes you can always go back to.
    # This defaults to "Menu", but you can change it by overriding origin_region_name.
    origin_region_name = enums.OVERWORLD

    item_name_groups = {
        "Levels": {entry.value for entry in enums.KeeperLevelName},
        "Bonus Levels": {entry.value for entry in enums.KeeperSecretLevelName},
        "Creatures": {entry.value for entry in enums.KeeperCreatureName},
        "FX Creatures": {entry.value for entry in enums.KeeperFXCreatureName},
        "Rooms": {entry.value for entry in enums.KeeperRoomName},
        "Traps": {entry.value for entry in enums.KeeperTrapName},
        "FX Traps": {entry.value for entry in enums.KeeperFXTrapName},
        "Doors": {entry.value for entry in enums.KeeperDoorName},
        "FX Doors": {entry.value for entry in enums.KeeperFXDoorName},
        "Powers": {entry.value for entry in enums.KeeperPowerName},
        "FX Powers": {entry.value for entry in enums.KeeperFXPowerName},
        "Recipes": {entry.value for entry in enums.KeeperRecipeName},
        "Negative Recipes": {entry.value for entry in enums.NegativeRecipeName},
        "FX Recipes": {entry.value for entry in enums.KeeperFXRecipeName},
        "Progressives": {entry.value for entry in enums.KeeperProgressiveName},
        "Heroes": {entry.value for entry in enums.KeeperHeroName},
        "FX Heroes": {entry.value for entry in enums.KeeperFXHeroName},
        "Filler": {entry.value for entry in enums.KeeperFillerName}
    }
    item_name_groups["All Levels"] = item_name_groups["Levels"] | item_name_groups["Bonus Levels"]
    item_name_groups["Creatures"].update(enums.KeeperImpName.IMP.value)

    # Our world class must have certain functions ("steps") that get called during generation.
    # The main ones are: create_regions, set_rules, create_items.
    # For better structure and readability, we put each of these in their own file.
    def create_regions(self) -> None:
        regions.create_and_connect_regions(self)
        locations.create_all_locations(self)

    def set_rules(self) -> None:
        rules.set_all_rules(self)

    def create_items(self) -> None:
        items.create_all_items(self)

    # Our world class must also have a create_item function that can create any one of our items by name at any time.
    # We also put this in a different file, the same one that create_items is in.

    def create_item(self, name: str) -> items.DungeonKeeperItem:

        item_data = items.item_table[name]
        
        return items.DungeonKeeperItem(
            name=name,
            classification=item_data.classification,
            code=item_data.code.value,
            player=self.player
        )

    def generate_early(self) -> None:
        starting_options = [
            self.options.starting_levels,
            self.options.starting_spells,
            self.options.starting_rooms,
            self.options.starting_creatures,
        ]

        for option in starting_options:
            for item_name, count in option.value.items():
                for _ in range(count):
                    item = self.create_item(item_name)
                    self.multiworld.push_precollected(item)

        self.multiworld.early_items[self.player][enums.KeeperRoomName.RESEARCH] = 1
        self.multiworld.early_items[self.player][enums.KeeperRoomName.TRAINING] = 1

    # For features such as item links and panic-method start inventory, AP may ask your world to create extra filler.
    # The way it does this is by calling get_filler_item_name.
    # For this purpose, your world *must* have at least one infinitely repeatable item (usually filler).
    # You must override this function and return this infinitely repeatable item's name.
    # In our case, we defined a function called get_random_filler_item_name for this purpose in our items.py.
    def get_filler_item_name(self) -> str:
        return items.get_random_filler_item_name()

    def fill_slot_data(self) -> dict[str, Any]:
        return {
            "KeeperFXCreatures": self.options.KeeperFXCreatures.value,
            "KeeperFXDoors": self.options.KeeperFXDoors.value,
            "KeeperFXSpells": self.options.KeeperFXSpells.value,
            "KeeperFXTraps": self.options.KeeperFXTraps.value,
            "NegativeRecipes": self.options.NegativeRecipes.value,
            "KeeperFXRecipes": self.options.KeeperFXRecipes.value,
            "AddHeroes": self.options.AddHeroes.value,
            "KeeperFXHeroes": self.options.KeeperFXHeroes.value,
            "IncludeImpsInPool": self.options.IncludeImpsInPool.value,
            "IncludeTunnellersInPool": self.options.IncludeTunnellersInPool.value,
            "IncludeKnightsInPool": self.options.IncludeKnightsInPool.value,
            "IncludeAvatarsInPool": self.options.IncludeAvatarsInPool.value,
            "ShuffleTilesets": self.options.shuffle_tilesets.value,
            "ChangePlayerColour": self.options.change_player_colour.value,
            "ChangeNeutrals": self.options.change_neutrals.value,
            "SwapWaterAndLava": self.options.swap_water_and_lava.value,
            "RemoveNeutralRooms": self.options.remove_neutral_rooms.value,
            "CrueltyMode": self.options.cruelty_mode.value,
            "SecretLevels": self.options.secret_levels.value,
            "FlatTempleGuardPost": self.options.FlatTempleGuardPost.value,
        }
    

    # There may be data that the game client will need to modify the behavior of the game.
    # This is what slot_data exists for. Upon every client connection, the slot's slot_data is sent to the client.
    # slot_data is just a dictionary using basic types, that will be converted to json when sent to the client.