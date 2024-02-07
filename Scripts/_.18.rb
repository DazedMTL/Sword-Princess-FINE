=begin
           メッセージウィンドウ表示/非表示
  機能
  Qボタンを押すと、メッセージウィンドウを表示/非表示
  
  再定義箇所
  Window_Message

=end
#==============================================================================
# ■ Window_Message
#------------------------------------------------------------------------------
# 　文章表示に使うメッセージウィンドウです。
#==============================================================================

class Window_Message < Window_Base
  
  def input_pause
    self.pause = true
    wait(10)
    Fiber.yield until Input.trigger?(:C)
    show if self.visible == false
    Input.update
    self.pause = false
  end
  
  def update_window_hide
    unless $game_party.in_battle
      if Input.trigger?(:L)
        if self.visible == true
          hide
        if @background == 1
          @background = 0
          @black_window = 2
         end
        else
          show
        if @black_window == 2
          @background = 1
          @black_window = 0
         end
        end
      end
    end
    update_window_show
  end
  alias :update_window_show :update
  alias :update :update_window_hide
end