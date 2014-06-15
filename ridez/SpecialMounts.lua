--[[ Special Mounts is a list of all the mounts that have
unique qualities that satisfy the special cases in the
main (Ridez.lua) file.

!This file is not used in current version!

Currently, each set has its own file for easier iteration, but
if I can figure out how to efficiently delineate from one file
I would like to use this file instead of six separate ones.
--]]

local Mounts = {}
-- Vendor Mounts
vendor = {
31858, -- Traveler's Tundra Mammoth (Alliance)
31857, -- Traveler's Tundra Mammoth (Horde)
62809, -- Grand Expedition Yak
}
-- Passenger Ground Mounts
grndPssngr = {
31858, -- Traveler's Tundra Mammoth (Alliance)
31857, -- Traveler's Tundra Mammoth (Horde)
62809, -- Grand Expedition Yak
55531, -- Mechano-Hog (Horde only)
32286, -- Mekgineer's Chopper (Alliance only)
31858, -- Grand Ice Mammoth (Alliance)
31857, -- Grand Ice Mammoth (Horde)
31862, -- Grand Black War Mammoth (Alliance)
31861, -- Grand Black War Mammoth (Horde)
}

-- Passenger Flying Mounts
flyPssngr = {
50269, -- Sandstone Drake (Vial of the Sands)
40725, -- X-53 Touring Rocket
62454, -- Obsidian Nightwing (Heart of the Nightwing)
}

-- Swimming Mounts
swim = {
34187, -- Sea Turtle
17266, -- Riding Turtle
53270, -- Subdued Seahorse
}

-- Water Walking Mounts
waterWalk = {
60941 -- Azure Water Strider
}

-- Qiraji Battle Tanks (AQ40 only)
qiraji = {
15666, -- Blue
15715, -- Green
15716, -- Red
26055, -- Yellow
}
-- Note that Black and Ultramarine are intentionally left off

function Mounts.GetSpecialMounts()
 local a = {vendor, grndPssngr, flyPssngr, swim, waterWalk, qiraji}
-- return a
 print("So far, so Good")
end

return Mounts