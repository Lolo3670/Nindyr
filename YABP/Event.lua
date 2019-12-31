_G.Triggers = {} --Table (key = name) of Array of Structure : Effet, Arg
_G.Effects = {} --Table (key = name) of function with 1 argument

function AddCallback(object, event, callback)
    if (object[event] == nil) then
        object[event] = callback
    else
        if (type(object[event]) == "table") then
            table.insert(object[event], callback)
        else
            object[event] = {object[event], callback}
        end
    end
end

function RemoveCallback(object, event, callback)
    if (object[event] == callback) then
        object[event] = nil
    else
        if (type(object[event]) == "table") then
            for k, x in pairs(object[event]) do
                if x == callback then
                    object[event][k] = nil
                end
            end
        end
    end
end

function FireEvent(name)
    for _, x in pairs(_G.Triggers[name]) do
        x[1](x[2])
    end
end

function AddListener(object, event, toTest, value, ifTrue, ifFalse)
    AddCallback(object, event, function (sender, _)
        if type(sender[toTest]) == "function" then
            if sender[toTest](object) == value then
                FireEvent(ifTrue)
            else
                FireEvent(ifFalse)
            end
        else
            if sender[toTest] == value then
                FireEvent(ifTrue)
            else
                FireEvent(ifFalse)
            end
        end
    end)
end

function DebugCallback(sender, args)
    Turbine.Shell.WriteLine("--> "..tostring(sender))
    for k, x in pairs(args) do
        Turbine.Shell.WriteLine(tostring(k).." : "..tostring(x))
    end
end

function Debug(value)
    Turbine.Shell.WriteLine(value)
end

--Example
--AddListener(Turbine.Gameplay.LocalPlayer.GetInstance(), "InCombatChanged", "IsInCombat", true, "inCombat", "notInCombat")
--FR : Verifie pour le joueur local s'il est en combat quand InCombatChanged est appelé, si oui il execute les fonctions de inCombat sinon il execute les effets de notInCombat