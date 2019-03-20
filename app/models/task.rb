class Task < ApplicationRecord
  # before_validation :set_nameless_name

  # 一つのタスクから一つの画像を紐付ける。Taskもでるからimageを呼ぶことを指定している。
  has_one_attached :image

  # validates :name, presence: true
  # validates :name, length: {maximum: 30}
  # validates :name, presence: true, length: {maximum: 30}

  validate :validate_name_not_including_comma

  # TaskとUserの関係は、多対1
  belongs_to :user

  # スコープ
  # recent(最近)という名前で登録
  scope :recent, -> {order(created_at: :desc)}


  # ransackable_attributes
  # 検索対象にすることを許可するカラムを指定
  def self.ransackable_attributes(auth_objest = nil)
    %w[name created_at]
  end

  # ransackable_associations
  # 検索条件を含める関連を指定。
  # これを、空に配列を返すようにオーバーライドすることで、検索条件に意図しない関連を含めないようにしてる。
  def self.ransackable_associations(auth_object = nil)
    []
  end


  # CSVデータをどの属性をどの順番で出力するかを得るメソッド
  def self.csv_attributes
    ["name", "description", "created_at", "updated_at"]
  end

  def self.generate_csv
    # CSV.generateで、CSVデータの文字列を生成します。
    CSV.generate(headers: true) do |csv|
      # CSVの１行目としてヘッダを出力する。ここでは属性名をそのまま見出しとして使ってる。
      csv << csv_attributes

      all.each do |task|
        # allメソッドで全タスクを取得し、１レコードごとにCSVの１行を出力します。
        # その際は属性ごとにTaskオブジェクトから属性値を取り出してcsvに与えている。
        csv << csv_attributes.map {|attr| task.send(attr)}
        # attrに属性が入ってるので、sendメソッドで、
        # task.name
        # task.description
        # task.created_at
        # task.updated_at
        # を、取り出してcsvに書き込んでる
      end
    end
  end


  # fileという名前の引数で、アップされたファイルの内容にアクセスするためのオブジェクトを受け取る
  def self.import(file)
    # CSV.foreachを使って、CSVファイルを一行ずつ読み込む。
    # header: trueの指定により、１行目をヘッダとして無視するようにする。
    CSV.foreach(file.path, headers: true) do |row|
      # CSV１行ごとに、Taskインスタンスを生成します。new はTask.newと同意です。
      # このクラスメソッドでは、selfがTaskの状態なので、省略してます。
      task = new
      # 生成したTaskインスタンスの各属性に、CSVの一行の情報を加工して入れ込みます。
      # slice railsがhashクラスに追加しているメソッド。指定した安全なキーに対応するデータだけを取り出して入力に用いるようにしている。
      # sliceに指定している csv_attributes は、csv_attributeメソッドに戻り値の配列内ｎ要素をそれぞれ引数に指定する書き方。
      # slice("name", "description", "created_at", "updated_at")と記述しているのと同じ意味
      task.attributes = row.to_hash.slice(*csv_attributes)
      # Taskインスタンスをデータベースに登録します。
      task.save!
    end
  end


  private

  # def set_nameless_name
  #   # blank?(nilや空白)の時に、'名前なし'を代入
  #   self.name = '名前なし' if name.blank?
  # end

  def validate_name_not_including_comma
    # include? 要素にオブジェクトが含まれていればtrue この場合は「,」
    # &. でnameがnilの場合に例外が発生することを避けるため。nilを返すために
    errors.add(:name, 'にカンマを含めることはできません。') if name&.include?(',')
  end

end
