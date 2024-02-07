
#===========================================================================
# ◆ A1 Scripts ◆
#    拡張選択肢（RGSS3）
#
# バージョン   ： 1.10 (2012/01/02)
# 作者         ： A1
# URL　　　　　： http://a1tktk.web.fc2.com/
#---------------------------------------------------------------------------
# 機能：
# ・多くの選択項目を表示する選択肢です
#---------------------------------------------------------------------------
# 更新履歴　　 ：2011/12/15 Ver1.00 リリース
#         　　 ：2012/01/01 Ver1.01 キャンセル時の不具合を修正 
#         　　 ：2012/01/02 Ver1.10 A1共通スクリプトVer3.30対応
#         　　 ：2012/01/09 Ver1.20 表示位置指定機能追加
#         　　 ：2012/01/09 Ver1.20 拡張選択肢の選択肢に配列対応
#---------------------------------------------------------------------------
# 設置場所      
#　　A1共通スクリプトより下
#
# 必要スクリプト
#    A1共通スクリプト
#---------------------------------------------------------------------------
# 使い方
#　イベントコマンド「注釈」に記述
#
#　  拡張選択肢 c,v,s1,s2,s3…
#　  拡張選択肢 c,v,[s1,s2,s3…],x,y
#　             c：キャンセル時に選択されるIndex
#　             v：選択した結果が格納される変数番号
#　             s：選択肢文字列
#               x：選択肢ウィンドウの表示x座標
#                  左・中・右 もしくは 数値で記述
#               y：選択肢ウィンドウの表示y座標
#                  上・中・下 もしくは 数値で記述
#
#               変数番号を省略した場合でも
#               $game_message.choice_index に結果が格納されます
#
#               キャンセル時に選択されるIndexを -1 にすると
#               キャンセル無効になります
#
#    拡張選択肢の選択肢に配列対応
#    [ ] で囲んだ文字列が選択肢になります
#
#    表示位置指定機能は、選択肢を配列にすることで有効になります
#
#    当スクリプト実行直後に文章コマンドが存在すると
#    文章コマンドを先に実行して、拡張選択肢を表示します
#==============================================================================
$imported ||= {}
$imported["A1_ExChoice"] = true
if $imported["A1_Common_Script"]
old_common_script("拡張選択肢", "3.30") if common_version < 3.30
#==============================================================================
# ■ Game_Message
#------------------------------------------------------------------------------
# 　文章や選択肢などを表示するメッセージウィンドウの状態を扱うクラスです。この
# クラスのインスタンスは $game_message で参照されます。
#==============================================================================

class Game_Message
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :choice_index             # 選択肢のIndex
  attr_accessor :choice_cancel            # 選択肢のキャンセル
  attr_accessor :choice_x                 # 選択肢のx座標
  attr_accessor :choice_y                 # 選択肢のy座標
  #--------------------------------------------------------------------------
  # ☆ クリア
  #--------------------------------------------------------------------------
  alias a1_ex_choice_mg_initialize initialize
  def initialize
    a1_ex_choice_mg_initialize
    @choice_index  = -1
    @choice_cancel = false
    @choice_x      = nil
    @choice_y      = nil
  end
end
#==============================================================================
# ■ Window_ChoiceList
#------------------------------------------------------------------------------
# 　イベントコマンド［選択肢の表示］に使用するウィンドウです。
#==============================================================================

