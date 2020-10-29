defmodule ApiWeb.ChartControllerTest do
  use ApiWeb.ConnCase

  alias Api.Data
  alias Api.Data.Chart

  @create_attrs %{
    bar: true,
    donut: true,
    line: true,
    user_id: "some user_id"
  }
  @update_attrs %{
    bar: false,
    donut: false,
    line: false,
    user_id: "some updated user_id"
  }
  @invalid_attrs %{bar: nil, donut: nil, line: nil, user_id: nil}

  def fixture(:chart) do
    {:ok, chart} = Data.create_chart(@create_attrs)
    chart
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all charts", %{conn: conn} do
      conn = get(conn, Routes.chart_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create chart" do
    test "renders chart when data is valid", %{conn: conn} do
      conn = post(conn, Routes.chart_path(conn, :create), chart: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.chart_path(conn, :show, id))

      assert %{
               "id" => id,
               "bar" => true,
               "donut" => true,
               "line" => true,
               "user_id" => "some user_id"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.chart_path(conn, :create), chart: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update chart" do
    setup [:create_chart]

    test "renders chart when data is valid", %{conn: conn, chart: %Chart{id: id} = chart} do
      conn = put(conn, Routes.chart_path(conn, :update, chart), chart: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.chart_path(conn, :show, id))

      assert %{
               "id" => id,
               "bar" => false,
               "donut" => false,
               "line" => false,
               "user_id" => "some updated user_id"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, chart: chart} do
      conn = put(conn, Routes.chart_path(conn, :update, chart), chart: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete chart" do
    setup [:create_chart]

    test "deletes chosen chart", %{conn: conn, chart: chart} do
      conn = delete(conn, Routes.chart_path(conn, :delete, chart))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.chart_path(conn, :show, chart))
      end
    end
  end

  defp create_chart(_) do
    chart = fixture(:chart)
    %{chart: chart}
  end
end
