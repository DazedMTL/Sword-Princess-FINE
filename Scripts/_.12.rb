#------------------------------------------------------------------------------
#  アイテム別最大所持数設定
#    バージョン：1.0
#    RGSS3 (RPGツクールVX ACE)
#    作成者：project j
#    配布元：http://jsgamesfactory.web.fc2.com/
#
#  使い方：アイテム（武器防具含）のメモ欄に <最大所持 数値> を記述
#      例： <最大所持 10>
#          記述したアイテムのみ最大所持数が変更されます
#          100個以上も設定出来ますが他に影響があるかもしれません。
#------------------------------------------------------------------------------

#==============================================================================
# ■ Game_Party
#------------------------------------------------------------------------------
# 　パーティを扱うクラスです。所持金やアイテムなどの情報が含まれます。このクラ
# スのインスタンスは $game_party で参照されます。
#==============================================================================
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # ● アイテムの最大所持数取得
  #--------------------------------------------------------------------------
  alias jsscript_max_item_number max_item_number
  def max_item_number(item)
    item.note.dup.gsub!(/<(?:最大所持)[ ]*(\d+)>/i){ return $1.to_i }
    jsscript_max_item_number(item)
  end
end