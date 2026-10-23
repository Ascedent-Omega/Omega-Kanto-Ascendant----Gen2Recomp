-- Small, explicit adapters for the current shared battler-based host.
-- No Pokemon, save, party or engine file is rewritten.
local M={}
function M.install()
  local Battle=require('src.battle.BattleState')
  if type(Battle.playerPartyView)~='function' then
    -- Match this release's own battle HUD/party selection source: a battle
    -- may supply an explicit party; otherwise the live save owns the party.
    function Battle:playerPartyView()
      return self.playerParty or self.game.save.party
    end
  end
  return true
end
return M
