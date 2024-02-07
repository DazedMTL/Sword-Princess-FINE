#==============================================================================
# ■ RGSS3 レギュラー変数ウィンドウ Ver1.01 by 星潟
#------------------------------------------------------------------------------
# 特定変数をマップ及び戦闘中に表示し続けるウィンドウを作成します。
# ウィンドウのフォントサイズ、幅、高さはもちろん
# スイッチによるウィンドウの表示可否や、各変数項目の表示可否も設定できます。
#------------------------------------------------------------------------------
# Ver1.01 各部への説明を追加。
#         項目内に:afterwordを追加。
#         項目ハッシュ内の:icon_id、:name、:afterwordが
#         省略されていても機能するように仕様を変更。
#==============================================================================
module W_REGULAR
  
  #マップ上でレギュラー変数ウィンドウを表示するか否かを設定します。
  #true => 使用する/false => 使用しない
  
  M_USE  = true
  
  #マップでのウィンドウ表示許可スイッチを設定します。
  
  M_SID  = 104
  
  #マップでのウィンドウのX座標を指定します。
  
  M_W_X   = 87
  
  #マップでのウィンドウのY座標を指定します。
  
  M_W_Y   = 370
  
  #戦闘でレギュラー変数ウィンドウを表示するか否かを設定します。
  #true => 使用する/false => 使用しない
  
  B_USE  = false
  
  #戦闘でのウィンドウ表示許可スイッチを設定します。
  
  B_SID  = 100
  
  #戦闘でのウィンドウのX座標を指定します。
  
  B_W_X   = 400
  
  #戦闘でのウィンドウのY座標を指定します。
  
  B_W_Y   = 200
  
  #ウィンドウ内に記述される文字のフォントサイズを指定します。
  
  FSIZE  = 24
  
  #ウィンドウの幅を設定します。
  
  WIDTH  = 370
  
  #ウィンドウの高さを設定します。
  
  HEIGHT = 46
  
  #ウィンドウ内の項目を設定します。
  #各項目の最後は必ず「,」（鍵括弧は除く）で区切って下さい。
  #配列内のハッシュを追加/削除/設定する事で
  #ウィンドウ内の項目の編集が可能です。
  
  #それぞれの項目は
  #{:icon_id => 1（項目のアイコンID。0を指定するか省略すると
  #                アイコンを描写せず、そのまま項目名を描写する）
  # :name => "項目の名前"（必ず""で囲む。""を指定するか省略すると描写しない）,
  # :afterword => 1（後付けで表示する変数の値の単位。
  #                  ""を指定するか省略すると描写しない）,
  # :variable_id => 1（表示する変数のID）,
  # :switch_id => 1（表示許可を示すスイッチID）,
  # :x => 0（ウィンドウ内のx座標）,
  # :y => 0（ウィンドウ内のy座標）,
  # :width => 65（ウィンドウ内での表示幅）,
  # :name_c => 16（項目の名前を描写する際の文字色）
  #}
  #これで1セットとなっています。
  #データ更新の際は、x座標とy座標、そして表示幅とフォントサイズを元に
  #その領域を消去する仕様になっており、処理は比較的軽めに抑えてありますが
  #複数項目で領域をかぶせた場合、片方の更新の際に
  #もう片方の表示の一部が消えてしまう可能性がありますので
  #表示領域を被せないように微調整してやって下さい。
  
  ITEM  = [
  {:icon_id => 122,:name => "HP:",:afterword => "",:variable_id =>101,:switch_id =>101,:x => 5,:y => 0,:width => 130,:name_c => 6},
  {:icon_id => 361,:name => "GOLD:",:afterword => "",:variable_id => 102,:switch_id => 102,:x => 170,:y => 0,:width => 170,:name_c => 17}
#  {:icon_id => 125,:afterword => " 個",:variable_id => 3,:switch_id => 1,:x => 0,:y => 48,:width => 120,:name_c => 16}
  ]
  
