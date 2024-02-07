=begin
RGSS3 新ネームプレート ver.1.00 2013/09/20　mo-to

ＴＫＯＯＬ　ＣＯＯＬ
http://mototkool.blog.fc2.com/

★概要★
セリフを表示させる際に、別ウィンドウで名前表示をさせることができる。
制御文字でウィンドウを制御できる。
ウィンドウ背景に同期する。

より使いやすく進化！　旧バージョンとはココが違う！
1.ゲーム変数不要！　制御文字で直接アクターを指定できるようになった！
2.ネームプレートがちょっとスリムに！
3.RGSS3　顔グラフィックでメッセージウィンドウスキン変更に対応(要Ver.1.02以上)

★使用法★
スクリプトの▼ 素材　以下  ▼ メイン　以上にこれをコピーして張り付ける。
イベント文章の表示でネームプレートを使用する際は、文章の表示で制御文字　\NP[n]　
または　\np[n] と入力してください。
※nにはアクターＩＤを入力。
※おまけ機能として\NP[0]と入力するとパーティの先頭者の名前をプレートに表示します。
例）\NP[1]文章　とした場合、デフォではエリックのネームプレートが表示され
文章が表示されます。

★注意★
新ネームプレートはネームプレートver.1.10の上位互換ではありません。
差し替えてアップデートなどは出来ませんので注意してください。
同時に使う事もできませんし、全くの別物とお考えください。

新ネームプレートと顔グラフィックでメッセージウィンドウスキン変更(要Ver.1.02以上)を
併用する場合は
RGSS3 新ネームプレート
RGSS3　顔グラフィックでメッセージウィンドウスキン変更　Ver.1.02以上
の順で導入してください。

Window_Message#fiber_mainを再定義していますので
そこを弄っているスクリプトとは競合します。

●＝再定義
○＝エイリアス定義
☆＝新規メソッド


module MOTO
#--------------------------------------------------------------------------
# ■　カスタマイズ　■
#-------------------------------------------------------------------------- 

  #ネームプレートの中下側初期位置(上側のNAME_PLATE_Yの値は逆になります)
  NAME_PLATE_X = 0 #値を+すると→へプレートを移動、－にすると←へ移動　0で初期位置
  NAME_PLATE_Y = -3 #値を+すると↓へプレートを移動、－にすると↑へ移動　0で初期位置
  
  #--------------------------------------------------------------------------
  # □ アドバンスドカスタマイズ□　(詳細設定)
  #--------------------------------------------------------------------------
  #ここから下は意味が分からなければ特に弄る必要はありません。
  
  #ネームプレートを表示させるための制御文字コードを設定します。
  #自分で入力しやすいものに変えるといいでしょう。
  #但し、すでに使用中のものとは被らない様にして下さい。
  #デフォでは'V','N','P','G','C','I'が使用中です。
  #制御文字コードは大文字のアルファベットのみ有効で何文字でも可能です。
  #(実際に使用する場合は小文字でも可)
  # '' でくぐるのを忘れないようにして下さい。
  NP_CODE = 'NP'
  
  #通常ではアクターの名前が8文字まで自動で縮小・中揃えしますが
  #それ以上の名前数を使う場合はみ出てしまいます。
  #その際はここでネームプレートウィンドウの幅を調整してください。
  NAME_PLATE_WIDTH = 128 #初期値128
  
  #ウィンドウの外枠と文字の間の幅です。小さくするとよりスリムになります。
  NAME_PLATE_PADDING = 8 #初期値8
  
#----------------------------------------------------------------------------
end

