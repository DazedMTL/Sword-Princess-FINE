#==============================================================================
# ■ RGSS3 レベルアップ時SE Ver1.00　by 星潟
#------------------------------------------------------------------------------
# レベルアップ時にSEを鳴らします。
# 戦闘勝利時限定化機能もあります。
#==============================================================================
module LVUPSE
  
  #SE設定（最初がSEファイル名、次が音量、最後がピッチ）
  
  SE = ['Recovery', 90, 100]
  
  #戦闘終了時以外レベルアップSEを禁止するか否か（true 禁止 false 禁止しない）
  
  BO = false
  
end
class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # ● レベルアップ
  #--------------------------------------------------------------------------
  alias level_up_se level_up
  def level_up
    level_up_se
    return if $battle_end1 != nil
    return if $battle_end2 == nil && LVUPSE::BO == true
    lvupse = LVUPSE::SE
    Audio.se_play('Audio/SE/' + lvupse[0], lvupse[1].to_i, lvupse[2].to_i)
  end
end

class << BattleManager
  alias gain_exp_se gain_exp
  def gain_exp
    $battle_end2 = true
    gain_exp_se
    $battle_end2 = nil
  end
end
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # ● 戦闘テスト用パーティのセットアップ
  #--------------------------------------------------------------------------
  alias setup_battle_test_members_se setup_battle_test_members
  def setup_battle_test_members
    $battle_end1 = true
    setup_battle_test_members_se
    $battle_end1 = nil
  end
end