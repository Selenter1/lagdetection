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

PLUGIN.init = false
PLUGIN.lag_count = 0

PLUGIN.rate_limit = 3
PLUGIN.lag_limit = 4
PLUGIN.sendclient = true

PLUGIN.ents_list = {
    { -- FREEZE
        ent = {
            -- GM
            ["prop_physics"] = true,
            ["prop_ragdoll"] = true,
            -- ["prop_dynamic"] = true,
            ["gmod_balloon"] = true,
            ["gmod_wheel"] = true,
            ["gmod_dynamite"] = true,
            ["gmod_hoverball"] = true,

            -- HELIX
            ["ix_item"] = true,
            ["ix_money"] = true,
            ["ix_combinelock"] = true,
            ["ix_forcefield"] = true,
            ["ix_rationdispenser"] = true,
            ["ix_vendingmachine"] = true,
            ["ix_vendor"] = true,
            ["ix_container"] = true
        },
        func = function(entity)
            local physObj = entity:GetPhysicsObject()

            if (IsValid(physObj)) then
                physObj:EnableMotion(false)
            end
        end
    },
    { -- REMOVE
        ent = {
            ["keyframe_rope"] = true
        },
        func = function(entity)
            entity:Remove()
        end
    }
}

timer.Create("LD.Init", 0, 1, function() -- init
    timer.Remove("LD.Init")
    PLUGIN.init = true
end)

function PLUGIN:LagDetection(rate)
    if (!self._measurestime or CurTime() >= self._measurestime) then
        for k1, v1 in pairs(ents.GetAll()) do
            local class = v1:GetClass()

            for k2, v2 in pairs(self.ents_list) do
                local inList = self.ents_list[k2].ent[class]

                if inList and IsValid(v1) then
                    local effectdata = EffectData()
                    effectdata:SetOrigin(v1:GetPos())
                    effectdata:SetEntity(v1)
                    util.Effect( "phys_freeze", effectdata, true, true )

                    self.ents_list[k2].func(v1)
                end
            end
        end

        if self.sendclient then
            for k, v in pairs(player.GetAll()) do
                netstream.Start(v, "LD.ClearTrash")
            end
        end

        self._measurestime = CurTime() + 5
    end

    self:ClearTime()
end

function PLUGIN:ClearTime()
    self.lag_count = 0
    self.cleartime = SysTime() - CurTime()
    self._cleartime = CurTime() + 20
end

function PLUGIN:Think()
    if !self.init then return end

    self.cleartime = self.cleartime or SysTime() - CurTime()

    local rate = (SysTime() - self.cleartime) - CurTime()

    if rate >= self.rate_limit and (!self._lagtime or SysTime() >= self._lagtime) then
        self.lag_count = math.Clamp(self.lag_count + 1, 0, self.lag_limit)
        self._lagtime = SysTime() + 0.5
    end

    if self.lag_count >= self.lag_limit then
        hook.Run("LagDetection", rate)
    end

    if (!self._lagremove or CurTime() >= self._lagremove) then
        self.lag_count = math.Clamp(self.lag_count - 1, 0, self.lag_limit)
        self._lagremove = CurTime() + 15
    end

    if (!self._cleartime or CurTime() >= self._cleartime) then
        self:ClearTime()
    end
end