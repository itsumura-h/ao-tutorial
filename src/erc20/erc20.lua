local ao = require("ao")
local bint = require(".bint")(256)
Storage = require("storage")


---@param msg Message
local function Deploy(msg)
  assert(type(msg.Tags.Name) == "string", "Name is required")
  assert(type(msg.Tags.Symbol) == "string", "Symbol is required")
  assert(Storage.initialized == false, "Already initialized")

  Storage.tokenName = msg.Tags.Name
  Storage.symbol = msg.Tags.Symbol
  Storage.owner = msg.From
  Storage.initialized = true
  print(Storage)
  Handlers.utils.reply("Deployed")(msg)
end


---@param msg Message
local function Mint(msg)
  assert(type(msg.Tags.To) == "string", "To address is required")
  assert(bint.__le(0, bint(msg.Tags.Amount)), "Amount must be greater than 0")
  assert(msg.From == Storage.owner, "Only the owner can mint")

  local to = msg.Tags.To
  local amount = bint(msg.Tags.Amount)

  if not Storage.balances[to] then
    Storage.balances[to] = "0"
  end

  local newBalance = bint.__add(bint(Storage.balances[to]), amount)
  local newTotalSupply = bint.__add(bint(Storage.totalSupply), amount)

  Storage.balances[to] = tostring(newBalance)
  Storage.totalSupply = tostring(newTotalSupply)

  print(Storage)
  ao.send({ Target = msg.From, Tags = { Action = "Mint", To = to, Amount =  amount } })
end


-- ---@param msg Message
-- function Transfer(msg)
--   assert(type(msg.Tags.From) == "string", "From address is required")
--   assert(type(msg.Tags.To) == "string", "To address is required")
--   assert(0 < tonumber( msg.Tags.Amount), "Amount must be greater than 0")
  
--   local from = msg.Tags.From
--   local to = msg.Tags.To
--   local amount = tonumber(msg.Tags.Amount)
  
--   assert(Store.balanceOf[from] >= amount, "Insufficient balance")
  
--   Store.balanceOf[from] = Store.balanceOf[from] - amount
--   Store.balanceOf[to] = Store.balanceOf[to] + amount
  
--   ao.send({ Target = msg.From, Tags = { Action = "Transfer", From = from, To = to, Amount = tostring(amount) } })
-- end


-- ---@param msg Message
-- function Approve(msg)
--   assert(type(msg.Tags.Spender) == "string", "Spender address is required")
--   assert(0 < tonumber( msg.Tags.Amount), "Amount must be greater than 0")
  
--   local owner = msg.From
--   local spender = msg.Tags.Spender
--   local amount = tonumber(msg.Tags.Amount)

--   Store.allowance[owner][spender] = amount
  
--   ao.send({ Target = msg.From, Tags = { Action = "Approval", Owner = owner, Spender = spender, Amount = tostring(amount) } })
-- end


-- ---@param msg Message  
-- function TransferFrom(msg)
--   assert(type(msg.Tags.Spender) == "string", "Spender address is required")
--   assert(type(msg.Tags.Recipient) == "string", "Recipient address is required")
--   assert(0 < tonumber( msg.Tags.Amount), "Amount must be greater than 0")
  
--   local sender = msg.Tags.Spender
--   local recipient = msg.Tags.Recipient
--   local amount = tonumber(msg.Tags.Amount)
  
--   assert(Store.allowance[sender][recipient] >= amount, "Insufficient allowance")
--   assert(Store.balanceOf[sender] >= amount, "Insufficient balance")
  
--   Store.allowance[sender][msg.From] = Store.allowance[sender][msg.From] - amount
--   Store.balanceOf[sender] = Store.balanceOf[sender] - amount
--   Store.balanceOf[recipient] = Store.balanceOf[recipient] + amount
  
--   ao.send({ Target = msg.From, Tags = { Action = "Transfer", Spender = sender, Recipient = recipient, Amount = tostring(amount) } })
-- end


-- ---@param msg Message  
-- function Burn(msg)
--   assert(type(msg.Tags.From) == "string", "From address is required")
--   assert(type(msg.Tags.Amount) == "string", "Amount is required")
  
--   local from = msg.From
--   local amount = tonumber(msg.Tags.Amount)
--   assert(amount > 0, "Amount must be greater than 0")
  
--   assert(Store.balanceOf[from] >= amount, "Insufficient balance")
  
--   Store.balanceOf[from] = Store.balanceOf[from] - amount
--   Store.totalSupply = Store.totalSupply - amount
  
--   ao.send({ Target = msg.From, Tags = { Action = "Transfer", From = from, To = "0x0", Value = tostring(amount) } })
-- end

-- ---@param msg Message
-- function TotalSupply(msg)
--   ao.send({ Target = msg.From, Tags = { TotalSupply = tostring(Store.totalSupply) } })
-- end

-- ---@param msg Message
-- function Name(msg)
--   ao.send({ Target = msg.From, Tags = { Name = Store.TokenName } })
-- end

-- ---@param msg Message
-- function Symbol(msg)
--   ao.send({ Target = msg.From, Tags = { Symbol = Store.Symbol } })
-- end

---@param msg Message
local function BalanceOf(msg)
  assert(type(msg.Tags.Account) == "string", "Account is required")

  local account = msg.Tags.Account

  local balance = ""
  if not Storage.balances[account] then
    balance = "0"
  else
    balance = Storage.balances[account]
  end

  ao.send({ Target = msg.From, Tags = { Amount = balance } })
end


---@param msg Message
local function Display(msg)
  -- print("=== msg")
  -- print(msg)
  print("=== Storage")
  print(Storage)
end

return {
  Deploy = Deploy,
  Mint = Mint,
  BalanceOf = BalanceOf,
  Display = Display,
}
