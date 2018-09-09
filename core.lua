local AddOnName, Engine = ...

local _G = _G

local AddOn = CreateFrame("FRAME")

Engine[1] = AddOn
Engine[2] = {}
Engine[3] = {}

_G[AddOnName] = Engine

AddOn.Name = AddOnName