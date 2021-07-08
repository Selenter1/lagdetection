--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN

function PLUGIN:ClearDecals()
    RunConsoleCommand("r_cleardecals")
end

function PLUGIN:ClearClientSideRagdoll()
    for k, v in pairs(ents.FindByClass("class C_ClientRagdoll")) do
        v:Remove()
    end
end

netstream.Hook("LD.ClearTrash", function()
    PLUGIN:ClearDecals()
    PLUGIN:ClearClientSideRagdoll()
end)