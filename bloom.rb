# Your code here!
require 'digest/md5'

class BloomFilter

  def initialize(m, k)
    if m.kind_of?(Integer) && k.kind_of?(Integer)
      @bloom_filter = Array.new(m).fill(0)
      @keywords = Array.new
      @m = m
      @k = k
    else
      puts "not Integer m or k"
    end
  end
  #ブルームフィルタに追加する
  def add(keyword)
    @k.times do |k|
      flg = my_hash(keyword + k.to_s)
      @bloom_filter[flg] = 1
    end
    @keywords.push(keyword)
    puts "Add #{keyword}"
  end

  #ブルームフィルタにkeywordが存在するか?
  def bfindex(keyword)
    @k.times do |k|
      flg = my_hash(keyword + k.to_s)
      return "#{keyword} is negative"  unless check_bloom?(flg)
    end
    return "#{keyword} is false positive"
  end

  #keywordの情報
  def get_keywords
    puts "keywords info: #{@keywords}"
    puts "bloomFiler info : \n #{@bloom_filter}"
  end

  #ハッシュ値を計算する
  private
  def my_hash(keyword)
    hashed_keyword = Digest::MD5.new.update(keyword).to_s
    return hashed_keyword.gsub(/[a-zA-Z]/,"").to_i % @m
  end

  #ハッシュ値のチェック
  private
  def check_bloom?(flg)
    @bloom_filter[flg] == 1 ? true : false
  end
endß

#初期情報
bloom_filter = BloomFilter.new(100, 3)

#追加
puts "=====登録====="
Dir.glob("colors/*.txt") do |t|
  keyword = File.read(t).chomp
  bloom_filter.add(keyword)
end

bloom_filter.get_keywords

#false negative
puts bloom_filter.bfindex(File.read('blue.txt').chomp)
puts bloom_filter.bfindex(File.read('carmine.txt').chomp)
puts bloom_filter.bfindex(File.read('grey.txt').chomp)


#negative
puts bloom_filter.bfindex(File.read("./negative/burgundy.txt").chomp)
