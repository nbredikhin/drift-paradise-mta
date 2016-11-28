--[[
	Name: 101ResourceReleases
	Filename: BillBoardsS.lua
	Author: Sam@ke
--]]

local classInstance = nil

BillBoardsS = {}

function BillBoardsS:constructor()

	self.updateDuration = 4000

	self.billBoadsTable = {}
	
	self.availableADTextures = 10
	self.availableADEffects = 3 -- from 1 to 3
	
	self.currentAD = 1
	self.nextAD = 2
	self.maxADs = 100
	
	for i = 1, self.maxADs, 1 do
		local randomTexture = math.random(1, self.availableADTextures)
		local randomEffect = math.random(1, self.availableADEffects)
		
		if (self.billBoadsTable[i - 1]) then
			while (randomTexture == self.billBoadsTable[i - 1].textureID) do
				randomTexture = math.random(1, self.availableADTextures)
			end
			
			while (randomEffect == self.billBoadsTable[i - 1].effectID) do
				randomEffect = math.random(1, self.availableADEffects)
			end
		end
		
		self.billBoadsTable[i] = {textureID = randomTexture, effectID = randomEffect}
	end
	
	self.m_Update = function() self:update() end
	self.updateTimer = setTimer(self.m_Update, self.updateDuration, 0)
	
	self.m_SendTableToClient = function() self:sendTableToClient() end
	addEvent("requestADTable", true)
	addEventHandler("requestADTable", root, self.m_SendTableToClient)
end


function BillBoardsS:update()
	self.currentAD = self.currentAD + 1
	
	if (self.currentAD > self.maxADs) then
		self.currentAD = 1
	end
	
	
	if (self.billBoadsTable[self.currentAD + 1]) then
		self.nextAD = self.currentAD + 1
	else
		self.nextAD = 1
	end
	
	if (self.billBoadsTable[self.currentAD]) and (self.billBoadsTable[self.nextAD]) then
		triggerClientEvent("onADChanged", root, self.billBoadsTable[self.currentAD], self.billBoadsTable[self.nextAD])
	end
end


function BillBoardsS:sendTableToClient()
	if (isElement(source)) then
		if (self.billBoadsTable[self.currentAD]) and (self.billBoadsTable[self.nextAD]) then
			triggerClientEvent(source, "onADChanged", root, self.billBoadsTable[self.currentAD], self.billBoadsTable[self.nextAD])
		end
	end
end


function BillBoardsS:destructor()
	removeEventHandler("requestADTable", root, self.m_SendTableToClient)
	
	if (self.updateTimer) and (self.updateTimer:isValid()) then
		self.updateTimer:destroy()
		self.updateTimer = nil
	end	
end


addEventHandler("onResourceStart", resourceRoot, 
function()
	classInstance = new(BillBoardsS)
end)


addEventHandler("onResourceStop", resourceRoot, 
function()
	if (classInstance) then
		delete(classInstance)
		classInstance = nil
	end
end)