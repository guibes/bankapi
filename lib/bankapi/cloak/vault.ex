defmodule Bankapi.Vault do
  @moduledoc """
  Vault for cloak encryption/decryption database.
  """
  use Cloak.Vault, otp_app: :bankapi
end
