local ao = require("ao")
local Store = require("store")

---@param msg Message
function Get(msg)
  assert(type(msg.Tags.Key) == "string", "Key is required")
  local key = msg.Tags.Key
  ao.send({Target=msg.From, Tags={Value = Store[key]}})
end

---@param msg Message
function Set(msg)
  assert(type(msg.Tags.Key) == "string", "Key is required")
  assert(type(msg.Tags.Value) == "string", "Value is required")
  local key = msg.Tags.Key
  local value = msg.Tags.Value
  Store[key] = value
  print(Store)
  Handlers.utils.reply("Value stored")(msg)
end

---@param msg Message
function Delete(msg)
  assert(type(msg.Tags.Key) == "string", "Key is required")
  local key = msg.Tags.Key
  if Store[key] then
    Store[key] = nil
  else
    print("Value of " .. key .. " not found")
  end
  print(Store)
  Handlers.utils.reply("Value deleted")(msg)
end

---@param msg Message
function Display(msg)
  print("=== msg")
  print(msg)
  print("=== Store")
  print(Store)
end

return {
  Get = Get,
  Set = Set,
  Delete = Delete,
  Display = Display
}
