defmodule Bankapi.Encrypted.Binary do
  @moduledoc """
  Module to create the binary option in ecto_cloak
  """
  use Cloak.Ecto.Binary, vault: Bankapi.Vault
end