end
class Scene_Base
  #--------------------------------------------------------------------------
  # レギュラーウィンドウを設定
  #--------------------------------------------------------------------------
  def create_regular_window
    @regular_window = Window_Regular.new
  end
end
class Window_Regular < Window_Base
  #--------------------------------------------------------------------------
  # 初期化
  #--------------------------------------------------------------------------
  def initialize
    
    #設定データからウィンドウを生成。
    
    super(x, y, width, height)
    
    #設定データからフォントサイズを指定。
    
    self.contents.font.size = W_REGULAR::FSIZE
    
    #全ての項目を記述。
    
    draw_all_item
    
    #可視フラグから可視状態を変更。
    
    self.visible = visible_flag
  end
  #--------------------------------------------------------------------------
  # ウィンドウのX座標を指定
  #--------------------------------------------------------------------------
  def x
    
    #マップか戦闘中かでX座標を変更。
    #どちらでもない場合はとりあえず0を返す。
    
    return W_REGULAR::M_W_X if SceneManager.scene_is?(Scene_Map)
    return W_REGULAR::B_W_X if SceneManager.scene_is?(Scene_Battle)
    0
  end
  #--------------------------------------------------------------------------
  # ウィンドウのY座標を指定
  #--------------------------------------------------------------------------
  def y
    
    #マップか戦闘中かでY座標を変更。
    #どちらでもない場合はとりあえず0を返す。
    
    return W_REGULAR::M_W_Y if SceneManager.scene_is?(Scene_Map)
    return W_REGULAR::B_W_Y if SceneManager.scene_is?(Scene_Battle)
    0
  end
  #--------------------------------------------------------------------------
  # 可視フラグを取得
  #--------------------------------------------------------------------------
  def visible_flag
    
    #マップか戦闘中かで可視フラグ判定用スイッチを変更。
    #どちらでもない場合はとりあえずfalseを返す。
    
    return $game_switches[W_REGULAR::M_SID] if SceneManager.scene_is?(Scene_Map)
    return $game_switches[W_REGULAR::B_SID] if SceneManager.scene_is?(Scene_Battle)
    false
  end
  #--------------------------------------------------------------------------
  # ウィンドウの幅を指定
  #--------------------------------------------------------------------------
  def width
    
    #設定データから幅を取得。
    
    W_REGULAR::WIDTH
    
  end
  #--------------------------------------------------------------------------
  # ウィンドウの高さを指定
  #--------------------------------------------------------------------------
  def height
    
    #設定データから高さを取得。
    
    W_REGULAR::HEIGHT
  end
  #--------------------------------------------------------------------------
  # 全ての項目を描写
  #--------------------------------------------------------------------------
  def draw_all_item
    
    #全項目のデータ取得用配列を生成。
    
    @item_variables = []
    
    #項目別のデータを取得し、個別リフレッシュを実行。
    
    W_REGULAR::ITEM.each_with_index { |item, i_data|
    rect = Rect.new(item[:x], item[:y], item[:width], W_REGULAR::FSIZE)
    s_id = W_REGULAR::ITEM[i_data][:switch_id]
    v_id = W_REGULAR::ITEM[i_data][:variable_id]
    @item_variables.push([$game_switches[s_id], $game_variables[v_id],[rect]])
    part_refresh(i_data, true)
    }
  end
  #--------------------------------------------------------------------------
  # 更新
  #--------------------------------------------------------------------------
  def update
    
    #スーパークラスの処理を実行。
    
    super
    
    #現在の可視状態が可視フラグと異なる時
    #全項目を再描写した上で処理を中断する。
    
    if self.visible != visible_flag
      self.visible = visible_flag
      return draw_all_item
    end
    
    #各項目を個別リフレッシュする。
    
    @item_variables.each_index {|i_data|
    part_refresh(i_data)
    }
  end
  #--------------------------------------------------------------------------
  # 各項目のリフレッシュ
  #--------------------------------------------------------------------------
  def part_refresh(i_data, first = false)
    
    #スイッチID、変数IDを取得
    
    s_id = W_REGULAR::ITEM[i_data][:switch_id]
    v_id = W_REGULAR::ITEM[i_data][:variable_id]
    
    #初回描写ではなく、表示フラグに変更がなく、変数の変更もない場合は
    #リフレッシュを行わない。
    
    return if !first && $game_switches[s_id] == @item_variables[i_data][0] && $game_variables[v_id] == @item_variables[i_data][1]
    
    #項目描写範囲の矩形を取得。
    
    rect = @item_variables[i_data][2][0]
    
    #項目描写範囲内の既存の描写を消去する。
    
    self.contents.clear_rect(rect)
    
    #表示フラグがOFFの場合、処理を中断する。
    
    return if !$game_switches[s_id]
    
    #項目データを最新のデータに変更する。
    
    @item_variables[i_data] = [$game_switches[s_id], $game_variables[v_id],[rect]]
    
    #アイコンID設定がされており、なおかつIDが0でない場合は
    #アイコンを描写する。
    
    if W_REGULAR::ITEM[i_data][:icon_id] != nil && W_REGULAR::ITEM[i_data][:icon_id] != 0
      draw_icon(W_REGULAR::ITEM[i_data][:icon_id], rect.x, rect.y)
      
      #矩形を複製する。
      
      rect2 = rect.clone
      
      #項目名が設定されており、なおかつ設定内容が空でない場合は項目名を描写する。
      
      if W_REGULAR::ITEM[i_data][:name] != nil && W_REGULAR::ITEM[i_data][:name] != ""
        
        #複製した矩形のx座標をアイコン分ずらす。
        
        rect2.x += 24
        
        #変更を行った矩形情報を用いて
        #指定色で項目名を描写する。
        
        self.contents.font.color = text_color(W_REGULAR::ITEM[i_data][:name_c])
        draw_text(rect2, W_REGULAR::ITEM[i_data][:name], 0)
      end
    else
      
      #項目名が設定されており、なおかつ設定内容が空でない場合は項目名を描写する。
      
      if W_REGULAR::ITEM[i_data][:name] != nil && W_REGULAR::ITEM[i_data][:name] != ""
        
        #指定色で項目名を描写する。
        
        self.contents.font.color = text_color(W_REGULAR::ITEM[i_data][:name_c])
        draw_text(rect, W_REGULAR::ITEM[i_data][:name], 0)
        
      end
    end
    
    #文字描写色を元に戻す。
    
    self.contents.font.color = normal_color
    
    #描写する変数の値を文字列として取得。
    
    text = $game_variables[v_id].to_s
    
    #単位が設定されており、なおかつ空でない場合は
    #変数の文字列の後に単位の文字列を加える。
    
    if W_REGULAR::ITEM[i_data][:afterword] != nil && W_REGULAR::ITEM[i_data][:afterword] != ""
      text = text + W_REGULAR::ITEM[i_data][:afterword]
    end
    
    #矩形情報を元に文字列を描写する。
    
    draw_text(rect, text, 2)
    
  end
end
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # 全ウィンドウの作成
  #--------------------------------------------------------------------------
  alias create_all_windows_rw create_all_windows
  def create_all_windows
    
    #本来の処理を実行する。
    
    create_all_windows_rw
    
    #レギュラー変数ウィンドウをマップで使用する設定の場合は作成する。
    
    create_regular_window if W_REGULAR::M_USE
  end
end
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # 全ウィンドウの作成
  #--------------------------------------------------------------------------
  alias create_all_windows_rw create_all_windows
  def create_all_windows
    
    #本来の処理を実行する。
    
    create_all_windows_rw
    
    #レギュラー変数ウィンドウを戦闘で使用する設定の場合は作成する。
    
    create_regular_window if W_REGULAR::B_USE
  end
end