defmodule Chatter.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add(:name, :string, null: false)
      add(:description, :string)
      add(:is_public, :boolean, default: true, null: false)
      add(:is_archived, :boolean, default: false, null: false)
      add(:workspace_id, references(:workspaces, on_delete: :delete_all), null: false)
      add(:creator_id, references(:members, on_delete: :nothing), null: false)

      timestamps()
    end

    create(unique_index(:channels, [:workspace_id, :name]))
    create(index(:channels, [:workspace_id]))
    create(index(:channels, [:creator_id]))
  end
end