class Window_Name_Plate < Window_Base
  #--------------------------------------------------------------------------
  # ☆ オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, window_width, fitting_height(1))
    create_back_bitmap
    create_back_sprite
    @set_actor_name = nil
  end
  #--------------------------------------------------------------------------
  # ☆ ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
     return MOTO::NAME_PLATE_WIDTH
  end
  #--------------------------------------------------------------------------
  # ☆ 標準パディングサイズの取得
  #--------------------------------------------------------------------------
  def standard_padding
    return MOTO::NAME_PLATE_PADDING
  end    
  #--------------------------------------------------------------------------
  # ☆ 制御文字の引数からアクターの名前を取得
  #--------------------------------------------------------------------------
  def set_actor_name(text)
    @set_actor_name = actor_name(obtain_escape_param(text))
    refresh
  end
  #--------------------------------------------------------------------------
  # ☆ アクター n 番の名前を取得
  #--------------------------------------------------------------------------
  def actor_name(n)
    return actor = $game_party.members[0].name if n == 0
    super
  end  
  #--------------------------------------------------------------------------
  # ☆ リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_text(0, 0, window_width - 20, line_height, @set_actor_name, 1)
    name_plate_skin_change if $name_plate_option_enable #スキン変更有りの場合有効
  end  
  #--------------------------------------------------------------------------
  # ☆ 解放
  #--------------------------------------------------------------------------
  def dispose
    super
    dispose_back_bitmap
    dispose_back_sprite
  end
  #--------------------------------------------------------------------------
  # ☆ フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    update_back_sprite
  end
  #--------------------------------------------------------------------------
  # ☆ ネームプレートのスキン変更
  #--------------------------------------------------------------------------
  def name_plate_skin_change
    face_name = $game_message.face_name
    face_index = $game_message.face_index    
    if MOTO::MESS_SKIN[face_name].nil? || MOTO::MESS_SKIN[face_name][face_index].nil?
      self.windowskin = Cache.system(MOTO::DEFAULT_SKIN)
    else
      self.windowskin = Cache.system(MOTO::MESS_SKIN[face_name][face_index][0])
    end
  end      
  #--------------------------------------------------------------------------
  # ☆ 背景ビットマップの作成
  #--------------------------------------------------------------------------
  def create_back_bitmap
    @back_bitmap = Bitmap.new(width, height)
    rect1 = Rect.new(0, 0, width, 12)
    rect2 = Rect.new(0, 12, width, height - 24)
    rect3 = Rect.new(0, height - 12, width, 12)
    @back_bitmap.gradient_fill_rect(rect1, back_color2, back_color1, true)
    @back_bitmap.fill_rect(rect2, back_color1)
    @back_bitmap.gradient_fill_rect(rect3, back_color1, back_color2, true)
  end
  #--------------------------------------------------------------------------
  # ☆ 背景色 1 の取得
  #--------------------------------------------------------------------------
  def back_color1
    Color.new(0, 0, 0, 160)
  end
  #--------------------------------------------------------------------------
  # ☆ 背景色 2 の取得
  #--------------------------------------------------------------------------
  def back_color2
    Color.new(0, 0, 0, 0)
  end
  #--------------------------------------------------------------------------
  # ☆ 背景スプライトの作成
  #--------------------------------------------------------------------------
  def create_back_sprite
    @back_sprite = Sprite.new
    @back_sprite.bitmap = @back_bitmap
    @back_sprite.visible = false
    @back_sprite.z = z - 1
  end
  #--------------------------------------------------------------------------
  # ☆ 背景ビットマップの解放
  #--------------------------------------------------------------------------
  def dispose_back_bitmap
    @back_bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # ☆ 背景スプライトの解放
  #--------------------------------------------------------------------------
  def dispose_back_sprite
    @back_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # ☆ 背景スプライトの更新
  #--------------------------------------------------------------------------
  def update_back_sprite
    @back_sprite.visible = ($game_message.background == 1)
    @back_sprite.y = y
    @back_sprite.opacity = openness
    @back_sprite.update
  end
end

class Window_Message < Window_Base
  #--------------------------------------------------------------------------
  # ○ 全ウィンドウの作成
  #--------------------------------------------------------------------------
  alias name_plate_mt_create_all_windows create_all_windows
  def create_all_windows
    name_plate_mt_create_all_windows
    @name_plate_window = Window_Name_Plate.new
    @name_plate_window.x = 0 + MOTO::NAME_PLATE_X
    @name_plate_window.y = (Graphics.height - height) - @name_plate_window.height
    @name_plate_window.z = self.z + 1
    @name_plate_window.openness = 0
  end
  #--------------------------------------------------------------------------
  # ○ 全ウィンドウの解放
  #--------------------------------------------------------------------------
  alias name_plate_mt_dispose_all_windows dispose_all_windows
  def dispose_all_windows
    @name_plate_window.dispose
    name_plate_mt_dispose_all_windows
  end
  #--------------------------------------------------------------------------
  # ○ 全ウィンドウの更新
  #--------------------------------------------------------------------------
  alias name_plate_mt_update_all_windows update_all_windows
  def update_all_windows
    @name_plate_window.update
    name_plate_mt_update_all_windows
  end
  #--------------------------------------------------------------------------
  # ○ ウィンドウ背景の更新
  #--------------------------------------------------------------------------
  alias name_plate_mt_update_background update_background
  def update_background
    name_plate_mt_update_background
    @name_plate_window.opacity = @background == 0 ? 255 : 0
  end
  #--------------------------------------------------------------------------
  # ○ ウィンドウ位置の更新
  #--------------------------------------------------------------------------
  alias name_plate_mt_update_placement update_placement
  def update_placement
    name_plate_mt_update_placement
    case @position
    when 0
      @name_plate_window.y = window_height - MOTO::NAME_PLATE_Y
    when 1
      @name_plate_window.y = self.y - @name_plate_window.height + MOTO::NAME_PLATE_Y
    when 2
      @name_plate_window.y = (Graphics.height - window_height) - @name_plate_window.height + MOTO::NAME_PLATE_Y
    end
  end
  #--------------------------------------------------------------------------
  # ○ 制御文字の処理
  #     code : 制御文字の本体部分（「\C[1]」なら「C」）
  #     text : 描画処理中の文字列バッファ（必要なら破壊的に変更）
  #     pos  : 描画位置 {:x, :y, :new_x, :height}
  #--------------------------------------------------------------------------
  alias name_plate_mt_process_escape_character process_escape_character
  def process_escape_character(code, text, pos)
    case code.upcase
    when MOTO::NP_CODE
      @name_plate_window.set_actor_name(text)
      @name_plate_window.open  
    end
    name_plate_mt_process_escape_character(code, text, pos)
  end
  #--------------------------------------------------------------------------
  # ● ファイバーのメイン処理
  #--------------------------------------------------------------------------
  def fiber_main
    $game_message.visible = true
    update_background
    update_placement
    loop do
      process_all_text if $game_message.has_text?
      process_input
      $game_message.clear
      @gold_window.close 
      @name_plate_window.close #追加
      Fiber.yield
      break unless text_continue?
    end
    close_and_wait
    $game_message.visible = false
    @fiber = nil
  end
end
=end