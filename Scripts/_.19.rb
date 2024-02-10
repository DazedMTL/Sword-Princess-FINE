#******************************************************************************
#
#   ＊ シーン回想画面 ＊
#
#                       for RGSS3
#
#        Ver 1.02   2012.09.16
#
#   ◆注意事項
#     ※この素材は「共通セーブファイル」スクリプトが必要になります。
#     ※この素材は「ＣＧギャラリー」スクリプトが必要になります。
#     ※この素材はコンフィグ項目以外にＣＧリストの設定が必要になります。
#
#
#   ◆使い方
#     １．スクリプトで「Scene_SceneGallery.start」と指定する事で
#         シーン回想画面に移行します。
#
#     ２．このスクリプトはツクールのイベントと連動して機能します。
#         設定の詳細方法は下記ＵＲＬをご覧ください。
#         http://hime.be/rgss3/scene_gallery.html
#
#   提供者：睡工房　http://hime.be/
#
#******************************************************************************


#==============================================================================
# コンフィグ項目
#==============================================================================
module SUI
module GALLERY
  # シーン回想用変数(ゲーム内変数の番号を指定）
  # ここで指定した番号の変数にシーンIDが代入されます。
  SCENE_VAR = 107
end
end
#==============================================================================
# 設定完了
#==============================================================================



class Scene_SceneGallery < Scene_Base
  #--------------------------------------------------------------------------
  # ● クラス変数初期化
  #--------------------------------------------------------------------------
  @@start  = false         # ギャラリーの開始フラグ
  @@filter = 0             # ギャラリー復帰用
  @@index  = -1            # ギャラリー復帰用
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    RPG::BGM.fade(500)
    RPG::BGS.stop
    RPG::ME.stop
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    @@start = false
    @last = -1
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 145
    play_bgm
    create_background
    create_help_window
    create_filter_window
    create_main_window
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_background
    @viewport.dispose
    @viewport = nil
  end
  #--------------------------------------------------------------------------
  # ● ＢＧＭの再生
  #--------------------------------------------------------------------------
  def play_bgm
    RPG::BGM.new(SUI::GALLERY::CG_BGM).play
  end
  #--------------------------------------------------------------------------
  # ● 背景の作成
  #--------------------------------------------------------------------------
  def create_background
    @back = Sprite.new
    @back.bitmap = SceneManager.background_bitmap
    @back.color.set(16, 16, 16, 128)
  end
  #--------------------------------------------------------------------------
  # ● ヘルプウィンドウの作成
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_Help.new(1)
    @help_window.viewport = @viewport
    @help_window.width = 230
    @help_window.create_contents
    @help_window.draw_text(0, -2, @help_window.contents.width, @help_window.contents.height, "＊ Recollection ＊", 1)
  end
  #--------------------------------------------------------------------------
  # ● メインウィンドウの作成
  #--------------------------------------------------------------------------
  def create_main_window
    @main_window = Window_Gallery.new("cg_thumb", @viewport, true, @@filter)
    @main_window.index = @@index
    @main_window.opacity = (@@index == -1) ? 96 : 255
    @main_window.contents_opacity = (@@index == -1) ? 96 : 255
    @main_window.activate if @@index > -1
    @main_window.set_handler(:ok,     method(:main_ok))
    @main_window.set_handler(:cancel, method(:main_cancel))
  end
  #--------------------------------------------------------------------------
  # ● フィルタウィンドウの作成
  #--------------------------------------------------------------------------
  def create_filter_window
    @filter_window = Window_Filter.new(@viewport)
    @filter_window.set_handler(:ok,     method(:filter_ok))
    @filter_window.set_handler(:cancel, method(:filter_cancel))
    @filter_window.index = @@filter
    @filter_window.activate if @@index == -1
  end
  #--------------------------------------------------------------------------
  # ● 背景の解放
  #--------------------------------------------------------------------------
  def dispose_background
    @back.bitmap.dispose
    @back.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    update_filter_help if @filter_window.active
  end
  #--------------------------------------------------------------------------
  # ● フィルタのヘルプ更新
  #--------------------------------------------------------------------------
  def update_filter_help
    return if @last == @filter_window.index
    @last = @filter_window.index
    @main_window.create_list(@filter_window.index)
    @main_window.top_row = 0
    @main_window.refresh
    @main_window.help_window.set_text(SUI::GALLERY::CG_FILTER[@filter_window.index][1])
    @main_window.help_window.update
    @filter_window.check = (@main_window.item_max != 0)
  end
  #--------------------------------------------------------------------------
  # ● フィルタの決定処理
  #--------------------------------------------------------------------------
  def filter_ok
    @main_window.opacity = 255
    @main_window.contents_opacity = 255
    @main_window.activate
    @main_window.index = 0
    @@filter = @filter_window.index
  end
  #--------------------------------------------------------------------------
  # ● フィルタのキャンセル処理
  #--------------------------------------------------------------------------
  def filter_cancel
    $game_variables[SUI::GALLERY::SCENE_VAR] = 1000
    @@filter = 0
    @@index = -1
    SceneManager.return
    RPG::BGM.stop
    $game_map.autoplay
  end
  #--------------------------------------------------------------------------
  # ● ギャラリーの決定処理
  #--------------------------------------------------------------------------
  def main_ok
    $game_variables[SUI::GALLERY::SCENE_VAR] = @main_window.getId
    @@index = @main_window.index
    SceneManager.return
  end
  #--------------------------------------------------------------------------
  # ● ギャラリーのキャンセル処理
  #--------------------------------------------------------------------------
  def main_cancel
    @main_window.index = -1
    @main_window.opacity = 96
    @main_window.contents_opacity = 96
    @filter_window.activate
    @last = -1
  end
  #--------------------------------------------------------------------------
  # ● 回想ギャラリースタート処理
  #--------------------------------------------------------------------------
  def self.start
    @@start = true
  end
  #--------------------------------------------------------------------------
  # ● 回想ギャラリーが開始しているか？
  #--------------------------------------------------------------------------
  def self.start?
    return @@start
  end
  #--------------------------------------------------------------------------
  # ● リセット
  #--------------------------------------------------------------------------
  def self.reset
    @@start = false
    @@filter = 0
    @@index = -1
  end
end


class Scene_Map
  #--------------------------------------------------------------------------
  # ● 回想ギャラリーへの移行
  #--------------------------------------------------------------------------
  alias sui_update_scene2 update_scene
  def update_scene
    sui_update_scene2
    SceneManager.call(Scene_SceneGallery) if !scene_changing? && Scene_SceneGallery.start?
  end
end


class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  alias sui_scene_start start
  def start
    Scene_SceneGallery.reset
    sui_scene_start
  end
end