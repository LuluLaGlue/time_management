defmodule Api.Repo.Migrations.CreateCharts do
  use Ecto.Migration

  def change do
    create table(:charts) do
      add :user_id, :string
      add :line, :boolean, default: false, null: false
      add :bar, :boolean, default: false, null: false
      add :donut, :boolean, default: false, null: false

      timestamps()
    end

  end
end
