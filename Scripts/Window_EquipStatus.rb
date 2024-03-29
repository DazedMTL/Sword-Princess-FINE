#==============================================================================
# ■ Window_EquipStatus
#------------------------------------------------------------------------------
# 　装備画面で、アクターの能力値変化を表示するウィンドウです。
#==============================================================================

class Window_EquipStatus < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, window_width, window_height)
    @actor = nil
    @temp_actor = nil
    refresh
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    return 208
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ高さの取得
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(visible_line_number)
  end
  #--------------------------------------------------------------------------
  # ● 表示行数の取得
  #--------------------------------------------------------------------------
  def visible_line_number
    return 7
  end
  #--------------------------------------------------------------------------
  # ● アクターの設定
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
#    contents.clear
#    draw_actor_name(@actor, 4, 0) if @actor
#    6.times {|i| draw_item(0, line_height * (1 + i), 2 + i) }
    contents.clear
    draw_actor_name(@actor, 4, 0) if @actor
    draw_item(0, line_height * 1, 2)
    draw_item(0, line_height * 2, 3)
#    draw_item(0, line_height * 3, 4)
#    draw_item(0, line_height * 4, 6)
  end
  #--------------------------------------------------------------------------
  # ● 装備変更後の一時アクター設定
  #--------------------------------------------------------------------------
  def set_temp_actor(temp_actor)
    return if @temp_actor == temp_actor
    @temp_actor = temp_actor
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------
  def draw_item(x, y, param_id)
    draw_param_name(x + 4, y, param_id)
    draw_current_param(x + 94, y, param_id) if @actor
    draw_right_arrow(x + 126, y)
    draw_new_param(x + 150, y, param_id) if @temp_actor
  end
  #--------------------------------------------------------------------------
  # ● 能力値の名前を描画
  #--------------------------------------------------------------------------
  def draw_param_name(x, y, param_id)
    change_color(system_color)
    draw_text(x, y, 80, line_height, Vocab::param(param_id))
  end
  #--------------------------------------------------------------------------
  # ● 現在の能力値を描画
  #--------------------------------------------------------------------------
  def draw_current_param(x, y, param_id)
    change_color(normal_color)
    draw_text(x, y, 32, line_height, @actor.param(param_id), 2)
  end
  #--------------------------------------------------------------------------
  # ● 右向き矢印を描画
  #--------------------------------------------------------------------------
  def draw_right_arrow(x, y)
    change_color(system_color)
    draw_text(x, y, 22, line_height, "→", 1)
  end
  #--------------------------------------------------------------------------
  # ● 装備変更後の能力値を描画
  #--------------------------------------------------------------------------
  def draw_new_param(x, y, param_id)
    new_value = @temp_actor.param(param_id)
    change_color(param_change_color(new_value - @actor.param(param_id)))
    draw_text(x, y, 32, line_height, new_value, 2)
  end
end
