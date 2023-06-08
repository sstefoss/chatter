defmodule Chatter.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE workspace_user_role AS ENUM ('admin', 'moderator', 'member')"
    drop_query = "DROP TYPE workspace_user_role"
    execute(create_query, drop_query)

    create table(:members) do
      add :workspace_id, references(:workspaces, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :username, :string
      add :fullname, :string
      add :avatar, :string
      add :role, :workspace_user_role, null: false, default: "member"
      add :is_archived, :boolean, default: false, null: false
      add :is_verified, :boolean, default: false, null: false

      timestamps()
    end

    create index(:members, [:user_id, :workspace_id], unique: true)
    create unique_index(:members, [:workspace_id, :username])
  end
end
