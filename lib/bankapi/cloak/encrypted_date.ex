defmodule Bankapi.Encrypted.Date do
  @moduledoc """
  Module to create the date option in ecto_cloak
  """
  use Cloak.Ecto.Date, vault: Bankapi.Vault
end
