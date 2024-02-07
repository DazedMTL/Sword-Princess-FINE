#******************************************************************************
#
#   ＊ ＣＧギャラリー画面 ＊
#
#                       for RGSS3
#
#        Ver 1.01   2012.09.16
#
#   ◆注意事項
#     ※この素材は「共通セーブファイル」スクリプトが必要になります。
#     ※この素材はコンフィグ項目以外にＣＧリストの設定が必要になります。
#
#
#   ◆使い方
#     １．スクリプトで「Scene_CgGallery.start」と記述する事で
#         ＣＧギャラリー画面に移行します。
#
#     ２．ＣＧリストの設定・フィルターの設定は下記ＵＲＬをご覧ください。
#         http://hime.be/rgss3/cg_gallery.html
#
#   提供者：睡工房　http://hime.be/
#
#******************************************************************************


#==============================================================================
# コンフィグ項目
#==============================================================================
module SUI
module GALLERY
  # CGフォルダ名
  #CG_DIR = "Graphics/Pictures/CG/"
  CG_DIR = "Graphics/Pictures/"
  
  # 再生BGM
  CG_BGM = ""
  
  # 全開放フラグ(共通セーブファイルのＩＤを指定）
  ALL_OPEN_MODE = "all_view"
  
  # フィルタの設定
  CG_FILTER = [
  #アイコン番号 , ヘルプに表示するテキスト
  [543        , "すべてのHシーンを表示します。"],        # すべてのＣＧを表示
  [555        , "ファインの着衣シーンを表示します。"],  # フィルター１
  [556        , "ファインの全裸シーンを表示します。"],  # フィルター２
  [557        , "NPCのHシーンを表示します。"],  # フィルター３
#  [547        , "全裸のシーンを表示します。"],  # フィルター４
  ]
end
end
#==============================================================================
# 設定完了
#==============================================================================



