local Dispatcher = {}

function Dispatcher:new ()
    local state = {
        listeners = {}
    }

    setmetatable(state, self)
    self.__index = self

    return state
end

-- Add a new listener to the dispatcher
--
-- @param string eventName
-- @param callable listener
--
-- @return nil
function Dispatcher:addListener(eventName, listener)
    if type(listener) ~= "function" then
        error("A registered listener must be callable")
    end

    if self.listeners[eventName] == nil then
        self.listeners[eventName] = {}
    end

    local list = self.listeners[eventName]

    self.listeners[eventName][#list + 1] = listener
end


-- Remove a specific listener from the table
--
-- @param string eventName
-- @param callable listener
--
-- @return nil
function Dispatcher:removeListener(eventName, listener)
    local listeners = self:getListeners(eventName)

    for key, registeredListener in pairs(listeners) do
        if registeredListener == listener then
            listeners[key] = nil
        end
    end
end

function Dispatcher:getListeners(name)
    local listeners = self.listeners[name] or {}

    return listeners
end

function Dispatcher:dispatch(name, event)
    local listeners = self:getListeners(name)

    for key, listener in pairs(listeners) do
        pcall(listener, event)
    end
end

return Dispatcher
