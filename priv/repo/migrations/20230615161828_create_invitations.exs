defmodule Chatter.Repo.Migrations.CreateInvitations do
  use Ecto.Migration

  def change do
    create table(:invitations) do
      add(:workspace_id, references(:workspaces, on_delete: :delete_all), null: false)
      add(:email, :string)

      timestamps()
    end

    create(index(:invitations, [:workspace_id, :email], unique: true))
  end
end
