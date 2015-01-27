# JumanKnp

wrapper of Juman and Kna by Ruby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'juman_knp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install juman_knp

## Usage

```ruby
text = "学問の発展はこの世の中をより良いものにする。"
j = Juman.new(text)
p j.array_of(0) 
#=> ["学問", "の", "発展", "は", "この", "世の中", "を", "より", "良い", "もの", "に", "する", "。"]

j = Juman.new(text, nil, ["名詞", "形容詞", "動詞"])
p j.array_of(0) 
#=> ["学問", "発展", "世の中", "もの", "良い", "する"]

p j.array_of(19)
#=> ["抽象物", "抽象物", "抽象物", "", "", ""]

p j.array_of(20)
#=> ["教育・学習", "", "", "", "", ""]
```

##Methods

  new(dtring, id, pos) : 初期化。text(文字列)を解析したインスタンスを作成。
                          idとposはデフォルトでnilになっている。
                          id(文章のIDや、タイトルなどを想定)はなんでもよいけど、文字列推奨。
                          pos（parts of speech:pos）は品詞の配列。例えば以下のようなもの。
                          ex.) pos = ["名詞", "形容詞", "動詞", "副詞"]
                          使える品詞はClass内の配列Hinshi参照。
                          
               string : Jumanで解析した文章を返す（文字列）
                   id : インスタンス作成の際に指定したidを返す
                  pos : インスタンス作成の際に指定した品詞を返す
               ma_arr : コマンドライン出力の情報を返す（二重配列）
          array_of(j) : jで指定した形態素情報を返す（配列）
          
                         0：表記（そのまま）　⇒　いわゆる分かち書き
                         1：よみ
                         2：普通表記(原形)　⇒　単語のカウントなどに便利
                         3：品詞
                         4：<Jumanマニュアル参照-よくわからない>
                         5：品詞細分類(活用型)
                         6：<Jumanマニュアル参照-よくわからない>
                         7：<Jumanマニュアル参照-よくわからない>
                         8：<Jumanマニュアル参照-よくわからない>
                         9：<Jumanマニュアル参照-よくわからない>
                        10：<Jumanマニュアル参照-よくわからない>
                        11:-------------
                        ||:＜割り当てなし＞
                        16:-------------
                        17：代表表記　　【出力形式】":（カテゴリ名）"
                        18：漢字読み　　【出力形式】":（カテゴリ名）"
                        19：カテゴリ　　 【出力形式】"カテゴリ:（カテゴリ名）"　⇒　単語の階層関係で上位概念を抽出
                        20：ドメイン　 　【出力形式】"ドメイン：（ドメイン名）"　⇒　文章のジャンル（主題）推定


## Contributing

1. Fork it ( https://github.com/[my-github-username]/juman_knp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
