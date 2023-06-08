defmodule Chatter.Repo.Migrations.CreateWorkspaces do
  use Ecto.Migration

  def change do
    create table(:workspaces) do
      add :name, :string, null: false
      add :icon_path, :string, null: false
      add :creator_id, references(:users), null: false

      timestamps()
    end

    create unique_index(:workspaces, [:name])
  end
end