class Window_Gallery < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     map       : mapファイル名
  #     viewport  : viewport
  #     scene_flg : シーン回想か？
  #--------------------------------------------------------------------------
  def initialize(map, viewport, scene_flg = false, filter = 0)
    # サイズは画面サイズ － ヘルプウィンドウ２個分
    @list = []
    super(0, fitting_height(1), Graphics.width, Graphics.height - fitting_height(1) * 2)
    self.viewport = viewport
    @map = map
    @scene_flg = scene_flg
    create_list(filter)
    @offset = (Graphics.width == 544) ? 5 : 0;
    refresh
    create_title_window
  end
  #--------------------------------------------------------------------------
  # ● 桁数の取得
  #--------------------------------------------------------------------------
  def col_max
    (Graphics.width == 544) ? 4 : 5
  end
  #--------------------------------------------------------------------------
  # ● 項目数の取得
  #--------------------------------------------------------------------------
  def item_max
    @list.size
  end
  #--------------------------------------------------------------------------
  # ● 項目の幅を取得
  #--------------------------------------------------------------------------
  def item_width
    120
  end
  #--------------------------------------------------------------------------
  # ● 項目の高さを取得
  #--------------------------------------------------------------------------
  def item_height
    90
  end
  #--------------------------------------------------------------------------
  # ● 横に項目が並ぶときの空白の幅を取得
  #--------------------------------------------------------------------------
  def spacing
    5
  end
  #--------------------------------------------------------------------------
  # ● フィルタ適用後のリスト作成
  #--------------------------------------------------------------------------
  def create_list(filter)
    @list.clear unless @list == nil
    @list = [] if @list == nil
    for i in 0...SUI::CG_LIST.size
      if (@scene_flg == false or SUI::CG_LIST[i][4] == 1)
        if filter == 0 or filter == SUI::CG_LIST[i][3]
          @list << SUI::CG_LIST[i]
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 閲覧可否確認
  #--------------------------------------------------------------------------
  def check?
    ($savec.check(@list[@index][1] + "_01") or $savec.check(SUI::GALLERY::ALL_OPEN_MODE))
  end
  #--------------------------------------------------------------------------
  # ● ファイル名取得
  #--------------------------------------------------------------------------
  def getFilename
    @list[@index][1]
  end
  #--------------------------------------------------------------------------
  # ● シーンIDの取得 ＝ ゲーム変数に入れる値
  #--------------------------------------------------------------------------
  def getId
    @list[@index][2]
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.create_contents
    icons = Cache.load_bitmap(SUI::GALLERY::CG_DIR, @map)
    for i in 0...@list.size
      col = i % col_max
      row = i / col_max
      x = col * item_width + 13 + (@offset * (col + 1))
      y = row * item_height + 7
      if ($savec.check(@list[i][1] + "_01") or $savec.check(SUI::GALLERY::ALL_OPEN_MODE))
        rect = Rect.new(@list[i][2] % 10 * 100, @list[i][2] / 10 * 75, 100, 75)
        contents.blt(x, y, icons, rect)
      else
        contents.blt(x, y, icons, Rect.new(0, 0, 100, 75))
      end
    end
    if @list.size == 0
      rect = Rect.new
      rect.y = contents.height / 2 - 32 / 2
      rect.width = contents.width
      rect.height = 32
      contents.font.size = 32
      contents.draw_text(rect, "回想シーンが登録されていません。", 1)
    end
    @last = -1
  end
  #--------------------------------------------------------------------------
  # ● 項目を描画する矩形の取得
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new(0, 0, 0, 0)
    rect.width = item_width
    rect.height = item_height
    rect.x = index % col_max * item_width + 3 + (@offset * (index % col_max + 1))
    rect.y = index / col_max * item_height
    rect
  end
  #--------------------------------------------------------------------------
  # ● 先頭の行の取得
  #--------------------------------------------------------------------------
  def top_row
    oy / item_height
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ内容の作成
  #--------------------------------------------------------------------------
  def create_contents
    self.contents.dispose
    self.contents = Bitmap.new(width - padding * 2, [height - padding * 2, row_max * item_height].max)
  end
  #--------------------------------------------------------------------------
  # ● 決定ボタンが押されたときの処理
  #--------------------------------------------------------------------------
  def process_ok
    if check?
      Audio.se_play("Audio/SE/Book1", 75, 100)
      Input.update
      deactivate
      call_ok_handler
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # ● タイトルウィンドウの作成
  #--------------------------------------------------------------------------
  def create_title_window
    @help_window = Window_Help.new(1)
    @help_window.viewport = viewport
    @help_window.y = y + height
  end
  #--------------------------------------------------------------------------
  # ● ヘルプウィンドウの更新
  #--------------------------------------------------------------------------
  def update_help
    return if index == -1
    return if @last == @index
    @last = @index
    @help_window.set_text(@list[@index][0])
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    @help_window.dispose
    super
  end
end


class Window_Filter < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(viewport)
    @list = SUI::GALLERY::CG_FILTER
    super(250, 0, Graphics.width - 250, fitting_height(1))
    self.viewport = viewport
    @index = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    self.contents.draw_text(10, -2, 100, 24, "衣装選択")
    @list.size.times {|i| draw_text_ex(item_rect(i).x + 2, item_rect(i).y, "\\I[#{@list[i][0]}]") }
  end
  #--------------------------------------------------------------------------
  # ● 桁数の取得
  #--------------------------------------------------------------------------
  def col_max
    @list.size
  end
  #--------------------------------------------------------------------------
  # ● 項目数の取得
  #--------------------------------------------------------------------------
  def item_max
    @list.size
  end
  #--------------------------------------------------------------------------
  # ● 横に項目が並ぶときの空白の幅を取得
  #--------------------------------------------------------------------------
  def spacing
    4
  end
  #--------------------------------------------------------------------------
  # ● 項目の幅を取得
  #--------------------------------------------------------------------------
  def item_width
    28
  end
  #--------------------------------------------------------------------------
  # ● 項目を描画する矩形の取得
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height
    rect.x = index % col_max * (item_width + spacing) + 100
    rect.y = index / col_max * item_height
    rect
  end
  #--------------------------------------------------------------------------
  # ● 閲覧要素があるか設定
  #--------------------------------------------------------------------------
  def check=(flg)
    @check = flg
  end
  #--------------------------------------------------------------------------
  # ● 閲覧要素があるか取得
  #--------------------------------------------------------------------------
  def check?
    @check
  end
  #--------------------------------------------------------------------------
  # ● 決定ボタンが押されたときの処理
  #--------------------------------------------------------------------------
  def process_ok
    if check?
      Sound.play_ok
      Input.update
      deactivate
      call_ok_handler
    else
      Sound.play_buzzer
    end
  end
