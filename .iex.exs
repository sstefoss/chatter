defmodule Hauleth.IExHelpers do
  defdelegate r(), to: IEx.Helpers, as: :recompile
end

alias Chatter.Accounts.User
alias Chatter.Models.Workspace
alias Chatter.Models.Channel
alias Chatter.Models.Member
alias Chatter.Models.Participant
