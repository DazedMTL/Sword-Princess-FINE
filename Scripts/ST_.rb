#==============================================================================
# ■ Window_Status_Pictuer for RGSS3
# By masa 不具合や質問はこちらまで → masaasam2012@yahoo.co.jp
#------------------------------------------------------------------------------
# アクターのピクチャを表示するステータス画面。
# ピクチャはActor○(○の中はアクターのID。半角の数字で入力。)の名前でインポート。
#==============================================================================
#用語の設定
module Vocab
  EVA = "Paizuri"          # Physical Evasion Rate
  MEV = "Climax"      # Magical Evasion Rate
  HIT = "Anal"          # Hit Rate
  CRI = "Lewdness"  # Critical Rate
  ExpTotal = "Current EXP"
  ExpNext  = "Next Level"
end

class Window_Status < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(0, 0, Graphics.width, Graphics.height)
    @actor = actor
    refresh
    activate
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
    contents.clear
    draw_block1   (line_height * 0)
    draw_horz_line(line_height * 1)
    draw_block2   (line_height * 2)
#   draw_horz_line(line_height * 6)
    draw_block3   (line_height * 7)
#    draw_horz_line(line_height * 13)
    draw_block4   (line_height * 14)
  end
  #--------------------------------------------------------------------------
  # ● ブロック 1 の描画
  #--------------------------------------------------------------------------
  def draw_block1(y)
    draw_actor_name(@actor, 4, y)
    draw_actor_class(@actor, 138, y)
    draw_actor_nickname(@actor, 225, y)
  end
  #--------------------------------------------------------------------------
  # ● ブロック 2 の描画
  #--------------------------------------------------------------------------
  def draw_block2(y)
#    draw_actor_face(@actor, 8, y)
    draw_basic_info(4, y - 6)
    draw_exp_info(138, y - 6)
    draw_actor_illust(520, 325, 0)
  end
  #--------------------------------------------------------------------------
  # ● ブロック 3 の描画
  #--------------------------------------------------------------------------
  def draw_block3(y)
    draw_parameters(4, y - 48)
    draw_slot_name(138, y - 48)
    draw_equipments(138, y - 30)
  end
  #--------------------------------------------------------------------------
  # ● ブロック 4 の描画
  #--------------------------------------------------------------------------
  def draw_block4(y)
    draw_description(4, y)
  end
  #--------------------------------------------------------------------------
  # ● 水平線の描画
  #--------------------------------------------------------------------------
  def draw_horz_line(y)
    line_y = y + line_height / 2 - 1
    contents.fill_rect(0, line_y, contents_width, 2, line_color)
  end
  #--------------------------------------------------------------------------
  # ● 水平線の色を取得
  #--------------------------------------------------------------------------
  def line_color
    color = normal_color
    color.alpha = 48
    color
  end
  #--------------------------------------------------------------------------
  # ● 基本情報の描画
  #--------------------------------------------------------------------------
  def draw_basic_info(x, y)
    self.contents.font.size = 24
    draw_actor_level(@actor, x, y + line_height * 1 - 18)
    self.contents.font.size = 24
#    draw_actor_icons(@actor, x + 60, y + line_height * 0)
    draw_actor_hp(@actor, x, y + line_height * 2 - 18)
    draw_actor_mp(@actor, x, y + line_height * 3 - 18)
#    draw_actor_tp(@actor, 396, y + line_height * 4 - 130)
  end
  #--------------------------------------------------------------------------
  # ● 能力値の描画1
  #     x : 描画先 X 座標
  #     y : 描画先 Y 座標
  #--------------------------------------------------------------------------
  def draw_parameters(x, y)                      #↓行間を調節している
    case @actor.id
    when 1
    draw_actor_param(@actor, x, y - 24 + line_height +  0, 0)  #ATK
    draw_actor_param(@actor, x, y - 24 + line_height + 20, 1)  #DEF
