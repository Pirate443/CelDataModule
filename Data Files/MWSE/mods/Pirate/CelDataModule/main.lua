-- Глобальные переменные для хранения названий.
engNameCelData = {}
rusNameCelData = {}

local modName = "Модуль данных cel"
local modVersion = "1.0"

local function loadCelFile(filename)
    local file = io.open(filename, "r")
    if not file then
        mwse.log("[" .. modName .. "] Файл не найден: %s", filename)
        return 0
    end
    
    local counter = 0
    local lineNumber = 0
    local isEmpty = true

    for line in file:lines() do
        isEmpty = false
        lineNumber = lineNumber + 1
        local eng, rus = line:match("^([^\t]+)\t([^\t]+)$")
        if eng and rus then
            table.insert(engNameCelData, eng)
            table.insert(rusNameCelData, rus)
            counter = counter + 1
        else
        mwse.log("[" .. modName .. "] Ошибка в строке %d файла %s", lineNumber, filename)
        end
    end
    file:close()

    if isEmpty then
        mwse.log("[" .. modName .. "] Файл пустой: %s", filename)
    else
    mwse.log("[" .. modName .. "] Загружено %d/%d записей из файла %s", counter, lineNumber, filename)
    end
    return counter
end

local function init()
    mwse.log("[" .. modName .. "] Загрузка данных из файлов .cel")
    -- Загружаем cel файлы для всех активных ESP/ESM.
    for _, modFilename in ipairs(tes3.getModList()) do
        local celFile = "Data Files\\" .. modFilename:gsub("%.[eE][sS][pPmM]$", ".cel")
        loadCelFile(celFile)
    end
    
    mwse.log("[" .. modName .. "] Всего загружено: %d записей", #engNameCelData)
end

mwse.log("[" .. modName .. "] Версия: " .. modVersion)
event.register("initialized", init)