class Window_ChoiceList < Window_Command
  #--------------------------------------------------------------------------
  # ☆ ウィンドウ位置の更新
  #--------------------------------------------------------------------------
  alias a1_ex_choice_wc_update_placement update_placement
  def update_placement
    a1_ex_choice_wc_update_placement
    setup_x
    setup_y
    fit_height
  end
  #--------------------------------------------------------------------------
  # ○ x座標のセットアップ
  #--------------------------------------------------------------------------
  def setup_x
    return if !$game_message.choice_x || $game_message.choice_x.empty?
    return self.x = 0 if $game_message.choice_x == "左"
    return self.x = (Graphics.width - self.width) / 2 if $game_message.choice_x == "中"
    return if $game_message.choice_x == "右"
    self.x = $game_message.choice_x.to_i
  end
  #--------------------------------------------------------------------------
  # ○ y座標のセットアップ
  #--------------------------------------------------------------------------
  def setup_y
    return if !$game_message.choice_y || $game_message.choice_y.empty?
    return self.y = 0 if $game_message.choice_x == "上"
    return self.y = (Graphics.height - self.height) / 2 if $game_message.choice_y == "中"
    return self.y = Graphics.height - self.height if $game_message.choice_y == "下"
    self.y = $game_message.choice_y.to_i
  end
  #--------------------------------------------------------------------------
  # ○ 高さの調整
  #--------------------------------------------------------------------------
  def fit_height
    if self.y < 0
      self.y = 0
      self.height = Graphics.height - @message_window.height
    end
    if self.y + self.height > Graphics.height
      self.height = Graphics.height - self.y 
    end
  end
  #--------------------------------------------------------------------------
  # ☆ 決定ハンドラの呼び出し
  #--------------------------------------------------------------------------
  alias a1_ex_choice_wc_call_ok_handler call_ok_handler
  def call_ok_handler
    $game_message.choice_cancel = false
    $game_message.choice_index = index
    a1_ex_choice_wc_call_ok_handler
  end
  #--------------------------------------------------------------------------
  # ☆ キャンセルハンドラの呼び出し
  #--------------------------------------------------------------------------
  alias a1_ex_choice_wc_call_cancel_handler call_cancel_handler
  def call_cancel_handler
    $game_message.choice_cancel = true
    a1_ex_choice_wc_call_cancel_handler
  end
end
#==============================================================================
# ■ A1_System::CommonModule
#==============================================================================

class A1_System::CommonModule
  #--------------------------------------------------------------------------
  # ☆ 注釈コマンド定義
  #--------------------------------------------------------------------------
  alias a1_ex_choice_define_command define_command
  def define_command
    a1_ex_choice_define_command
    @cmd_108["拡張選択肢"] = :a1_ex_choice
  end
end
#==============================================================================
# ■ Game_Interpreter
#------------------------------------------------------------------------------
# 　イベントコマンドを実行するインタプリタです。このクラスは Game_Map クラス、
# Game_Troop クラス、Game_Event クラスの内部で使用されます。
#==============================================================================

class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # ○ 拡張選択肢付き文章の表示
  #--------------------------------------------------------------------------
  def ex_choice_with_message(choice_param, cancel_index)
    wait_for_message
    @index += 1
    params = @list[@index].parameters
    $game_message.face_name = params[0]
    $game_message.face_index = params[1]
    $game_message.background = params[2]
    $game_message.position = params[3]
    while next_event_code == 401       # 文章データ
      @index += 1
      $game_message.add(@list[@index].parameters[0])
    end
    ex_choice(choice_param, cancel_index)
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # ○ 拡張選択肢の処理
  #--------------------------------------------------------------------------
  def ex_choice(choice_param, cancel_index)
    setup_choices([choice_param, cancel_index])
    Fiber.yield while $game_message.choice?
    unless @variable_no.empty?
      return $game_variables[@variable_no.to_i] = $game_message.choice_index unless $game_message.choice_cancel
      $game_variables[@variable_no.to_i] = cancel_index - 1
    end
  end
  #--------------------------------------------------------------------------
  # ○ 拡張選択肢
  #--------------------------------------------------------------------------
  def a1_ex_choice(params)
    cancel_index = params[0].to_i + 1
    params.delete_at(0)
    @variable_no = params[0]
    params.delete_at(0)
    return setup_choice_param(cancel_index, params) unless params[0].is_a?(Array)
    $game_message.choice_x = params[1]
    $game_message.choice_y = params[2]
    setup_choice_param(cancel_index, params[0])
  end
  #--------------------------------------------------------------------------
  # ○ 選択肢のセットアップ
  #--------------------------------------------------------------------------
  def setup_choice_param(cancel_index, params)
    choice_param = params
    choice_param = $a1_common.send_method($1) if params[0] =~ /@m\((.+)\)/
    return ex_choice_with_message(choice_param, cancel_index) if next_event_code == 101
    ex_choice(choice_param, cancel_index)
  end
end
end