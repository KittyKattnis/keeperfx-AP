-- ********************************************
--
--        Hub Level
--
-- ********************************************

BoxLocations = require("box_locations")
SentLocations = require("sent_locations")
CommandsMain = require("commands_main")
ReceivedLocations = require("received_locations")

--will get called when the game starts
function OnGameStart()
	CommandsMain.MainSetup()
      IncreaseStartingGold()
    RegisterTimerEvent(function ()
        QuickInformation(99,"Welcome to KeeperAP!\nWoo!")
        QuickObjective("Welcome to KeeperAP!\nWoo!")
    end, 20, false)
end

function OnGameLoad()
      QuickMessage("Game loaded.", "ARCHIPELAGO_ICON")
      CommandsMain.MainSetup()
end


-- map code:
--first reveal the lava area properly lol

--for each level: top slab represents level status
--starting at subtile 88, 34: for 1 to 10, add 18 to x coord (so 1 is 106,34, 2 is 124,34 etc)
--starting at subtile 88, 49: for 11 to 20, add 18 to x coord
--starting at subtile 124, 64: for 21 to 26, add 18 to x coord
--if unlocked, don't do anything
--if locked, add the floating key
--if completed, add a red flame (maybe we add tooltips to both the key and flame making it clear????)

--then, starting at [level subtile x,y]+[-9,0], check everything in the values of BoxLocations for that level, and for (locationvalue % 100), place box number locationvalue at subtile [level subtile x,y]+[-9,0]+[3*(locationvalue % 5),3*((locationvalue % 100)-(locationvalue % 5)]
-- (but like don't actually place the box, place a non-interactable dummy representation of it???? or change the objects.cfg so they can't be used?)
-- for the remaining of the 10 spaces that don't have checks on, turn it to lava
-- give every unlocked one its correct graphics (normal or progression) and the tooltip associated with what it unlocked
-- and every locked one, we just use they greyed out version (currently set statue 5 to use that), and we have the tooltip just say "Not found yet" otherwise it's a big spoiler even though you can find out by going to the level and reading its tooltip but shhh

--if the option for adding the bonus levels is turned off, fill those areas in with dirt

--for creatures, rooms etc etc:
--creature should go in the prison i guess
--red flame means "have unlocked"
--blue flame means "toggled on/off" (special underneath turns it off ingame, e.g. if you don't want to get a certain creature any more, you can just choose not to, same with rooms etc)

-- need to do something similar for optional fx bonus creatures like druid and maiden - hide them if we don't have the associated option on.

-- i dunno what else we need! Some useful explanatory text! Then uhhhhhh if we somehow set up a way to do transfers a more robust way: have a "pool" of transferable creatures (maybe allied creatures in an allied prison so you can see them), that when you receive a transferable one, it goes here, and you can take one or more with you to the next level by activating a box here. It's one use (but only goes away if you complete the level you transferred them to???)