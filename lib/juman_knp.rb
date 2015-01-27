require "juman_knp/version"

# coding: utf-8
class Juman
  require 'open3'

  Juman_Versin = "7.0"
  
  Hinshi = ["名詞","助詞","動詞","接尾辞","助動詞","特殊","指示詞","判定詞","未定義語","形容詞","副詞","接頭辞","接続詞","連体詞","感動詞"]
  Category = ["人","組織・団体","動物","植物","動物-部位","植物-部位","人工物-食べ物","人工物-衣類","人工物-乗り物","人工物-金銭","人工物-その他","自然物","場所-施設","場所-施設部位","場所-自然","場所-機能","場所-その他","抽象物","形・模様","色","数量","時間"]
  Domain = ["文化・芸術","レクリエーション","スポーツ","健康・医学","家庭・暮らし","料理・食事","交通","教育・学習","科学・技術","ビジネス","メディア","政治"]

  attr_reader :ma_arr, :string, :id, :pos

  def initialize(string, id=nil, pos=nil)
    @id = id # please use for tilte, id , etc...
    @string = string
    @pos = pos # parts of speech(pos)
    @ma_arr = ma(string)
    
    unless pos == nil
      @specific_pos = words_of(pos)
    end
  end

  def array_of(i)
    array_of_i = Array.new
    
    case i
    when 0..10
      @ma_arr.each{|e| array_of_i.push(e[i])}
    # 代表表記
    when 17
      @ma_arr.each{|e| array_of_i.push(get_info(e, "代表表記"))}
    # 漢字読み
    when 18
      @ma_arr.each{|e| array_of_i.push(get_info(e, "漢字読み"))}
    # Category
    when 19
      @ma_arr.each{|e| array_of_i.push(get_info(e, "カテゴリ"))}
    # Domain
    when 20
      @ma_arr.each{|e| array_of_i.push(get_info(e, "ドメイン"))}
    else

    end
    return array_of_i
  end

  # filter of pos
  def words_of(pos)
    hinshi_arr = Array.new
    pos.each do |h|
      @ma_arr.each{|array_of| hinshi_arr.push(array_of) if h == array_of[3]}
    end
    @ma_arr = hinshi_arr
    return hinshi_arr
  end

  private
  
  # morphological analysis(ma)
  # Parameter > Stiring for ma
  # Return    > Array of console output
  def ma(string)
    begin
    maarr = Array.new
    # Juman's input is only Shift-JIS（for Windos）
    string.encode!("Windows-31J", "UTF-8", :invalid => :replace, :undef => :replace, :replace => '') 
    
    # using open3, execute Juman
    out, err, status = Open3.capture3("juman -b", :stdin_data => string)
    out.each_line do |line|
      line.chomp!.encode!("UTF-16BE", "Windows-31J", :invalid => :replace, :undef => :replace, :replace => '').encode!("UTF-8")
      maarr.push(line.split(/\s/)) unless line == "EOS"
    end
    return maarr
    rescue
      print("[エラー]：JUMANへPathを通してください。\n")
      exit!
    end
  end

  # Parameter >     e:one array of @ma_arr
  #              what:string of "カテゴリ" or "漢字読み" or ...
  # Return    >  info:sting of info related to what
  def get_info(e, what)
  	info = ""
  	e.each do |elm|
        info = elm.gsub(/#{what}:/, "").delete("\"") if /#{what}:/ =~ elm
    end
    return info
  end
end


class Knp
  require 'open3'

  KNP_Version = "4.11"

  attr_reader :pa_arr, :string, :asitis
 
  def initialize(string, id=nil)
    @id = id
    @string = string
    @pa_arr = pa(string)
    @asitis = @pa_arr[2]
  end
 
  # Parsing(pa) with KNP
  # Parameter > String for ma
  # Return    > Array of console output
  def pa(string, opttion = nil)

    asitis = []
    paarr = [[]]
    kihonku = [[]]
 
    # Juman's input is only Shift-JIS（for Windos）
    string.encode!("Windows-31J", "UTF-8", :invalid => :replace, :undef => :replace, :replace => '')
     
    # using open3, execute JUMAN|KNP
    begin
    out, err, status = Open3.capture3("juman | knp -simple ", :stdin_data => string)
    i = -1
    j = -1
    out.each_line do |line|
      line.chomp!.encode!("UTF-16BE", "Windows-31J", :invalid => :replace, :undef => :replace, :replace => '').encode!("UTF-8")
      asitis.push(line) unless line == "EOS"

      # making the array of Bunsetsu(文節)
      if line.split(/\s/)[0] == "*"
        i += 1
        paarr[i] = []
      end
      paarr[i].push(line) unless /^\+.+/ =~ line || line == "EOS"
 
      # making the array of Kihonku(基本句)
      if line.split(/\s/)[0] == "+"
        j += 1
        kihonku[j] = []
      end
      kihonku[j].push(line) unless /^\*.+/ =~ line || line == "EOS"
    end
    return paarr, kihonku, asitis

    rescue
      print("[エラー]：JUMANへPathを通してください。\n")
      exit!
    end

  end
 
  # dependency relations of Bunsetsu
  def bunsetsu
    # bunsetsu_hs
    # key:Information of ma of Bunsetsu(文節) [Array]
    # val:[Info of Bunsetsu, Where its dependence]
    bunsetsu_hs = Hash.new
    pa_tmp = @pa_arr[0]
    pa_tmp.each do |e|
      key = e.shift.split(/\s/)
      key.shift
      bunsetsu_hs[e]= key
    end
    return bunsetsu_hs
  end
   
end
