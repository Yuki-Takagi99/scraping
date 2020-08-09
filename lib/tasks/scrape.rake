require 'open-uri'

namespace :scrape do

  desc '食べログの東京の蕎麦屋TOP10ページから店名を取得'
  task :tabelog_store_name => :environment do
    # スクレイピング先のURL
    url = 'https://tabelog.com/soba/tokyo/rank/'
    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end

    # htmlをパースしてオブジェクト生成
    doc = Nokogiri::HTML.parse(html, nil, charset)

    store_names = []

    doc.xpath('//*[@class="list-rst__rst-name"]').each do |node|
      # 店名の取得
      store_names << node.css("a").inner_text
    end
    # 先頭から10件の店名を取得し、DBに保存
    store_names = store_names.take(10)
    store_names.each do |store_name|
      restaurant = Restaurant.new
      restaurant.name = store_name
      restaurant.save
    end
  end
end