#    draw_actor_param(@actor, x, y - 24 + line_height + 60, 2)  #MAT
#    draw_actor_param(@actor, x, y - 24 + line_height + 80, 3)  #MDF
#    draw_actor_param(@actor, x, y - 24 + line_height + 100, 4)  #AGI
#    draw_actor_param(@actor, x, y - 24 + line_height + 120, 5)  #LUK
    draw_actor_param(@actor, x, y - 24 + line_height + 60, 6)  #EVA
    draw_actor_param(@actor, x, y - 24 + line_height + 80, 7)  #MEV
    draw_actor_param(@actor, x, y - 24 + line_height + 100, 8)  #CRI
    draw_actor_param(@actor, x, y - 24 + line_height + 120, 9)  #HIT
    when 5
    draw_actor_param(@actor, x, y - 24 + line_height +  0, 0)  #ATK
    draw_actor_param(@actor, x, y - 24 + line_height + 20, 1)  #DEF
    when 6
    draw_actor_param(@actor, x, y - 24 + line_height + 0, 2)  #MAT
    draw_actor_param(@actor, x, y - 24 + line_height + 20, 1)  #DEF
    end
  end
  #--------------------------------------------------------------------------
  # ● 能力値の描画 2
  #--------------------------------------------------------------------------
  def draw_actor_param(actor, x, y, param_id)
    case param_id
    when 0  #atk  攻撃力
      parameter_name = Vocab::param(2)
      parameter_value = actor.atk
      when 1  #def  防御力
      parameter_name = Vocab::param(3)
      parameter_value = actor.def
    when 2  #mat  魔法攻撃力
      parameter_name = Vocab::param(4)
      parameter_value = actor.mat
    when 3  #mdf  魔法防御力
      parameter_name = Vocab::param(5)
      parameter_value = actor.mdf
    when 4  #agi  敏捷性
      parameter_name = Vocab::param(6)
      parameter_value = actor.agi
    when 5  #luk  運
      parameter_name = Vocab::param(7)
      parameter_value = actor.luk
    when 6  #EVA  物理回避
      parameter_name = Vocab::EVA
      parameter_value = $game_variables[88]
    when 7  #MEV  魔法回避
      parameter_name = Vocab::MEV
      parameter_value = $game_variables[89]
    when 8  #HIT  命中率
      parameter_name = Vocab::HIT
      parameter_value = $game_variables[90]
    when 9  #CRI  クリティカル率
      parameter_name = Vocab::CRI
      parameter_value = $game_variables[98]
    end
    parameter_value2 = "#{sprintf("%.0f", parameter_value)}"
    contents.font.size = 20 #フォントサイズ
    change_color(system_color)
    draw_text(x, y, 70, line_height, parameter_name)
    change_color(normal_color)
    draw_text(x + 72, y, 36, line_height, parameter_value2, 2)
  end
  #--------------------------------------------------------------------------
  # ● 経験値情報の描画 304, y
  #--------------------------------------------------------------------------
  def draw_actor_exp_gauge(actor, x, y, width = 110)
    if @actor.level == 99
      gw = width
    else
      exp_list = @actor.instance_variable_get(:@exp_list)
    now = @actor.exp - @actor.current_level_exp
    max = @actor.next_level_exp - @actor.current_level_exp
    gw = width * now / max
    end
    gc1 = text_color(28)
    gc2 = text_color(29)
    self.contents.fill_rect(x + 96, y - 68, width, 6, gauge_back_color)
    self.contents.gradient_fill_rect(x + 96, y - 68, gw, 6, gc1, gc2)
  end
  def draw_exp_info(x, y)
    s2 = @actor.max_level? ? "-------" : @actor.next_level_exp - @actor.exp
    draw_actor_exp_gauge(x, y , 180)
    contents.font.size = 20 #フォントサイズ
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 180, line_height - 4, Vocab::ExpTotal)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y + 40, 180, line_height - 4, Vocab::ExpNext)
    self.contents.font.color = normal_color
    self.contents.draw_text(x - 72, y + 20, 184, line_height - 4, @actor.exp, 2)
    self.contents.font.color = normal_color
    self.contents.draw_text(x - 70, y + 58, 180, line_height - 4, s2, 2)
  end
  #--------------------------------------------------------------------------
  # ● 装備スロットの名前を取得
  #--------------------------------------------------------------------------
  def draw_slot_name(x, y)                      #↓行間を調節している
    draw_actor_slot_name(@actor, x, y - 24 + line_height +   0, 0)  #武器
    draw_actor_slot_name(@actor, x, y - 24 + line_height +  40, 1)  #盾
    draw_actor_slot_name(@actor, x, y - 24 + line_height +  80, 2)  #頭
    draw_actor_slot_name(@actor, x, y - 24 + line_height + 120, 3)  #身体
    draw_actor_slot_name(@actor, x, y - 24 + line_height + 160, 4)  #装飾品
  end
  #--------------------------------------------------------------------------
  # ● 装備スロットの名称描画1
  #--------------------------------------------------------------------------
  def draw_actor_slot_name(actor, x, y, etype_id)
    case etype_id
    when 0  #武器スロット
      etype_name = Vocab::etype(0)
    when 1  #盾スロット
      etype_name = Vocab::etype(1)
    when 2  #頭スロット
      etype_name = Vocab::etype(2)
    when 3  #身体スロット
      etype_name = Vocab::etype(3)
    when 4  #装飾品スロット
      etype_name = Vocab::etype(4)
    end
    contents.font.size = 16 #フォントサイズ
    change_color(system_color)
    draw_text(x, y, 70, line_height, etype_name)
  end
  #--------------------------------------------------------------------------
  # ● 装備スロットの名称描画2
  #--------------------------------------------------------------------------
  def draw_equipments(x, y)
    @actor.equips.each_with_index do |item, i|
    contents.font.size = 20 #フォントサイズ
      draw_item_name(item, x, y + 40 * i)
    end
  end
  #--------------------------------------------------------------------------
  # ● ピクチャの描画 
  #--------------------------------------------------------------------------
  def draw_actor_illust(x, y, z)
    case @actor.id
    when 1  #盾スロット
      bitmap = Cache.picture("Actor#{$game_variables[97]}") #衣装変数97
    when 5  #盾スロット
      bitmap = Cache.picture("Actor#{$game_variables[97]}") #衣装変数97
    when 6  #盾スロット
      bitmap = Cache.picture("Actor#{@actor.id}")
    end
#    bitmap = Cache.picture("Actor#{$game_variables[97]}") #衣装変数97
#    bitmap = Cache.picture("Actor#{@actor.id}")
#    x -= bitmap.width
#    y -= bitmap.height
    x = 255
    y = 0
    z = - 544
    self.contents.blt(x, y, bitmap, bitmap.rect)
  end
  #--------------------------------------------------------------------------
  # ● 説明の描画
  #--------------------------------------------------------------------------
  def draw_description(x, y)
    draw_text_ex(x, y, @actor.description)
  end
end
