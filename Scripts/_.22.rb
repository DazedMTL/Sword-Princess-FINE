DataManager
  def self.make_save_header
    header = {}
    header[:characters] = $game_party.characters_for_savefile
    header[:playtime_s] = $game_system.playtime_s
    header[:mapname] = $game_map.display_name #◎ロード画面用にマップ名セット
    header
  end

Window_SaveFile
  def draw_playtime(x, y, width, align)
    header = DataManager.load_header(@file_index)
    return unless header
    draw_text(x, y, width, line_height, header[:playtime_s], 2)
    draw_text(x, y-40, width, line_height,header[:mapname], 2)#◎マップ名
  end