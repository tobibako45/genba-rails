class Task < ApplicationRecord
  before_validation :set_nameless_name

  # こっちのが見やすい？
  validates :name, presence: true
  validates :name, length: {maximum: 30}
  # validates :name, presence: true, length: {maximum: 30}

  validate :validate_name_not_including_comma

  # TaskとUserの関係は、多対1
  belongs_to :user

  # スコープ
  # recentという名前で登録
  scope :recent, -> { order(created_at: :desc) }



  private

  def set_nameless_name
    # blank?(nilや空白)の時に、'名前なし'を代入
    self.name = '名前なし' if name.blank?
  end



  def validate_name_not_including_comma
    # include? 要素にオブジェクトが含まれていればtrue この場合は「,」
    # &. でnameがnilの場合に例外が発生することを避けるため。nilを返すために
    errors.add(:name, 'にカンマを含めることはできません。') if name&.include?(',')
  end

end
