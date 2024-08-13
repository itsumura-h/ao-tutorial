-- .load interface.lua
local erc20 = require("erc20")

-- Send({ Target = ao.id, Tags = { Action = "Deploy", Name = "AoToken", Symbol = "AOT"}})
Handlers.add("Deploy",Handlers.utils.hasMatchingTag("Action", "Deploy"), erc20.Deploy)

-- Send({ Target = ao.id, Tags = { Action = "Mint", To = ao.id, Amount = "1000"}})
Handlers.add("Mint",Handlers.utils.hasMatchingTag("Action", "Mint"), erc20.Mint)

-- Send({ Target = ao.id, Tags = { Action = "BalanceOf", Account = ao.id }})
Handlers.add("BalanceOf",Handlers.utils.hasMatchingTag("Action", "BalanceOf"), erc20.BalanceOf)

-- Send({ Target = ao.id, Tags = { Action = "Display"}})
Handlers.add("Display",Handlers.utils.hasMatchingTag("Action", "Display"), erc20.Display)
