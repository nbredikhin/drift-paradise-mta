local UVSpeed = {-0.5, 0}
local UVResize = {1, 1}
local pSpeed = 0.5 -- pendulum speed - must be a multiplication of 0.25 value ( set 0 - to turn off )
local pMinBright = 0.35 -- minimum brightness ( 0 - 1)

addEventHandler("onClientResourceStart",resourceRoot,
	function()
		local shader = dxCreateShader("shader.fx")

		if not shader then
			return outputChatBox( "Could not create shader. Please use debugscript 3" )
		end
		
		local texture = dxCreateTexture("arrow.png","dxt5")
		dxSetShaderValue(shader,"Tex",texture)
		
		dxSetShaderValue(shader,"UVSpeed", UVSpeed)
		dxSetShaderValue(shader,"UVResize", UVResize)
		dxSetShaderValue(shader,"pSpeed", pSpeed)
		dxSetShaderValue(shader,"pMinBright", pMinBright)

		engineApplyShaderToWorldTexture(shader,"ws_carshowwin1")
		engineSetModelLODDistance (3851, 300)
		engineSetModelLODDistance (18000, 1000)
	end
)

addEventHandler("onClientResourceStart", root,
    function()
		local objects = getElementsByType("object")
		for k, object in ipairs(objects) do 
			if getElementModel(object) == 3851 then
			setObjectBreakable(object, false)
			setElementDoubleSided(object, true)
			local x, y, z = getElementPosition(object)
			local rx, ry, rz = getElementRotation(object)
			newObj = createObject(18000, x, y, z, rx, ry, rz)
			setElementAlpha(newObj, 0)
			setElementParent(newObj, object)
			end
        end
    end
)

addEventHandler("onClientResourceStart", resourceRoot,
    function()
		col = engineLoadCOL ( "1.col" )
		engineReplaceCOL ( col, 18000 )
		dff = engineLoadDFF ( "1.dff" )
		engineReplaceModel ( dff, 18000 )
		outputConsole("Loading NFS-Style Arrows by AleksCore & Ren712")
		outputConsole("---------------------->[Arrow ID: #ff00003851]")
    end
)

addEventHandler("onClientObjectBreak", root,
    function(attacker)
        if getElementModel( source ) == 3851 then
            cancelEvent()
        end
    end
)