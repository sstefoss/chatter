defmodule Chatter.Repo.Migrations.CreateChannelsParticipants do
  use Ecto.Migration

  def change do
    create table(:participants) do
      add(:channel_id, references(:channels, on_delete: :delete_all), null: false)
      add(:member_id, references(:members), null: false)

      timestamps()
    end

    create index(:participants, [:member_id, :channel_id], unique: true)
  end
end
