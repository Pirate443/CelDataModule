-- Глобальные переменные для хранения названий.
engNameCelData = {}
rusNameCelData = {}

local function loadCelFile(filename)
    local file = io.open(filename, "r")
    if not file then
        mwse.log("[CelData] Файл не найден: %s", filename)
        return 0
    end
    
    local counter = 0
    local lineNumber = 0
    
    for line in file:lines() do
        lineNumber = lineNumber + 1
        local eng, rus = line:match("^([^\t]+)\t([^\t]+)$")
        if eng and rus then
            table.insert(engNameCelData, eng)
            table.insert(rusNameCelData, rus)
            counter = counter + 1
        end
    end
    file:close()
    
    mwse.log("[CelData] Загружено %d/%d записей из %s", counter, lineNumber, filename)
    return counter
end

local function init()
    -- Загружаем cel файлы для всех активных ESP/ESM.
    for _, modFilename in ipairs(tes3.getModList()) do
        local celFile = "Data Files\\" .. modFilename:gsub("%.[eE][sS][pPmM]$", ".cel")
        loadCelFile(celFile)
    end
    
    mwse.log("[CelData] Всего загружено: %d записей", #engNameCelData)
end

event.register("initialized", init)