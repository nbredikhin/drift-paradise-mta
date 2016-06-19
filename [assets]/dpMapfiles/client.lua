local ID = 964 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'primring.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'primring.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'primring.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(964, 3000)
    end
)

local ID = 11326 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'hotelgarage.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'hotelgarage.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'hotelgarage.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(11326, 3000)
    end
)

local ID = 3115 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'hotelfoor.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'hotelfoor.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'hotelfoor.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(3115, 3000)
    end
)

local ID = 8417 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'plitkals.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'plitkals.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'plitkals.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(8417, 3000)
    end
)

local ID = 3095 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'floorls.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'floorls.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'floorls.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(3095, 3000)
    end
)

local ID = 16072 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'neboscreb1.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'neboscreb1.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'neboscreb1.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(16072, 3000)
    end
)


local ID = 16073 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'neboscreb2.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'neboscreb2.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'neboscreb2.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(16073, 3000)
    end
)
	
	local ID = 16074 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'neboscreb3.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'neboscreb3.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'neboscreb3.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(16074, 3000)
    end
)

	
	local ID = 16075 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'neboscreb4.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'neboscreb4.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'neboscreb4.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(16075, 3000)
    end
)

	local ID = 14537 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'neboscreb5.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'neboscreb5.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'neboscreb5.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(14537, 3000)
    end
)

local ID = 16648 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'scenaopenair1.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'scenaopenair1.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'scenaopenair1.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(16648, 3000)
    end
)




local ID = 16666 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'scenaopenair2.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'scenaopenair2.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'scenaopenair2.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(16666, 3000)
    end
)

local ID = 16662 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'scenaopenair3.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'scenaopenair3.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'scenaopenair3.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(16662, 3000)
    end
)

local ID = 16665 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'scenaopenair4.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'scenaopenair4.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'scenaopenair4.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(16665, 3000)
    end
)

local ID = 2838 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'scenaopenair5.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'scenaopenair5.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'scenaopenair5.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(2838, 3000)
    end
)

local ID = 914 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'tuningarage1.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'tuningarage1.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'tuningarage1.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(914 , 3000)
    end
)


local ID = 915 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'tuningarage2.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'tuningarage2.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'tuningarage2.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(915, 3000)
    end
)
	
	local ID = 919 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'tuningarage3.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'tuningarage3.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'tuningarage3.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(919, 3000)
    end
)

local ID = 14808 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'stripclub1.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'stripclub1.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'stripclub1.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(14808, 3000)
    end
)

local ID = 14832 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'stripclub2.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'stripclub2.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'stripclub2.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(14832, 3000)
    end
)


local ID = 14833 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'stripclub2.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'stripclub3.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'stripclub3.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(14833, 3000)
    end
)


local ID = 14834 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'stripclub2.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'stripclub4.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'stripclub4.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(14834, 3000)
    end
)


local ID = 14835 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'stripclub2.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'stripclub5.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'stripclub5.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(14835, 3000)
    end
)

local ID = 14836 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'stripclub2.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'stripclub6.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'stripclub6.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(14836, 3000)
    end
)


local ID = 14837 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'stripclub2.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'stripclub7.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'stripclub7.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(14837, 3000)
    end
)

local ID = 14838 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'stripclub2.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'stripclub8.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'stripclub8.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(14838, 3000)
    end
)

local ID = 4550 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'hdneboscreb.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'hdneboscreb.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'hdneboscreb.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(4550 , 3000)
    end
)




