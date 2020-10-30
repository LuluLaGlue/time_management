defmodule ApiWeb.ClockController do
  use ApiWeb, :controller

  alias Api.Time
  alias Api.Time.Clock
  alias Api.Repo
  alias Api.Accounts.User
  import Ecto.Query

  action_fallback ApiWeb.FallbackController

  def read(conn, %{"userID" => userID}) do
    token_user = get_req_header(conn, "authorization") |> List.first
    {:ok, res} = Api.JWTHandle.decodeJWT(get_req_header(conn, "authorization") |> List.first)
    if token_user == to_string(res.user_id) do
      if to_string(res.user_id) == userID or res.role > 1 do
        if userID != "all" do
          where = [id: userID]
          select = [:id]
          query = from User, where: ^where, select: ^select
          user = Repo.one(query)
          if user != nil do
            clock = Time.list_clocks(%{"userID" => userID})
            if clock == [] do
              conn
              |> put_status(404)
              |> json(%{"errors" => "{'credentials': ['no clocks for selected user']}"})
            else
              render(conn, "index.json", clocks: clock)
            end
            conn
            |> put_status(401)
            |> json(%{"id" => userID})
          else
            conn
            |> put_status(404)
            |> json(%{"error" => "{'credentials' : ['no user found']}"})
          end
        else
          clock = Repo.all(Clock)
          |> Enum.map(&%{time: &1.time, user: &1.user, status: &1.status})
          if clock == [] do
            conn
            |> put_status(404)
            |> json(%{"error" => "{'credentials': ['clock not found']}"})
          end
          conn
          |>put_status(200)
          |> json(clock)
        end
      else
        conn
        |> put_status(404)
        |> json(%{"error" => "{'credentials': ['unauthorized'}]"})
      end
    else
      conn
      |> put_status(404)
      |> json(%{"error" => "{'credentials': ['unauthorized'}]"})
    end
  end

  def create(conn, %{"userID" => userID}) do
    token_user = get_req_header(conn, "authorization") |> List.first
    {:ok, res} = Api.JWTHandle.decodeJWT(get_req_header(conn, "authorization") |> List.first)
    if token_user == to_string(res.user_id) do
      if to_string(res.user_id) == userID or res.role == 3 do
        count = Repo.all(from u in "clocks", select: fragment("count(*)"))
        id = List.first(count)
        user_tmp = Repo.get_by(User, [id: userID])
        clock = Time.list_clocks(%{"userID" => userID})
        |> Enum.map(&%{time: &1.time, user: &1.user, status: &1.status})
        if user_tmp do
            date = NaiveDateTime.utc_now()
            if clock != [] do
              status = !List.last(clock).status
              changeset = Clock.changeset(%Clock{}, %{"id" => id, "status" => status, "time" => date, "user" => userID})
              case Repo.insert(changeset) do
                {:ok, _user} ->
                  json(conn |> put_status(:created), %{success: "Created", status: status})
                {:error, changeset} ->
                  errors = "#{inspect(changeset.errors)}" |> String.replace("[", "(") |> String.replace("]", ")") |> String.replace("{", "[") |> String.replace("}", "]") |> String.replace("(", "{") |> String.replace(")", "}") |> String.replace(" :", " ")
                  json(conn |> put_status(:bad_request), %{errors: errors})
              end
            else
              changeset = Clock.changeset(%Clock{}, %{"id" => id, "status" => true, "time" => date, "user" => userID})
              case Repo.insert(changeset) do
                {:ok, _user} ->
                  json(conn |> put_status(:created), %{success: "Created", status: true})
                {:error, changeset} ->
                  errors = "#{inspect(changeset.errors)}" |> String.replace("[", "(") |> String.replace("]", ")") |> String.replace("{", "[") |> String.replace("}", "]") |> String.replace("(", "{") |> String.replace(")", "}") |> String.replace(" :", " ")
                  json(conn |> put_status(:bad_request), %{errors: errors})
              end
            end
        else
          conn
          |> put_status(404)
          |> json(%{"errors" => "{'credentials': ['no user found']}"})
        end
      else
        conn
        |> put_status(404)
        |> json(%{"error" => "{'credentials': ['unauthorized'}]"})
      end
    else
      conn
      |> put_status(404)
      |> json(%{"error" => "{'credentials': ['unauthorized'}]"})
    end
  end

  def show(conn, %{"id" => id}) do
    clock = Time.get_clock!(id)
    render(conn, "show.json", clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Time.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Time.update_clock(clock, clock_params) do
      render(conn, "show.json", clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Time.get_clock!(id)

    with {:ok, %Clock{}} <- Time.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
