--[[
	Name: 101ResourceReleases
	Filename: BillBoardsC.lua
	Author: Sam@ke
--]]

local classInstance = nil

BillBoardsC = {}

function BillBoardsC:constructor()

	self.effectRange = 1000
	self.effectProgress = 0
	self.effectID = 1
	self.availableADTextures = 10
	self.currentAD = nil
	self.nextAD = nil
	
	self.adTextures = {}
	
	for i = 1, self.availableADTextures, 1 do 
		self.adTextures[i] = dxCreateTexture("res/Textures/ad" .. i .. ".png")
	end
	
	self.fadingShader = dxCreateShader("res/Shaders/fadeEffects.fx", 0, self.effectRange, false, "world")
	
	self.m_Update = function() self:update() end
	addEventHandler("onClientPreRender", root, self.m_Update)
	
	self.m_OnADChanged = function(...) self:onADChanged(...) end
	addEvent("onADChanged", true)
	addEventHandler("onADChanged", root, self.m_OnADChanged)
	
	self.billBoardTextures = 	{"homies_*", "didersachs01", "bobo_2", "eris_*", "heat_02", "sunbillb03", "base5_1", "cokopops_2",
								"bobobillboard1", "prolaps02", "victim_bboard", "pizza_wellstacked", "ws_suburbansign", "prolaps01_small",
								"hardon_1", "247sign1", "gaulle_3", "semi3dirty"}
	
	if (self.fadingShader) then
		for index, texture in ipairs(self.billBoardTextures) do
			self.fadingShader:applyToWorldTexture(texture)
		end
	end
	
	triggerServerEvent("requestADTable", root)
	
	outputChatBox("BillBoard shader started...")
end


function BillBoardsC:onADChanged(currentAD, nextAD)
	if (currentAD) and (nextAD) then
		self.currentAD = self.adTextures[currentAD.textureID]
		self.nextAD = self.adTextures[nextAD.textureID]
		self.effectID = currentAD.effectID
		self.effectProgress = 0
	end
end


function BillBoardsC:update()
	if (self.fadingShader) and (self.currentAD) and (self.nextAD) then
		self.effectProgress = self.effectProgress + 1
		
		if (self.effectProgress > 100) then
			self.effectProgress = 100
		end
		
		self.fadingShader:setValue("effectProgress", self.effectProgress)
		self.fadingShader:setValue("effectID", tonumber(self.effectID))
		self.fadingShader:setValue("texture1", self.currentAD)
		self.fadingShader:setValue("texture2", self.nextAD)
	end
end


function BillBoardsC:destructor()

	for i = 1, self.availableADTextures, 1 do
		if (self.adTextures[i]) then
			self.adTextures[i]:destroy()
			self.adTextures[i] = nil
		end
	end
	
	if (self.fadingShader) then
		self.fadingShader:destroy()
		self.fadingShader = nil
	end
	
	removeEventHandler("onClientPreRender", root, self.m_Update)
	removeEventHandler("onADChanged", root, self.m_OnADChanged)
end


addEventHandler("onClientResourceStart", resourceRoot, 
function()
	classInstance = new(BillBoardsC)
end)


addEventHandler("onClientResourceStop", resourceRoot, 
function()
	if (classInstance) then
		delete(classInstance)
		classInstance = nil
	end
end)