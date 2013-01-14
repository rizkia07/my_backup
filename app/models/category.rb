# -*r coding: utf-8 -*-
class Category
  def self.hoge(name)
    title = Title.find_by_name(name)
    parent_id = Branch.find_by_parent_id_and_title_id(
      2,
      title.id
    ).id

    res = []
    Branch.where(
      :parent_id => parent_id,
      :is_fixed => false,
      #:leaf_num => " > 0",
    ).each{ |branch|
      res.push(branch.title.name) if (!branch.title.url_id && branch.title.branch_id == nil && branch.title.is_ng == false)
    }
    res
  end

  def self.updt_all
    Branch.update_all(:is_fixed => false)
    Title.update_all(:is_ng => false, :branch_id => nil)
    ng_titles = [
      "test2-2", "test2-3", "test2-4", "test2-5", "test2-6", "test2-7", "test2-1-1", "test2-1-2", "test2-1-3",
      "tree(仮)について", "mindiaっぽいものをここでも", "英語でも書いてみる", "test2",
      "A", "B", "C","D", "jdoiajfojdfoas", "fugahoge", ",e", "aaaaaa", "aaaaa",
      "iPhoneアプリ（飛岡）", "Webアプリ（西小倉）", "API（西小倉）",
    ]
    ng_titles.each do |name|
      title = Title.find_by_name(name)
      title.update_attribute('is_ng', true)
    end
    self.updt(self.data, 0)
  end

  def self.add(data)
    parent_id = 0
    data.each do |i|
      title = Title.get(i)
      branch = Branch.find_or_create_by_title_id_and_parent_id(
        title.id,
        parent_id
      )
      branch.is_fixed = true
      branch.title.branch_id = branch.id
      branch.title.save
      branch.save
      parent_id = branch.id
    end
  end

  def self.updt(data, parent_id)
    data.each do |title, children|
      title = Title.get(title)
      branch = Branch.find_or_create_by_title_id_and_parent_id(
        title.id,
        parent_id
      )
      branch.is_fixed = true
      branch.save
      branch.title.branch_id = branch.id
      branch.title.save
      self.updt(children, branch.id)
    end
  end

  def self.data
    data = {
      "English" => {
        "Geography" => {},
        "History" => {},
        "Information Technology" => {},
        "Life" => {},
        "Creative" => {},

      },
      "日本語" => {
        "iPhoneアプリ" => {
          "エンタメ" => {},
          "教育" => {}, 
          "読み物" => {}, 
          "ゲーム" => {}, 
          "旅行" => {},
          "ユーティリティ" => {},
          "仕事効率化" => {}, 
          "ヘルスケア／フィットネス" => {}
        }, 
        "エンタメ" => {
          "音楽" => {},
          "映画" => {},
          "テレビ" => {},
          "ラジオ" => {}
        }, 
        "ゲーム" => {
          "GREE" => {},
          "モバゲー" => {}, 
          "mixi" => {}, 
          "PSP" => {}, 
          "DS" => {},
          "Xbox" => {},
          "wii" => {}, 
          "PS3" => {}
        }, 
        "子育て" => {
          "悩み" => {},
          "教育" => {},
          "食べ物" => {},
          "着る物" => {}
        }, 
        "旅行" => {
          "日本" => {
            "東京" => {
              "代々木" => {
              }
            },
          },
          "アジア" => {},
          "ヨーロッパ" => {},
          "アメリカ" => {},
          "南アメリカ" => {},
          "アフリカ" => {},
          "オセアニア" => {}
        },
        "語学" => {
          "日本語" => {},
          "英語" => {},
          "中国語" => {},
          "韓国語" => {},
          "イタリア語" => {},
          "スペイン語" => {},
          "フランス語" => {},
          "ロシア語" => {},
          "ポルトガル語" => {},
          "ドイツ語" => {},
          "アラビア語" => {},
          "タガログ語" => {}
        }, 
        "歴史" => {
          "2010年代" => {},
          "2000年代" => {},
          "1990年代" => {},
          "1980年代" => {},
          "1970年代" => {},
          "1960年代" => {},
          "1950年代" => {},
          "1940年代" => {},
          "1930年代" => {},
          "1920年代" => {},
          "1910年代" => {},
          "1900年代" => {}
        }, 
        "科学" => {
          "科学者" => {},
          "数学" => {},
          "物理学" => {},
          "化学" => {},
          "医学" => {},
          "生命科学" => {},
          "地学" => {},
          "情報科学" => {},
        }, 
        "職業" => {
          "金融" => {},
          "IT" => {},
          "自動車関連" => {},
          "建築" => {},
          "不動産" => {},
          "素材" => {},
          "機械製造" => {},
          "電機・精密機器" => {},
          "生活用品" => {},
          "外食" => {},
          "運輸" => {},
          "流通" => {},
          "エンタメ" => {},
          "マスコミ" => {}
        }, 
        "政治" => {
          "政党" => {},
          "社会問題" => {}
        }, 
        "クリエイティブ" => {}, 
        "IT" => {
          "ビジネスモデル" => {
            "ソーシャルゲーム" => {},
            "Web制作" => {}
          },
          "セキュリティ" => {
            "高木浩光" => {}
          },
          "インターネット" => { 
            "レンタルサーバ" => {

            }
          },
          "プログラミング" => {

          },

          "プログラミング言語" => {
            "C言語" => {},
            "Ruby" => {},
            "PHP" => {},
            "JAVA" => {},
            "Python" => {},
            "Objective-C" => {},
            "clojure" => {},
          },
          "モバイル" => {
            "iPhone" => {},
            "Android" => {},
            "windows" => {},
          }
        }
      }
    }
    data
  end
end
