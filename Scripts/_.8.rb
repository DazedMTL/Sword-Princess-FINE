=begin #=======================================================================
  
◆◇セーブファイル顔表示Ver2 RGSS3◇◆

◆DEICIDE ALMA
◆レーネ　
◆http://blog.goo.ne.jp/exa_deicide_alma

★機能
セーブ画面を顔グラ表示にします
(ステートで顔グラ変更Ver2に対応)

◆注意
他のセーブ画面改造との併用は想定しておりません

◆導入箇所
▼素材のところ、mainより上

このスクリプトを導入する前のセーブデータは全て消去してください。
(あるだけでセーブ画面でエラーが出ます)

=end #=========================================================================
$renne_rgss3 = {} if $renne_rgss3.nil?
$renne_rgss3[:save_file_display_face] = true

class << DataManager
  #--------------------------------------------------------------------------
  # ● 定数(設定)
  #--------------------------------------------------------------------------
  SAVE_FILE_MAX_AAA = 16 # セーブデータの最大数
  SAVE_FILE_DIS_AAA = 3  # セーブデータの表示数
  #--------------------------------------------------------------------------
  # ● セーブファイルの最大数 ※再定義
  #--------------------------------------------------------------------------
  def savefile_max
    SAVE_FILE_MAX_AAA
  end
  #--------------------------------------------------------------------------
  # ● セーブファイルの表示数
  #--------------------------------------------------------------------------
  def savefile_dis
    SAVE_FILE_DIS_AAA
  end
end

class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # ● セーブファイル表示用のキャラクター画像情報 ※再定義
  #--------------------------------------------------------------------------
  def characters_for_savefile
    battle_members.collect{|actor| [actor.face_name, actor.face_index]}
  end
end

class Window_SaveFile < Window_Base
  #--------------------------------------------------------------------------
  # ● リフレッシュ ※再定義
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_party_characters(124, 0)
    change_color(normal_color)
    name = Vocab::File + " #{@file_index + 1}"
    draw_text(4, 0, 200, line_height, name)
    @name_width = text_size(name).width
    draw_playtime(8, contents.height - line_height, contents.width - 4, 0)
  end
  #--------------------------------------------------------------------------
  # ● パーティキャラの描画 ※再定義
  #--------------------------------------------------------------------------
  def draw_party_characters(x, y)
    header = DataManager.load_header(@file_index)
    return unless header
    header[:characters].each_with_index do |data, i|
      draw_face(*data, x + i * 98, y)
    end
  end
  #--------------------------------------------------------------------------
  # ● プレイ時間の描画 ※再定義(バグ修正)
  #--------------------------------------------------------------------------
  def draw_playtime(x, y, width, align)
    header = DataManager.load_header(@file_index)
    return unless header
    draw_text(x, y, width, line_height, header[:playtime_s], align)
  end
end

class Scene_File < Scene_MenuBase
  #--------------------------------------------------------------------------
  # ● 画面内に表示するセーブファイル数を取得 ※再定義
  #--------------------------------------------------------------------------
  def visible_max
    DataManager.savefile_dis
  end
end
