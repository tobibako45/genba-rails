class AddUserIdTasks < ActiveRecord::Migration[5.2]

  def up
    # ますSQLで、今まで作られたやつを削除する。
    # 既存がある状態で、関連カラム(user_id)を追加すると、
    # 既存のタスクに紐付くユーザーが決められず、NOT NULL制約に引っかかる。
    # なので、既存のタスクをすべて削除してから、カラム追加を行うようにする。
    execute 'DELETE FROM tasks;'
    add_reference :tasks, :user, null: false, index: true
  end

  def down
    remove_reference :tasks, :user, index: true
  end

end
