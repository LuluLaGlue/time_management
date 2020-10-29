defmodule ApiWeb.ChartView do
  use ApiWeb, :view
  alias ApiWeb.ChartView

  def render("index.json", %{charts: charts}) do
    %{data: render_many(charts, ChartView, "chart.json")}
  end

  def render("show.json", %{chart: chart}) do
    %{data: render_one(chart, ChartView, "chart.json")}
  end

  def render("chart.json", %{chart: chart}) do
    %{id: chart.id,
      user_id: chart.user_id,
      line: chart.line,
      bar: chart.bar,
      donut: chart.donut}
  end
end
