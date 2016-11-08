local ID = 2497 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( '1.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( '1.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( '1.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(2497, 3000)
    end
)


local ID = 2498 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( '2.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( '2.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( '2.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(2498, 3000)
    end
)


local ID = 2499 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( '2.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( '3.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( '3.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(2499, 3000)
    end
)

local ID = 1492 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( '2.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( '7.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( '7.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(1492, 3000)
    end
)


local ID = 2550 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( '1.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( '4.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( '4.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(2550, 3000)
    end
)

local ID = 2551 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( '2.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( '5.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( '5.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(2551, 3000)
    end
)


