defmodule Api.Repo.Migrations.CreateChartmanager do
  use Ecto.Migration

  def change do
    create table(:chartmanager) do
      add :user, :string
      add :line, :boolean, default: false, null: false
      add :bar, :boolean, default: false, null: false
      add :donut, :boolean, default: false, null: false

      timestamps()
    end

  end
end
