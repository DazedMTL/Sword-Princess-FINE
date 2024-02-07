#==============================================================================
# ■ RGSS3 クロスフェード場所移動 Ver1.00　by 星潟
#------------------------------------------------------------------------------
# マップ移動時、フェード無しに設定されており、なおかつ
# 特定のスイッチがONの場合に現在のマップと移動後のマップを
# クロスフェードさせる形で表示します。
# （現在マップがフェードアウトされ、移動後のマップがフェードインします）
#==============================================================================
module X_F_TRANSFER
  
  #クロスフェードを有効にするスイッチを指定します。
  #0にした場合は、スイッチに関わらずクロスフェードとなります。
  
  SWITCH = 50
  
  #クロスフェードのウェイトを設定します。
  #1以上の値を設定して下さい。
  
  WAIT   = 30
  
end
class Scene_Map < Scene_Base
  attr_accessor :lm_bitmap
  attr_accessor :lm_sprite
  #--------------------------------------------------------------------------
  # クロスフェードを有効にするスイッチの状態を確認
  #--------------------------------------------------------------------------
  def x_fade_switch
    
    #スイッチIDが0の場合は無条件にtrueを返し
    #そうでない場合は、スイッチの状態を返す。
    
    X_F_TRANSFER::SWITCH == 0 ? true : $game_switches[X_F_TRANSFER::SWITCH]
  end
  #--------------------------------------------------------------------------
  # クロスフェードの可否
  #--------------------------------------------------------------------------
  def x_fade_flag
    
    #クロスフェードを有効にするスイッチの状態と
    #フェード設定がなしになっているか否かで可否を判定。
    
    x_fade_switch && $game_temp.fade_type == 2
  end
  #--------------------------------------------------------------------------
  # 場所移動前の処理
  #--------------------------------------------------------------------------
  alias pre_transfer_x_fade pre_transfer
  def pre_transfer
    
    #クロスフェードを行う場合は分岐。
    
    if x_fade_flag
      
      #現在マップのスナップショットを作成。
      
      @lm_bitmap = Graphics.snap_to_bitmap
      
      #画面表示用のスプライトを作成。
      
      @lm_sprite = Sprite.new
      
      #スプライトのビットマップを指定。
      
      @lm_sprite.bitmap = @lm_bitmap
      
    end
    
    #本来の処理を実行。
    
    pre_transfer_x_fade
  end
  #--------------------------------------------------------------------------
  # 場所移動後の処理
  #--------------------------------------------------------------------------
  alias post_transfer_x_fade post_transfer
   def post_transfer
     
    #クロスフェードを行う場合は分岐。
     
    if x_fade_flag
      
      #ループ処理を行う。
      
      loop do
        
        #フェード用の更新を実行。
        
        update_for_fade
        
        #スプライトの不透明度をウェイトに応じて減少させる。
        
        @lm_sprite.opacity -= [255.0 / X_F_TRANSFER::WAIT, 1].max
        
        #スプライトの不透明度が0以下となった場合はループを中断する。
        
        break if @lm_sprite.opacity <= 0
        
      end
      
      #ビットマップとスプライトをnilにする。
      
      @lm_sprite.dispose
      @lm_sprite = nil
      @lm_bitmap.dispose
      @lm_bitmap = nil
      
    end
    
    #本来の処理を実行。
    
    post_transfer_x_fade
    
  end
end