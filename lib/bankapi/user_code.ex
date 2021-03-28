defmodule Bankapi.UserCode do
  @moduledoc """
  Module used to calculate the user UserCode.
  This module uses the Puid Library to easy generate secure strings. With no repeating.
  The source code of library can be find in https://github.com/puid/Elixir
  Using the 8 digits -> total: 10.
  With 1 trillon of chance to repeat.
  With only Alphanumeric chars.
  """
  use(Puid, total: 10, risk: 1.0e12, charset: :alphanum)
end
