defmodule BankapiWeb.ErrorView do
  use BankapiWeb, :view
  import Ecto.Changeset, only: [traverse_errors: 2]
  alias Ecto.Changeset
  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end

  def render("400.json", %{result: %Changeset{} = changeset}) do
    %{message: translate_erros(changeset)}
  end

  def render("400.json", %{result: result}) do
    %{message: %{error: result}}
  end

  def render("401.json", %{result: result}) do
    %{message: %{error: result}}
  end

  def render("403.json", %{result: result}) do
    %{message: %{error: result}}
  end

  def render("404.json", %{result: result}) do
    %{message: %{error: result}}
  end

  defp translate_erros(changeset) do
    traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
