defmodule Chatter.Models.Message do
  use Ecto.Schema
  import Ecto.Changeset

  alias Chatter.Models.Member
  alias Chatter.Models.Channel

  @required_fields ~w(text sender_id recipient_id)a
  @optional_fields ~w(channel_id)a

  schema "messages" do
    field :text, :string
    belongs_to :sender, Member, foreign_key: :sender_id
    belongs_to :recipient, Member, foreign_key: :recipient_id
    belongs_to :channel, Channel

    timestamps()
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
