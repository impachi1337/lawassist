local requests = require 'requests'
local ffi = require 'ffi'

local version = "1.0"
local version_url = "https://raw.githubusercontent.com/impachi1337/lawassist/refs/heads/main/version.txt"
local script_url = "https://raw.githubusercontent.com/USER/REPO/main/script.lua"

local script_path = thisScript().path

local function downloadFile(url, path)
    local res = requests.get(url)
    if res and res.text then
        local file = io.open(path, "wb")
        file:write(res.text)
        file:close()
        return true
    end
    return false
end

local function checkUpdate()
    local res = requests.get(version_url)
    if not res then return end

    local latest = res.text:gsub("%s+", "")

    if latest ~= version then
        sampAddChatMessage("[Updater] Обновление найдено! Скачиваю...", -1)

        if downloadFile(script_url, script_path) then
            sampAddChatMessage("[Updater] Обновлено! Перезапусти скрипт.", -1)
        else
            sampAddChatMessage("[Updater] Ошибка обновления.", -1)
        end
    else
        sampAddChatMessage("[Updater] У тебя последняя версия.", -1)
    end
end

function main()
    repeat wait(0) until isSampAvailable()

    wait(3000)
    checkUpdate()

    while true do wait(0) end
end