end


class Scene_CgGallery < Scene_Base
  #--------------------------------------------------------------------------
  # ● クラス変数初期化
  #--------------------------------------------------------------------------
  @@start = false         # ギャラリーの開始フラグ
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
    @viewport.z = 150
    play_bgm
    create_background
    create_help_window
    create_main_window
    create_filter_window
    create_cg_window
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_background
    dispose_cg_window
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
    @help_window.draw_text(0, -2, @help_window.contents.width, @help_window.contents.height, "＊ ＣＧギャラリー ＊", 1)
  end
  #--------------------------------------------------------------------------
  # ● ＣＧウィンドウの作成
  #--------------------------------------------------------------------------
  def create_cg_window
    @cg_window = Sprite.new
    @cg_window.bitmap = Bitmap.new(32, 32)
    @cg_window.x = 0
    @cg_window.y = 0
    @cg_window.z = @viewport.z + 1
    @cg_window.visible = false
  end
  #--------------------------------------------------------------------------
  # ● ＣＧウィンドウの解放
  #--------------------------------------------------------------------------
  def dispose_cg_window
    @cg_window.bitmap.dispose
    @cg_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● メインウィンドウの作成
  #--------------------------------------------------------------------------
  def create_main_window
    @main_window = Window_Gallery.new("cg_thumb", @viewport)
    @main_window.opacity = 96
    @main_window.contents_opacity = 96
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
    @filter_window.activate
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
    update_cg_selection unless @viewport.visible
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
  end
  #--------------------------------------------------------------------------
  # ● フィルタのキャンセル処理
  #--------------------------------------------------------------------------
  def filter_cancel
    SceneManager.return
    RPG::BGM.stop
    $game_map.autoplay
  end
  #--------------------------------------------------------------------------
  # ● ギャラリーの決定処理
  #--------------------------------------------------------------------------
  def main_ok
    @cg = @main_window.getFilename
    @cg_index = 0
    @viewport.visible = false
    next_show
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
  # ● ＣＧ選択の更新
  #--------------------------------------------------------------------------
  def update_cg_selection
    if Input.trigger?(:B)
      Sound.play_cancel
      @main_window.activate
      @cg_window.visible = false
      @viewport.visible = true
    elsif Input.trigger?(:C)
      if next_show
        Audio.se_play("Audio/SE/Book1", 75, 100)
      else
        Sound.play_cancel
        @main_window.activate
        @cg_window.visible = false
        @viewport.visible = true
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 次のＣＧの表示
  #--------------------------------------------------------------------------
  def next_show
    @cg_index += 1
    begin
      @cg_window.bitmap.dispose unless @cg_window.bitmap.disposed?
      @cg_window.bitmap = Bitmap.new(SUI::GALLERY::CG_DIR + @cg + "_" + sprintf("%02d", @cg_index))
    rescue
      return false
    end
    return @cg_window.visible = true
  end
  #--------------------------------------------------------------------------
  # ● ＣＧギャラリースタート処理
  #--------------------------------------------------------------------------
  def self.start
    @@start = true
  end
  #--------------------------------------------------------------------------
  # ● ＣＧギャラリーが開始しているか？
  #--------------------------------------------------------------------------
  def self.start?
    return @@start
  end
end


class Scene_Map
  #--------------------------------------------------------------------------
  # ● ＣＧギャラリーへの移行
  #--------------------------------------------------------------------------
  alias sui_update_scene update_scene
  def update_scene
    sui_update_scene
    SceneManager.call(Scene_CgGallery) if !scene_changing? && Scene_CgGallery.start?
  end
end