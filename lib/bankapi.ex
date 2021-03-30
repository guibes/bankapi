defmodule Bankapi do
  @moduledoc """
  Bankapi keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Bankapi.User.Create, as: UserCreate
  alias Bankapi.User.Update, as: UserUpdate
  alias Bankapi.User.GetUserReferrals, as: GetUserReferrals

  defdelegate create_user(params), to: UserCreate, as: :call
  defdelegate update_user(params), to: UserUpdate, as: :call
  defdelegate get_user_referrals(params), to: GetUserReferrals, as: :call
end
