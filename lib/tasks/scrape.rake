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

  desc '食べログの東京の蕎麦屋TOP10の店舗詳細ページから各店の住所を取得'
  task :tabelog_address => :environment do
    # スクレイピング先のURL
    url = 'https://tabelog.com/soba/tokyo/rank/'
    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end

    # htmlをパースしてオブジェクト生成
    doc = Nokogiri::HTML.parse(html, nil, charset)

    page_links = []

    doc.xpath('//*[@class="list-rst__rst-name"]').each do |node|
      # リンク先URLの取得
      page_links << node.css("a")[0][:href]
    end

    store_addresses = []
    store_addresses_under = []

    page_links.each do |page_link|
      url = page_link
      charset = nil
      html = open(url) do |f|
        charset = f.charset # 文字種別を取得
        f.read # htmlを読み込んで変数htmlに渡す
      end
      doc = Nokogiri::HTML.parse(html, nil, charset)
      doc.xpath('//*[@class="rstinfo-table__address"]').each do |node|
        # 住所を取得
        store_addresses << node.css("a").inner_text
        # 住所の番地以降を取得
        store_addresses_under << node.xpath('//*[@id="contents-rstdata"]/div[3]/table[1]/tbody/tr[6]/td/p/span[2]/text()').inner_text
      end
    end

    # 住所と番地以降を結合
    for i in 0..9
      store_addresses[i].concat(store_addresses_under[i])
    end

    store_addresses = store_addresses.take(10)
    # id = 121から
    count = 121
    # DBから10件分のaddressカラムに保存
    store_addresses.each do |store_address|
      restaurant = Restaurant.find(count)
      restaurant.address = store_address
      restaurant.save
      count += 1
    end
  end
end