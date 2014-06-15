--[[ Ridez.lua is simple World of Warcraft Addon that randomly
generates a mount from the list of mounts possessed by the character.

Ridez.lua has a built in check to pick an appropriate mount or the
user can force a "special" mount or a "favorite" mount <NOT YET IMPLIMENTED>.

By default Ridez.lua will summon a flyable mount where flying is
allowed. When flying is NOT allowed, Ridez.lua will summon either a
ground mount or, if swimming, a water walking mount (mount must be possessed)*.

Special mounts are arrays of mounts divided into mounts that have vendors, can
carry passengers (divided into flying and ground subcategories), can
walk on water, increase swim speed, and the special AQ40 only mounts.
Special mounts can be  assigned specific key assignments from the
user interface menu <NOT YET IMPLIMENTED>.

Favorite mounts <NOT YET IMPLIMENTED> are mounts selected by the user.

To do list:
10. Create arrays from files of mounts
	a. use individual files
	b. determine if multiple arrays can be generated from single file
	Notes: Learned that Blizzard turned off the I/O library. Reading from a text
	  file is not possible. Attempting to create a table of arrays and return it
	  as an argument
20. Clean up code
	a. use arrays generated from files
	b. implement ipairs
30. Winterguard
	a. determine if current code handles PvP and non-PvP times
	b. write code if it does not
35. Serpent Flying
	a. how do you check is Serpent Flying is known?
	b. do not call serpent mounts if not usable
40. User Interface
	a. create a button
	b. create menu interface
	c. User Input
		1) allow users to "key bind" special mount arrays
		2) allow users to "key bind" favorite mounts
		
*The Anglers Fishing Raft (item:85500, spell:124036) is not a mount. No
decision has been made to include / exclude the raft.
--]]

-- Simple slash command to mount
SLASH_RIDEZ1, SLASH_RIDEZ2 = '/mu', '/mountup';

-- Move these arrays to separate file
local FPassenger = {"Obsidian Nightwing", "X-53 Touring Rocket"}
local GPassenger = {"Grand Expedition Yak", "Grand Black War Mammoth", "Grand Ice Mammoth", "Traveler's Tundra Mammoth"}

function SlashCmdList.RIDEZ(msg, editbox)
 local btn = GetMouseButtonClicked();
	if (not IsMounted() and btn~="MiddleButton") then		-- If not mounted and not using the raft
													-- Sort mounts into appropriate arrays
	 local Grnd, Fly, Qiraji, Seahorse, Strider, Turtle, Mammoth = SortMounts(GetNumCompanions("MOUNT"));
	 MountUp(btn, Grnd, Fly, Qiraji, Seahorse, Strider, Turtle, Mammoth);	-- "It means, 'Get on your horses.'"
	elseif IsMounted() then 								--If you are mounted
		if (btn=="LeftButton" or btn=="RightButton") then	-- Check if mouse button 1 or 2 was pressed
		 EjectPassengerFromSeat(btn=="LeftButton" and 1 or 2);	-- Eject respective passenger
		end
--		print("\nMammoth = "..UnitVehicleSeatCount("Traveler's Tundra Mammoth"))
--		print("Vehicle = "..UnitVehicleSeatCount("Traveler's Tundra Mammoth",vehicle))
	end
	
	-- Test Code for reading files
--[[	local specialMounts = require("SpecialMounts")		-- Apparently 'require' is also disabled...
	local a = {specialMounts.GetSpecialMounts()}
	for i, v in ipairs(a) do print (v) end
--	for i, v in ipairs(vendor) do print (v) end
	 
	testArray, i = {}, 1
	for line in io.lines("Vendor.txt") do		-- Cannont use I/O for WoW Addons
		testArray[i] = line
		i = i+1
	end
	for i, v in ipairs(testArray) do print(v) end
	--]]
-- print(GetNumCompanions("MOUNT"));
end

