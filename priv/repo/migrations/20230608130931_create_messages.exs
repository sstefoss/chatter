defmodule Chatter.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :text, :text, null: false
      add :sender_id, references(:members), null: false
      add :recipient_id, references(:members), null: false
      add :channel_id, references(:channels, on_delete: :delete_all)

      timestamps()
    end

    create index(:messages, [:sender_id])
    create index(:messages, [:recipient_id])
    create index(:messages, [:channel_id])
  end
end
