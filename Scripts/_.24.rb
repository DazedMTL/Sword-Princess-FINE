# coding: utf-8
#===============================================================================
# ■ ツクールDS+風 頭上アイテム表示さん for RGSS3
# ※このスクリプトはRGSS3（RPGツクールVXAce）専用です
#-------------------------------------------------------------------------------
#　2011/12/06　Ru/むっくRu　鳥小屋.txt
#-------------------------------------------------------------------------------
# RPGツクールDS+のアイテムアイコン頭上表示のような機能を追加します
#
# 【使い方】
# 　・イベントコマンドの「スクリプト」の中で以下の命令を行ってください
#
#     startItemDSP(MAPイベントのID, アイコンのID)
#
#     ● MAPイベントのID
# 　　　　イベント編集ウィンドウのタイトルバー部分にでるIDの値
# 　　　　主人公を指定する場合は-1，このイベントを指定する場合は0にしてください
#     ● アイコンのID
# 　　　　データベースのアイコン選択画面左下に出るIndex:の値
# 　　　　ただし，Index:0のアイコンは表示されません
#
# 　　例）
#     startItemDSP(-1, 1)
# 　　↑主人公の頭上に1番のアイコン（RTPだとドクロ）が表示される
#
# 　・消すときには「スクリプト」の中で以下の命令を行ってください
#
#     endItemDSP(MAPイベントのID)
#
# 　　例）
#     endItemDSP(-1)
# 　　↑主人公の頭上のアイコンが消える（もともと無い場合は何もおきない）
#
#-------------------------------------------------------------------------------
# 【問題点など】
# VXAce発売前なのでちゃんと動くかわからないし，
# ツクールDS+も出てないので，本当にDS+風なのかどうかもわからない
#-------------------------------------------------------------------------------

#==============================================================================
# ● 設定項目
#==============================================================================

module HZM_VXA
  module DSP_OHICON
    # 表示する高さ微調整
    D_HEIGHT = 2
  end
end

#==============================================================================
# ↑ 　 ここまで設定 　 ↑
# ↓ 以下、スクリプト部 ↓
#==============================================================================

# 定数
module HZM_VXA
  module DSP_OHICON
    # startItemDSP，endItemDSP命令を使用可能にする
    CAN_SHORT_COMMAND = true
  end
end

# アイコン表示用の変数を追加
class Game_CharacterBase
  attr_accessor :hzm_vxa_dsp_ohicon_id
  
  alias hzm_vxa_dsp_ohicon_init_public_members init_public_members
  def init_public_members
    hzm_vxa_dsp_ohicon_init_public_members
    @hzm_vxa_dsp_ohicon_id = 0
  end
end

# アイコン表示処理追加
class Sprite_Character < Sprite_Base
  alias hzm_vxa_dsp_ohicon_initialize initialize
  def initialize(viewport, character = nil)
    hzm_vxa_dsp_ohicon_initialize(viewport, character)
    @hzm_vxa_dsp_ohicon_icon_index = 0
  end
  
  alias hzm_vxa_dsp_ohicon_dispose dispose
  def dispose
    hzm_vxa_dsp_ohicon_end_ohicon
    hzm_vxa_dsp_ohicon_dispose
  end
  
  alias hzm_vxa_dsp_ohicon_update update
  def update
    hzm_vxa_dsp_ohicon_update
    hzm_vxa_dsp_ohicon_update_ohicon
  end
  
  alias hzm_vxa_dsp_ohicon_setup_new_effect setup_new_effect
  def setup_new_effect
    # デバッグ用
    #@character.hzm_vxa_dsp_ohicon_id = 0 unless @character.hzm_vxa_dsp_ohicon_id
    hzm_vxa_dsp_ohicon_setup_new_effect
    if @hzm_vxa_dsp_ohicon_sprite
      hzm_vxa_dsp_ohicon_end_ohicon   if @character.hzm_vxa_dsp_ohicon_id <= 0
    else
      hzm_vxa_dsp_ohicon_start_ohicon if @character.hzm_vxa_dsp_ohicon_id > 0
    end
  end
  
  HZM_VXA_DSP_OHICON_ICON_SIZE = 24
  def hzm_vxa_dsp_ohicon_start_ohicon
    @hzm_vxa_dsp_ohicon_icon_index = @character.hzm_vxa_dsp_ohicon_id
    @hzm_vxa_dsp_ohicon_sprite = Sprite.new(viewport)
    @hzm_vxa_dsp_ohicon_sprite.bitmap = Bitmap.new(HZM_VXA_DSP_OHICON_ICON_SIZE, HZM_VXA_DSP_OHICON_ICON_SIZE)
    bitmap = Cache.system("Iconset")
    rect = Rect.new(@hzm_vxa_dsp_ohicon_icon_index % 16 * HZM_VXA_DSP_OHICON_ICON_SIZE, @hzm_vxa_dsp_ohicon_icon_index / 16 * HZM_VXA_DSP_OHICON_ICON_SIZE, HZM_VXA_DSP_OHICON_ICON_SIZE, HZM_VXA_DSP_OHICON_ICON_SIZE)
    @hzm_vxa_dsp_ohicon_sprite.bitmap.blt(0, 0, bitmap, rect)
    @hzm_vxa_dsp_ohicon_sprite.ox = HZM_VXA_DSP_OHICON_ICON_SIZE / 2
    @hzm_vxa_dsp_ohicon_sprite.oy = HZM_VXA_DSP_OHICON_ICON_SIZE
    hzm_vxa_dsp_ohicon_update_ohicon
  end
  
  def hzm_vxa_dsp_ohicon_end_ohicon
    @character.hzm_vxa_dsp_ohicon_id = 0
    @hzm_vxa_dsp_ohicon_icon_index   = 0
    hzm_vxa_dsp_ohicon_dispose_ohicon
  end
  
  def hzm_vxa_dsp_ohicon_dispose_ohicon
    return unless @hzm_vxa_dsp_ohicon_sprite
    @hzm_vxa_dsp_ohicon_sprite.bitmap.dispose
    @hzm_vxa_dsp_ohicon_sprite.dispose
    @hzm_vxa_dsp_ohicon_sprite = nil
  end
  
  def hzm_vxa_dsp_ohicon_update_ohicon
    return unless @hzm_vxa_dsp_ohicon_sprite
    @hzm_vxa_dsp_ohicon_sprite.x = x
    @hzm_vxa_dsp_ohicon_sprite.y = y - height - HZM_VXA::DSP_OHICON::D_HEIGHT
    @hzm_vxa_dsp_ohicon_sprite.z = z + 190
  end
end

# コマンド追加
class Game_Interpreter
  def hzm_vxa_dsp_ohicon_start_item_over_head(id, icon_index)
    return unless character = get_character(id)
    character.hzm_vxa_dsp_ohicon_id = icon_index
  end
  
  # ショートカットコマンドの追加
  if HZM_VXA::DSP_OHICON::CAN_SHORT_COMMAND
    def startItemDSP(id, icon_index)
      begin
        hzm_vxa_dsp_ohicon_start_item_over_head(id, icon_index)
      rescue
        puts "startItemDSP(#{id}, #{icon_index})を実行中にエラーが発生しました"
        puts "#{$!} - #{$@}"
        puts "----------"
      end
    end
    def endItemDSP(id)
      begin
        hzm_vxa_dsp_ohicon_start_item_over_head(id, 0)
      rescue
        puts "endItemDSP(#{id})を実行中にエラーが発生しました"
        puts "#{$!} - #{$@}"
        puts "----------"
      end
    end
  end
end