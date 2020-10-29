defmodule Api.Accounts.Login do
  use Ecto.Schema
  import Ecto.Changeset

  schema "login" do
    field :email, :string
    field :password, :string

    timestamps()
  end

  @mail_regex ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
  @doc false
  def changeset(login, attrs) do
    login
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, @mail_regex)
  end
end
