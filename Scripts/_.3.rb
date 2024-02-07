class Scene_ItemBase
  alias xxx001_use_item use_item
  def use_item
    xxx001_use_item
    use_escape_item if item.note.include?("<ESCAPE>")
  end
  def use_escape_item
    $game_player.reserve_transfer(9, 8, 16)
    SceneManager.goto(Scene_Map)
  end
end

class Game_BattlerBase
  alias xxx001_usable_item_conditions_met? usable_item_conditions_met?
  def usable_item_conditions_met?(item)
    if item.note.include?("<ESCAPE>") && $game_variables[21] == 0
      false
    else
      xxx001_usable_item_conditions_met?(item)
    end
  end
end
