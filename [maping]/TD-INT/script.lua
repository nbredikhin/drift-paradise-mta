local ID = 14476 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'CJHOME.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру

    end
)

local ID = 14489 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'CJHOME2.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру

    end
)


local ID = 14718 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'SHOUSE1.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру

    end
)

local ID = 2090 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'SHOUSE1-BED.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру

    end
)

local ID = 1763 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'SHOUSE1-SOFA1.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру

    end
)

local ID = 1502 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'DOORS1.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру

    end
)

local ID = 1498 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'DOORS2.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру

    end
)

local ID = 1522 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'DOORS4.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру

    end
)

local ID = 984 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'zabor1.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру

    end
)

local ID = 2296 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'TV.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'TV.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'TV.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(2296, 3000)
    end
)


local ID = 8886 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'PS4.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'PS4.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
		
		        local col = engineLoadCOL ( 'PS4.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(8886, 3000)
    end
)

local ID = 1932 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'PS3.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'PS3.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
		
		        local col = engineLoadCOL ( 'PS3.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(1932, 3000)
    end
)
 
 local ID = 1931 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'WIU.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'WIU.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
		
		        local col = engineLoadCOL ( 'WIU.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(1931, 3000)
    end
)
 
 local ID = 1930 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'xbox.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'xbox.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
		
		        local col = engineLoadCOL ( 'xbox.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(1930, 3000)
    end
)
 
 local ID = 1928 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'PC.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'PC.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
		
		        local col = engineLoadCOL ( 'PC.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(1928, 3000)
    end
)
 

local ID = 14713 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'SHOUSE2.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру

    end
)


local ID = 14758 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'SHOUSE3.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру

    end
)

local ID = 1506 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'DOORS3.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру

    end
)

 local ID = 1775 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( 'COLABUY.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'COLABUY.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
		
		        local col = engineLoadCOL ( 'COLABUY.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(1775, 3000)
    end
)



