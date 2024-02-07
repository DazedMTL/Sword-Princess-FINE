#==============================================================================
# ■ RGSS3 プレイヤー追加追従アクター Ver1.02 by 星潟
#------------------------------------------------------------------------------
# 先頭もしくは最後尾のアクターに追従する
# パーティメンバー以外のアクターを設定できます。
# この追加追従アクターはパーティメンバーに含まれません。
#
# 仕様上、馬車等の表現に適しています。
#==============================================================================
# 追加追従設定用の変数ID指定配列で指定された変数の値が0でない場合
# その値のIDのアクターのグラフィックを追加追従させます。
# ゲーム開始時は追加追従が無効となっているので
# 状況に応じて追加追従を有効にして下さい。
#==============================================================================
# イベントコマンドのスクリプトで以下のようにする事で
# その場で画像が更新されます。
#------------------------------------------------------------------------------
# 追加追従を有効にする場合
# 
# $game_temp.ef_type = true
#------------------------------------------------------------------------------
# 追加追従を無効にする場合
# 
# $game_temp.ef_type = false
#==============================================================================
# Ver1.01 見栄えが悪かったので一部機能を削除しました。
#         説明文が全く足りていなかったので大幅に追記しました。
#
# Ver1.02 パーティ最後尾に追加追従を切り替える機能を追加しました。
#         なお、最後尾に追加追従させる場合、メンバーの入れ替え等により
#         戦闘メンバー数が増減した際に表示が重なってしまいます。
#         この現象を回避する場合は、追加追従中のメンバーの入れ替えの直後に
#         イベントコマンドのスクリプトで追加追従を改めて有効にすることで
#         追加追従のデータが整理され、正しい表示に戻ります。
#==============================================================================
module EXTEND_FOLLOWERS
  
  #追加追従設定用の変数ID指定配列を設定します。
  #ここで指定された変数IDにアクターIDを代入する事で
  #そのアクターの歩行グラフィックを先頭アクターに追従させます。
  
  EFV = [108]
  
  #追加追従形式の切り替え用スイッチを設定します。
  
  #このスイッチがONの時に追加追従を有効にすると
  #追加追従アクターは先頭メンバーではなく
  #パーティ最後尾のアクターに追従します。
  #このスイッチがOFFの時に追加追従を有効にすると
  #追加追従アクターは先頭メンバーに追従します。
  
  SWITCH = 114
  
end
class Game_Temp
  attr_accessor :ef_type
  attr_accessor :character_refresh
end
class Game_Followers
  #--------------------------------------------------------------------------
  # フレーム更新
  #--------------------------------------------------------------------------
  alias update_extend_followers update
  def update
    
    #追従者の再構築フラグが有効な場合追従者の再構築を実行。
    
    followers_remake($game_temp.ef_type) if $game_temp.ef_type != nil
    
    #本来の処理を実行する。
    
    update_extend_followers
  end
  #--------------------------------------------------------------------------
  # 追従者の再構築
  #--------------------------------------------------------------------------
  def followers_remake(type)
    
    #配列を空にする。
    
    @data = []
    
    #リーダーをプレイヤーに指定。
    
    leader = $game_player
    
    #プレイヤーのすぐ後ろの追加追従を有効にする場合は追加する。
    
    if type && !$game_switches[EXTEND_FOLLOWERS::SWITCH]
      
      #追加追従の変数配列データから、アクターIDが指定されている物を選択し
      #配列にデータを追加していく。
      
      EXTEND_FOLLOWERS::EFV.each_with_index {|efv, i|
      next if $game_variables[EXTEND_FOLLOWERS::EFV[i]] == 0
      i == 0 ? @data.push(Game_Follower.new(-(i + 1), leader)) : @data.push(Game_Follower.new(-(i + 1), @data[-1]))
      }
    end
    
    #配列内にデータが存在しない場合、最初のアクターはリーダーを追従対象とし
    #そうでない場合は、追加追従の最終アクターを追従対象とする。
    
    @data.empty? ? @data.push(Game_Follower.new(1, leader)) : @data.push(Game_Follower.new(1, @data[-1]))
    
    #通常の追従者を配列に追加していく。
    
    (2...$game_party.max_battle_members).each do |index|
      @data.push(Game_Follower.new(index, @data[-1]))
    end
    
    #仲間より後ろの追加追従を有効にする場合は追加する。
    
    if type && $game_switches[EXTEND_FOLLOWERS::SWITCH]
      
      #データサイズ取得用変数を用意。
      
      data_size = 0
      
      #戦闘メンバーの過不足を示すデータを取得する。
      
      @data.each do |follower|
        data_size += 1 if follower.actor
      end
      
      #追加追従の変数配列データから、アクターIDが指定されている物を選択し
      #配列にデータを追加していく。
      
      EXTEND_FOLLOWERS::EFV.each_with_index {|efv, i|
      next if $game_variables[EXTEND_FOLLOWERS::EFV[i]] == 0
      @data.push(Game_Follower.new(-(i + 1), data_size == 0 ? leader : @data[data_size - 1]))
      data_size += 1
      }
    end
    
    #キャラクタースプライトの更新フラグを立てる。
    
    $game_temp.character_refresh = true
    
    #追加追従の形式指定を消去する。
    
    $game_temp.ef_type = nil
    
    #位置を最適化する。
    
    synchronize($game_player.x, $game_player.y, $game_player.direction)
    
    #プレイヤーをリフレッシュする。
    
    $game_player.refresh
  end
end
class Game_Follower < Game_Character
  #--------------------------------------------------------------------------
  # 対応するアクターの取得
  #--------------------------------------------------------------------------
  alias actor_extend_followers actor
  def actor
    
    #メンバーインデックスが負の値の場合は追加追従者アクター、
    #そうでない場合は通常の処理を行う。
    
    @member_index < 0 ? extend_follower : actor_extend_followers
    
  end
  #--------------------------------------------------------------------------
  # 追加追従者アクター取得
  #--------------------------------------------------------------------------
  def extend_follower
    
    #配列に設定された変数IDのデータからアクターを取得。
    
    $game_actors[$game_variables[EXTEND_FOLLOWERS::EFV[@member_index.abs - 1]]]
  end
end
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # フレーム更新
  #--------------------------------------------------------------------------
  alias update_extend_followers update
  def update
    
    #キャラクタースプライトのリフレッシュフラグが有効な場合は
    #キャラクタースプライトのリフレッシュを行い、フラグを消去する。
    
    if $game_temp.character_refresh != nil
      @spriteset.refresh_characters
      $game_temp.character_refresh = nil
    end
    
    #本来の処理を実行する。
    
    update_extend_followers
  end
end