-- Sort mounts into arrays of Ground (Grnd) and Flying (Fly)
-- Also checks for a few unique mounts like the Abyssal Seahorse
-- Takes an integer of the number of mounts to search
-- Returns sorted mount arrays
function SortMounts(count)
 -- Set IDs for unique mounts, this will eventually need to be a function that allows
 -- the user to decide which mounts to specify
 -- local Seahorse, Mammoth, Strider
 -- Rewrite using "ipairs"
 
 local Grnd, g, Fly, f = {}, 1, {}, 1;			-- Create ground and flying arrays
 local GPax, gp, FPax, fp = {}, 1, {}, 1;		-- Create arrays for passenger mounts
 local Qiraji, q, Seahorse, Strider, Turtle, Mammoth = {}, 1;	-- Create variables for special mounts
---[[
	for i=1,count do							-- Check each mount
	 local CId, CName, CspellID, CIcon, CActive, CFlag = GetCompanionInfo("MOUNT", i);
		if CName == "Abyssal Seahorse" then			-- If Abyssal Seahorse
		 Seahorse = i;									-- Save Seahorse
		elseif CName == "Sea Turtle" then		-- Not checking for Riding Turtle yet
		 Turtle = i;
		elseif (string.find(CName, "Qiraji Battle Tank")) then
		 Qiraji[q] = i;
		 q = q+1;
		elseif CFlag == 29 then 						-- Else if a ground mount
		 Grnd[g] = i;										-- Add to ground array
			if CName == "Traveler's Tundra Mammoth"	then		-- If Tundra Mammoth, not checking for other one yet
			 Mammoth = i;										-- Save Mammoth
--			 print(UnitVehicleSeatCount("Traveler's Tundra Mammoth"))
			elseif CName == "Azure Water Strider" then
			 Strider = i;
			end
		 g = g+1;											-- Increment ground array index
		elseif CFlag == 15 or CFlag == 31 then			-- Else if flying mount
		 Fly[f] = i;										-- Add to flying array
		 f = f+1;											-- Increment flying array index
		else
		 print("Mount "..CName..", position "..i.." has Flag "..CFlag)
		end
	end
--]]
 return Grnd, Fly, Qiraji, Seahorse, Strider, Turtle, Mammoth;
	

-- local count = GetNumCompanions("MOUNT");
-- print("Total Mounts = " .. tostring(count));
-- print(GetNumCompanions("MOUNT"));
end

-- MountUp determines which mount should be called
-- If appropriate, will use random to decide on the mount
function MountUp(btn, Grnd, Fly, Qiraji, Seahorse, Strider, Turtle, Mammoth)
	if (IsAltKeyDown() and btn == "RightButton" and Turtle) then
	 CallCompanion("MOUNT", Turtle);
	elseif (IsAltKeyDown() and btn == "LeftButton" and Strider) then
	 CallCompanion("MOUNT", Strider);
	elseif (btn == "RightButton" and Mammoth) then
	 CallCompanion("MOUNT", Mammoth);
	elseif (GetMapInfo() == "AhnQiraj" and Qiraji) then		-- If in AQ40
	 CallCompanion("MOUNT", Qiraji[random(#Qiraji)]);		-- Attempt to mount the battle tanks
	elseif (string.find(GetMapInfo(),"Vashjir") and IsSwimming() and Seahorse) then
	 CallCompanion("MOUNT", Seahorse);
	elseif IsFlyableArea() == 1 then			-- If flying is allowed
	 CallCompanion("MOUNT", Fly[random(#Fly)]);		-- Call random flying mount
	elseif (IsSwimming() and Strider) then		-- If cannot fly while swimming
	 CallCompanion("MOUNT", Strider);				-- Attempt to call the Stider
	else CallCompanion("MOUNT", Grnd[random(#Grnd)]);
	end
end

function Mounts()
 local count = GetNumCompanions("MOUNT");
 print("Total Mounts = " .. tostring(count));
end