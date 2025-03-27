class ChangePostsIdToUuid < ActiveRecord::Migration[7.2]
  def up
    # posts テーブルに UUID カラムを追加
    add_column :posts, :uuid, :uuid, default: "gen_random_uuid()", null: false

    # 関連テーブルに UUID カラムを追加
    add_column :shopping_lists, :post_uuid, :uuid
    add_column :menus, :post_uuid, :uuid
    add_column :bookmarks, :post_uuid, :uuid

    # 既存のデータを移行
    execute "UPDATE shopping_lists SET post_uuid = (SELECT uuid FROM posts WHERE posts.id = shopping_lists.post_id)"
    execute "UPDATE menus SET post_uuid = (SELECT uuid FROM posts WHERE posts.id = menus.post_id)"
    execute "UPDATE bookmarks SET post_uuid = (SELECT uuid FROM posts WHERE posts.id = bookmarks.post_id)"  # 追加

    # 外部キー制約を削除
    remove_foreign_key :shopping_lists, :posts
    remove_foreign_key :menus, :posts
    remove_foreign_key :bookmarks, :posts

    # posts の ID を UUID に変更
    remove_column :posts, :id
    rename_column :posts, :uuid, :id
    execute "ALTER TABLE posts ADD PRIMARY KEY (id);"

    # 各テーブルの post_id を UUID に変更
    remove_column :shopping_lists, :post_id
    rename_column :shopping_lists, :post_uuid, :post_id

    remove_column :menus, :post_id
    rename_column :menus, :post_uuid, :post_id

    remove_column :bookmarks, :post_id
    rename_column :bookmarks, :post_uuid, :post_id

    # 外部キーを再追加
    add_foreign_key :shopping_lists, :posts, column: :post_id
    add_foreign_key :menus, :posts, column: :post_id
    add_foreign_key :bookmarks, :posts, column: :post_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
