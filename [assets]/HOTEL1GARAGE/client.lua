local ID = 11326 -- Айди объекта на который заменяется клуб
 
addEventHandler ( 'onClientResourceStart', resourceRoot, -- При запуске ресурса подгружаем и заменяем модель
    function ( )
        local txd = engineLoadTXD ( '1.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( '1.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( '1.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(11326, 3000)
    end
)


