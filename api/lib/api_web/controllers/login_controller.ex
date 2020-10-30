defmodule ApiWeb.LoginController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias Api.Accounts.Login
  alias Api.Repo
  alias Api.Accounts.User
  import Ecto.Query

  action_fallback ApiWeb.FallbackController

  def login(conn, params) do
    if params["email"] != nil and params["password"] != nil do
      where = [email: params["email"]]
      select = [:email, :password, :id, :role]
      query = from User, where: ^where, select: ^select

      user = Repo.one(query)
      if user do
        password = :crypto.hash(:sha256, params["password"])
        |> Base.encode16()
        |> String.downcase()
        if user.password == password do
          if System.get_env("token") == nil do
            token = Api.JWTHandle.createJWT(%{"role" => user.role, "user_id" => user.id, "csrf" => get_csrf_token()})
            conn
            |> put_status(200)
            |> json(%{"token" => token, "user" => user.id, "role" => user.role})
          else
            token = Api.JWTHandle.createJWT(%{"role" => user.role, "user_id" => user.id, "csrf" => get_csrf_token()})
            conn
            |> put_status(200)
            |> json(%{"token" => token, "user" => user.id, "role" => user.role})
          end
        else
          conn
          |> put_status(404)
          |> json(%{"errors" => "{'credentials': ['wrong email/password']}"})
        end
      else
        conn
        |> put_status(404)
        |> json(%{"errors" => "{'credentials': ['wrong email/password']}"})
      end
    else
      conn
      |> put_status(401)
      |> json(%{"errors" => "{'params': ['missing parameter']}"})
    end
  end
end
