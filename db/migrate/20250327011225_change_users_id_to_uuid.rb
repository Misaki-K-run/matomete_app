class ChangeUsersIdToUuid < ActiveRecord::Migration[7.2]
  def up
    # users テーブルに UUID カラムを追加
    add_column :users, :uuid, :uuid, default: "gen_random_uuid()", null: false

    # 関連テーブルに UUID カラムを追加
    add_column :posts, :user_uuid, :uuid
    add_column :ai_generates, :user_uuid, :uuid
    add_column :bookmarks, :user_uuid, :uuid
    add_column :favorites, :user_uuid, :uuid

    # 既存のデータを UUID に変換
    execute "UPDATE posts SET user_uuid = (SELECT uuid FROM users WHERE users.id = posts.user_id)"
    execute "UPDATE ai_generates SET user_uuid = (SELECT uuid FROM users WHERE users.id = ai_generates.user_id)"
    execute "UPDATE bookmarks SET user_uuid = (SELECT uuid FROM users WHERE users.id = bookmarks.user_id)"
    execute "UPDATE favorites SET user_uuid = (SELECT uuid FROM users WHERE users.id = favorites.user_id)"

    # 外部キー制約を削除
    remove_foreign_key :posts, :users
    remove_foreign_key :ai_generates, :users
    remove_foreign_key :bookmarks, :users
    remove_foreign_key :favorites, :users

    # users の ID を UUID に変更
    remove_column :users, :id
    rename_column :users, :uuid, :id
    execute "ALTER TABLE users ADD PRIMARY KEY (id);"

    # 各テーブルの user_id を UUID に変更
    remove_column :posts, :user_id
    rename_column :posts, :user_uuid, :user_id

    remove_column :ai_generates, :user_id
    rename_column :ai_generates, :user_uuid, :user_id

    remove_column :bookmarks, :user_id
    rename_column :bookmarks, :user_uuid, :user_id

    remove_column :favorites, :user_id
    rename_column :favorites, :user_uuid, :user_id

    # 外部キーを再追加
    add_foreign_key :posts, :users, column: :user_id
    add_foreign_key :ai_generates, :users, column: :user_id
    add_foreign_key :bookmarks, :users, column: :user_id
    add_foreign_key :favorites, :users, column: :user_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
