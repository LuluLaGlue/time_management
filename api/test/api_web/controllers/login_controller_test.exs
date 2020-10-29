defmodule ApiWeb.LoginControllerTest do
  use ApiWeb.ConnCase

  alias Api.Accounts
  alias Api.Accounts.Login

  @create_attrs %{
    email: "some email",
    password: "some password"
  }
  @update_attrs %{
    email: "some updated email",
    password: "some updated password"
  }
  @invalid_attrs %{email: nil, password: nil}

  def fixture(:login) do
    {:ok, login} = Accounts.create_login(@create_attrs)
    login
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all login", %{conn: conn} do
      conn = get(conn, Routes.login_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create login" do
    test "renders login when data is valid", %{conn: conn} do
      conn = post(conn, Routes.login_path(conn, :create), login: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.login_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "some email",
               "password" => "some password"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.login_path(conn, :create), login: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update login" do
    setup [:create_login]

    test "renders login when data is valid", %{conn: conn, login: %Login{id: id} = login} do
      conn = put(conn, Routes.login_path(conn, :update, login), login: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.login_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "some updated email",
               "password" => "some updated password"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, login: login} do
      conn = put(conn, Routes.login_path(conn, :update, login), login: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete login" do
    setup [:create_login]

    test "deletes chosen login", %{conn: conn, login: login} do
      conn = delete(conn, Routes.login_path(conn, :delete, login))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.login_path(conn, :show, login))
      end
    end
  end

  defp create_login(_) do
    login = fixture(:login)
    %{login: login}
  end
end
