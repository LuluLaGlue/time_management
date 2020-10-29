defmodule Api.Data.Chart do
  use Ecto.Schema
  import Ecto.Changeset

  schema "charts" do
    field :bar, :boolean, default: false
    field :donut, :boolean, default: false
    field :line, :boolean, default: false
    field :user_id, :string

    timestamps()
  end

  @doc false
  def changeset(chart, attrs) do
    chart
    |> cast(attrs, [:user_id, :line, :bar, :donut])
    |> validate_required([:user_id, :line, :bar, :donut])
  end
end
