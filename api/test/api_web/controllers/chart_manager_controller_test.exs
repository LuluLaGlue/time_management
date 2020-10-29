defmodule ApiWeb.ChartManagerControllerTest do
  use ApiWeb.ConnCase

  alias Api.Accounts
  alias Api.Accounts.ChartManager

  @create_attrs %{
    bar: true,
    donut: true,
    line: true,
    user: "some user"
  }
  @update_attrs %{
    bar: false,
    donut: false,
    line: false,
    user: "some updated user"
  }
  @invalid_attrs %{bar: nil, donut: nil, line: nil, user: nil}

  def fixture(:chart_manager) do
    {:ok, chart_manager} = Accounts.create_chart_manager(@create_attrs)
    chart_manager
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all chartmanager", %{conn: conn} do
      conn = get(conn, Routes.chart_manager_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create chart_manager" do
    test "renders chart_manager when data is valid", %{conn: conn} do
      conn = post(conn, Routes.chart_manager_path(conn, :create), chart_manager: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.chart_manager_path(conn, :show, id))

      assert %{
               "id" => id,
               "bar" => true,
               "donut" => true,
               "line" => true,
               "user" => "some user"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.chart_manager_path(conn, :create), chart_manager: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update chart_manager" do
    setup [:create_chart_manager]

    test "renders chart_manager when data is valid", %{conn: conn, chart_manager: %ChartManager{id: id} = chart_manager} do
      conn = put(conn, Routes.chart_manager_path(conn, :update, chart_manager), chart_manager: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.chart_manager_path(conn, :show, id))

      assert %{
               "id" => id,
               "bar" => false,
               "donut" => false,
               "line" => false,
               "user" => "some updated user"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, chart_manager: chart_manager} do
      conn = put(conn, Routes.chart_manager_path(conn, :update, chart_manager), chart_manager: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete chart_manager" do
    setup [:create_chart_manager]

    test "deletes chosen chart_manager", %{conn: conn, chart_manager: chart_manager} do
      conn = delete(conn, Routes.chart_manager_path(conn, :delete, chart_manager))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.chart_manager_path(conn, :show, chart_manager))
      end
    end
  end

  defp create_chart_manager(_) do
    chart_manager = fixture(:chart_manager)
    %{chart_manager: chart_manager}
  end
end
