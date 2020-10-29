defmodule ApiWeb.ClockControllerTest do
  use ApiWeb.ConnCase

  alias Api.Time
  alias Api.Time.Clock

  @create_attrs %{
    status: true,
    time: ~N[2010-04-17 14:00:00],
    user: "some user"
  }
  @update_attrs %{
    status: false,
    time: ~N[2011-05-18 15:01:01],
    user: "some updated user"
  }
  @invalid_attrs %{status: nil, time: nil, user: nil}

  def fixture(:clock) do
    {:ok, clock} = Time.create_clock(@create_attrs)
    clock
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all clocks", %{conn: conn} do
      conn = get(conn, "/api/clocks/all")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create clock" do
    test "renders clock when data is valid", %{conn: conn} do
      conn = post(conn, "/api/clocks/1", clock: @create_attrs)
      assert %{"id" => id} = json_response(conn, 404)["data"]

      conn = get(conn, Routes.clock_path(conn, :show, id))

      assert %{
               "id" => id,
               "status" => true,
               "time" => "2010-04-17T14:00:00",
               "user" => "some user"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, "/api/clocks/1", clock: @invalid_attrs)
      assert json_response(conn, 404)["errors"] != %{}
    end
  end

  # describe "update clock" do
  #   setup [:create_clock]

  #   test "renders clock when data is valid", %{conn: conn, clock: %Clock{id: id} = clock} do
  #     conn = put(conn, Routes.clock_path(conn, :update, clock), clock: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get(conn, Routes.clock_path(conn, :show, id))

  #     assert %{
  #              "id" => id,
  #              "status" => false,
  #              "time" => "2011-05-18T15:01:01",
  #              "user" => "some updated user"
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, clock: clock} do
  #     conn = put(conn, Routes.clock_path(conn, :update, clock), clock: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete clock" do
  #   setup [:create_clock]

  #   test "deletes chosen clock", %{conn: conn, clock: clock} do
  #     conn = delete(conn, Routes.clock_path(conn, :delete, clock))
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.clock_path(conn, :show, clock))
  #     end
  #   end
  # end

  defp create_clock(_) do
    clock = fixture(:clock)
    %{clock: clock}
  end
end
