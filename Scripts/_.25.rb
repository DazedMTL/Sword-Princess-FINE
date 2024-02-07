#==============================================================================
# ■ RGSS3 歩数によるセルフスイッチ自動OFF Ver1.00　by 星潟
#------------------------------------------------------------------------------
# このスクリプトを導入することで
# 一定歩数歩く事で自動的に特定のセルフスイッチをOFFにする機能を
# 使用できるようになります。
# 
# 使用例 イベントコマンドのスクリプトで「ssnc("A", 50)」（鍵括弧なし）と記入。
#
# この場合はこのイベントコマンドを使用したイベントの
# セルフスイッチAがONになり、50歩歩く事でセルフスイッチがOFFになる。
#==============================================================================
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :steps_event_data1
  attr_accessor :steps_event_data2
  attr_accessor :steps_event_data3
  attr_accessor :steps_event_data4
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_step_event initialize
  def initialize
    initialize_step_event
    steps_event_setup
  end
  def steps_event_setup
    @steps_event_data1 = []
    @steps_event_data2 = []
    @steps_event_data3 = []
    @steps_event_data4 = []
  end
  #--------------------------------------------------------------------------
  # ● 歩数増加
  #--------------------------------------------------------------------------
  alias increase_steps_step_event increase_steps
  def increase_steps
    increase_steps_step_event
    step_number_decrease
  end
  def step_number_decrease
    steps_event_setup if @steps_event_data4 == nil
    return if @steps_event_data4.size == 0
    datax = []
    datay = []
    number = 0
    for i in @steps_event_data4
      if i <= 1
        datay.push(number)
      end
      datax.push(i - 1)
      number += 1
    end
    @steps_event_data4 = datax
    return if datay.size == 0
    datay = datay.reverse
    for i in datay
      $game_self_switches[[@steps_event_data1[i], @steps_event_data2[i], @steps_event_data3[i]]] = false
      $game_map.need_refresh = true if @steps_event_data1[i] == $game_map.map_id
      @steps_event_data1.delete_at(i)
      @steps_event_data2.delete_at(i)
      @steps_event_data3.delete_at(i)
      @steps_event_data4.delete_at(i)
    end
  end
end
class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● 歩数によるセルフスイッチ切り替え処理
  #--------------------------------------------------------------------------
  def ssnc(s_s_d, step_number)
    if @event_id > 0
      $game_party.steps_event_data1 = [] if $game_party.steps_event_data1 == nil
      $game_party.steps_event_data2 = [] if $game_party.steps_event_data2 == nil
      $game_party.steps_event_data3 = [] if $game_party.steps_event_data3 == nil
      $game_party.steps_event_data4 = [] if $game_party.steps_event_data4 == nil
      key = [@map_id, @event_id, s_s_d]
      $game_self_switches[key] = true
      $game_map.need_refresh = true
      $game_party.steps_event_data1.push(@map_id)
      $game_party.steps_event_data2.push(@event_id)
      $game_party.steps_event_data3.push(s_s_d)
      $game_party.steps_event_data4.push(step_number)
    end
  end
end