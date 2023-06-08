defmodule Chatter.Models.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  alias Chatter.Models.Channel
  alias Chatter.Models.Member

  @required_fields ~w(channel_id member_id)a

  schema "participants" do
    belongs_to :channel, Channel
    belongs_to :member, Member

    timestamps()
  end

  def changeset(participant, attrs) do
    participant
    |> cast(attrs, @required_fields)
    |> unique_constraint([:member_id, :channel_id], name: :participants_member_id_channel_id_index)
  end
end
