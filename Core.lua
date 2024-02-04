EnyLootHistory = LibStub("AceAddon-3.0"):NewAddon("EnyLootHistory", "AceConsole-3.0", "AceEvent-3.0")

function EnyLootHistory:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("EnyLootHistoryDB")
  if self.db.global.eventLog == nil then
    self.db.global.eventLog = {}
  end

  EnyLootHistory:RegisterEvent('LOOT_HISTORY_CLEAR_HISTORY', 'LoggerMethod')
  EnyLootHistory:RegisterEvent('LOOT_HISTORY_GO_TO_ENCOUNTER', 'LoggerMethod')
  EnyLootHistory:RegisterEvent('LOOT_HISTORY_UPDATE_DROP', 'LoggerMethod')
  EnyLootHistory:RegisterEvent('LOOT_HISTORY_UPDATE_ENCOUNTER', 'LoggerMethod')
  EnyLootHistory:RegisterEvent('LOOT_ROLLS_COMPLETE', 'LoggerMethod')
  EnyLootHistory:RegisterEvent('LOOT_ITEM_AVAILABLE', 'LoggerMethod')
  EnyLootHistory:RegisterEvent('LOOT_ITEM_ROLL_WON', 'LoggerMethod')

  EnyLootHistory:RegisterEvent('LOOT_HISTORY_UPDATE_DROP', 'LootLoggerMethod')

  EnyLootHistory:Print('EnyLootHistory loaded')
end

function EnyLootHistory:LoggerMethod(...)
  table.insert(self.db.global.eventLog, { ... })
end

function EnyLootHistory:LootLoggerMethod(_, encounterID, lootListID)
  local results = self.db.global.lootLog or {}

  local info = C_LootHistory.GetSortedInfoForDrop(encounterID, lootListID)
      
  results[info.startTime] = results[info.startTime] or {}
  results[info.startTime][encounterID] = results[info.startTime][encounterID] or {}
  results[info.startTime][encounterID][lootListID] = info

  self.db.global.lootLog = results
end