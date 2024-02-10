#------------------------------------------------------------------------------
#       ＣＧギャラリーの設定
#------------------------------------------------------------------------------

module SUI
#   ＣＧのリスト
#   ＊ 各項目について ＊
#       タイトル　　 ： ギャラリー画面のヘルプに表示されます。
#
#       CGファイル名 ： 各ＣＧの差分番号を取り除いたファイル名を指定して下さい。
#                       閲覧フラグは差分01を見たか、見てないかで判断されます。
#
#       サムネ番号　 ： サムネイルのどの位置を表示するか指定して下さい。
#　　　　　　　　　　 　回想ギャラリーではこの数字が指定した変数に渡されます。
#
#       フィルタ　　 ： フィルタグループを指定します。
#                       ギャラリーでフィルタを指定すると、
#                       ここで設定されたシーンが抽出されて表示されます。
#
#                       「０」番は全表示フィルタのため、１番から設定して下さい。
#       シーン回想有無 ： ＣＧのみで、イベントが無いものは「0」を指定して下さい。


CG_LIST = [
  # Title                 , File Name   , Thumbnail No., Filter , Scene Recall
  
   ["The customer's... it's very, hot"            , "Bmcg01"     ,  1       , 2      , 1],
   ["This is... the act of selling one's body..." , "Bmcg02"     ,  2       , 2      , 1],
   ["This is... the act of selling one's body..." , "Bmcg02h"    ,  51      , 2      , 1],
   ["Sa... this is the worst feeling!"            , "Bmcg03a"    ,  3       , 1     , 1],
   ["Sa... this is the worst feeling!"            , "Bmcg03b"    ,  4       , 2     , 1],
   ["You guys, no more than this...!"             , "Bmcg04a"    ,  5       , 1     , 1],
   ["You guys, no more than this...!"             , "Bmcg04ah"   ,  52      , 1     , 1],
   ["You guys, no more than this...!"             , "Bmcg04b"    ,  6       , 2     , 1],
   ["You guys, no more than this...!"             , "Bmcg04bh"   ,  53      , 2     , 1],
   ["No, stop... not there...!"                   , "Bmcg05a"    ,  7       , 1     , 1],
   ["No, stop... not there...!"                   , "Bmcg05ah"   ,  54      , 1     , 1],
   ["No, stop... not there...!"                   , "Bmcg05b"    ,  8       , 2     , 1],
   ["No, stop... not there...!"                   , "Bmcg05bh"   ,  55      , 2     , 1],
   ["Don't touch... not there...!"                , "Bmcg06a"    ,  9       , 1     , 1],
   ["Don't touch... not there...!"                , "Bmcg06ah"   ,  56      , 1     , 1],
   ["Don't touch... not there...!"                , "Bmcg06b"    ,  10      , 2     , 1],
   ["Don't touch... not there...!"                , "Bmcg06bh"   ,  57      , 2     , 1],
   ["You, it's about time to stop...!"            , "Bmcg07a"    ,  11      , 1     , 1],
   ["You, it's about time to stop...!"            , "Bmcg07b"    ,  12      , 2     , 1],
   ["Who would feel anything...!"                 , "Bmcg08a"    ,  13      , 1     , 1],
   ["Who would feel anything...!"                 , "Bmcg08ah"   ,  58      , 1     , 1],
   ["Who would feel anything...!"                 , "Bmcg08b"    ,  14      , 2     , 1],
   ["Who would feel anything...!"                 , "Bmcg08bh"   ,  59      , 2     , 1],
   ["Like this, I... I'll break..."               , "Bmcg09a"    ,  15      , 1     , 1],
   ["Like this, I... I'll break..."               , "Bmcg09ah"   ,  60      , 1     , 1],
   ["Like this, I... I'll break..."               , "Bmcg09b"    ,  16      , 2     , 1],
   ["Like this, I... I'll break..."               , "Bmcg09bh"   ,  61      , 2     , 1],
   ["What are you doing...!?"                     , "Bmcg10a"    ,  17      , 1     , 1],
   ["What are you doing...!?"                     , "Bmcg10b"    ,  18      , 2     , 1],
   ["What is this guy...!"                        , "Bmcg11a"    ,  19      , 1     , 1],
   ["What is this guy...!"                        , "Bmcg11ah"   ,  62      , 1     , 1],
   ["What is this guy...!"                        , "Bmcg11b"    ,  20      , 2     , 1],
   ["What is this guy...!"                        , "Bmcg11bh"   ,  63      , 2     , 1],
   ["Then... I'll start moving"                   , "Bmcg12"     ,  21      , 2     , 1],
   ["Two at once like this..."                    , "Bmcg13"     ,  22      , 2     , 1],
   ["Let me go... release me!"                    , "Bmcg14a"    ,  23      , 1     , 1],
   ["Let me go... release me!"                    , "Bmcg14ah"   ,  64      , 1     , 1],
   ["Let me go... release me!"                    , "Bmcg14b"    ,  24      , 2     , 1],
   ["Let me go... release me!"                    , "Bmcg14bh"   ,  65      , 2     , 1],
   ["You guys... doing things like this...!"      , "Bmcg15a"    ,  25      , 1     , 1],
   ["You guys... doing things like this...!"      , "Bmcg15b"    ,  26      , 2     , 1],
   ["Stop, no more than this...!"                 , "Bmcg16a"    ,  27      , 1     , 1],
   ["Stop, no more than this...!"                 , "Bmcg16b"    ,  28      , 2     , 1],
   ["Shota-eating Fine 01"                        , "Bmcg17"     ,  29      , 2     , 1],
   ["Shota-eating Fine 02"                        , "Bmcg18"     ,  30      , 2     , 1],
   ["Such a lively carrot, huh..."                , "Bmcg19"     ,  66      , 1     , 1],
   ["Stirring it around so messily...!"           , "Bmcg20"     ,  67      , 1     , 1],
   ["Three in front of me..."                     , "Bmcg21"     ,  68      , 1     , 1],
   ["Thick ones, at the same time..."             , "Bmcg22"     ,  69      , 1     , 1],
   ["Does it feel good... in the breasts...?"     , "Bmcg23"     ,  70      , 2     , 1],
   ["I want to become one with you..."            , "Bmcg24"     ,  71      , 2     , 1],

   ["No, not with the chest like this..."         , "Bscg01"     ,  31      , 3     , 1],
   ["Goddess... someone, help... me..."           , "Bscg02"     ,  32      , 3     , 1],
#   [" "                                              , "Bscg01a"    ,  33      , 3     , 1],
#   [" "                                              , "Bscg02b"    ,  34      , 3     , 1],
   ["I must endure... for now..."                 , "Bscg03"     ,  35      , 3     , 1],
   ["No, no... don't look, I don't want it...!"   , "Bscg04"     ,  36      , 3     , 1],
   ["Soon I'll have repaid all the debt..."       , "Bscg05"     ,  37      , 3     , 1],
   ["That's not right... this isn't what was promised!" , "Bscg06" ,  38      , 3     , 1],
   ["To sandwich such a thing with my breasts..." , "Bscg07"     ,  39      , 3     , 1],
   ["Different... I wouldn't do such a thing...!" , "Bscg08"     ,  40      , 3     , 1],
   ["Does it feel... good, dear customer...?"     , "Bscg09"     ,  41      , 3     , 1],
   ["No, I don't want this... not there!"         , "Bscg10"     ,  42      , 3     , 1],
   ["With this, please spare my daughter..."      , "Bscg11"     ,  43      , 3     , 1],
   ["Such a thing, from anyone but him...!"       , "Bscg12"     ,  44      , 3     , 1],
   ["But for Mama... for my mama..."              , "Bscg13"     ,  45      , 3     , 1],
   ["Ah, my stomach... so full... ah!"            , "Bscg14"     ,  46      , 3     , 1],
   ["(I've got no interest at all in this...)"      , "Bscg15"     ,  47      , 3     , 1],
   ["(Hey, stop that... are you serious!?)"         , "Bscg16"     ,  48      , 3     , 1],
   ["Such displeasure... it's unbelievable..."    , "Bscg17"     ,  49      , 3     , 1],
   ["I, a human being... with the likes of you..." , "Bscg18"    ,  50      , 3     , 1],


  ]
end