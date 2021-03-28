defmodule Bankapi do
  @moduledoc """
  Bankapi keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Bankapi.User.CreateorUpdate, as: UserCreateorUpdate
  alias Bankapi.User.GetUserReferrals, as: GetUserReferrals

  defdelegate create_or_update_user(params), to: UserCreateorUpdate, as: :call
  defdelegate get_user_referrals(params), to: GetUserReferrals, as: :call
end
