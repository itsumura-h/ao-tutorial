-- .aos
-- .load routes.lua

local controller = require("controller")

-- Send({ Target = ao.id, Tags = { Action = "Get", Key = "key1" }})
Handlers.add("Get",Handlers.utils.hasMatchingTag("Action", "Get"),controller.Get)

-- Send({ Target = ao.id, Tags = { Action = "Set", Key = "key1", Value = "value1" }})
Handlers.add("Set", Handlers.utils.hasMatchingTag("Action", "Set"), controller.Set)

-- Send({ Target = ao.id, Tags = { Action = "Delete", Key = "key1" }})
Handlers.add("Delete", Handlers.utils.hasMatchingTag("Action", "Delete"), controller.Delete)

-- Send({ Target = ao.id, Tags = { Action = "Display" }})
Handlers.add("Display", Handlers.utils.hasMatchingTag("Action", "Display"), controller.Display)
