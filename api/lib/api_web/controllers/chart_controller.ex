defmodule ApiWeb.ChartController do
  use ApiWeb, :controller

  alias Api.Data
  alias Api.Data.Chart
  alias Api.Accounts.User
  import Ecto.Query
  alias Api.Repo

  action_fallback ApiWeb.FallbackController

  def index(conn, %{"userID" => id}) do
    token_user = get_req_header(conn, "authorization") |> List.first
    {:ok, res} = Api.JWTHandle.decodeJWT(get_req_header(conn, "authorization") |> List.first)
    if token_user == to_string(res.user_id) do
      if to_string(res.user_id) == id or res.role > 1 do
        if id != "all" do
          where = [id: id]
          select = [:id]
          query = from User, where: ^where, select: ^select

          user = Repo.one(query)

          if user == nil do
            conn
            |> put_status(404)
            |> json(%{"errors" => "{'credentials': ['user not found']}"})
          else
            charts = Data.list_charts(%{"userID" => id})
            render(conn, "index.json", charts: charts)
          end
        else
          chart = Repo.all(Chart)
          |> Enum.map(&%{line: &1.line, bar: &1.bar, id: &1.id, donut: &1.donut, user_id: &1.user_id})

          if chart == [] do
            conn
            |> put_status(404)
            |> json(%{"error" => "{'credentials': ['chart not found']}"})
          end

          conn
          |>put_status(200)
          |> json(chart)
        end
      else
        conn
        |> put_status(404)
        |> json(%{"error" => "{'credentials': ['unauthorized']"})
      end
    else
      conn
      |> put_status(404)
      |> json(%{"error" => "{'credentials': ['unauthorized']"})
    end
  end

  def create(conn, params) do
    token_user = get_req_header(conn, "authorization") |> List.first
    {:ok, res} = Api.JWTHandle.decodeJWT(get_req_header(conn, "authorization") |> List.first)
    if token_user == to_string(res.user_id) and res.role > 1 do
      if params["userID"] != nil and params["line"] != nil and params["bar"] != nil and params["donut"] != nil do
        user = Repo.get(User, params["userID"])

        if user do
          changeset =
            Chart.changeset(%Chart{}, %{"line" => params["line"], "bar" => params["bar"], "donut" => params["donut"], "user_id" => params["userID"]})

          case Repo.insert(changeset) do
            {:ok, _workingtimes} ->
              json(conn |> put_status(:created), %{success: "Created"})

            {:error, changeset} ->
              errors = "#{inspect(changeset.errors)}" |> String.replace("[", "(") |> String.replace("]", ")") |> String.replace("{", "[") |> String.replace("}", "]") |> String.replace("(", "{") |> String.replace(")", "}") |> String.replace(" :", " ")

              json(conn |> put_status(:bad_request), %{errors: errors})
          end
        else
          conn
          |> put_status(404)
          |> json(%{"errors" => "{'credentials': ['user not found']}"})
        end
      else
        conn
        |> put_status(400)
        |> json(%{"errors" => "{'params': ['missing parameter']}"})
      end
    else
      conn
      |> put_status(401)
      |>json(%{"errors" => "{'credentials': ['unauthorized']}"})
    end
  end

  def show(conn, %{"userID" => id, "chartID" => chartID}) do
    token_user = get_req_header(conn, "authorization") |> List.first
    {:ok, res} = Api.JWTHandle.decodeJWT(get_req_header(conn, "authorization") |> List.first)
    if token_user == to_string(res.user_id) do
      if to_string(res.user_id) == id or res.role > 1 do
        where = [user_id: id, id: chartID]
        select = [:line, :bar, :donut, :user_id, :id]
        query = from Chart, where: ^where, select: ^select

        chart = Repo.one(query)

        if chart == nil do
          conn
          |> put_status(404)
          |> json(%{"errors" => "{'credentials': ['working times not found']}"})
        else
          chart = Data.get_chart!(%{"userID" => id, "chartID" => chartID})
          render(conn, "show.json", chart: chart)
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

  def change(conn, params) do
    token_user = get_req_header(conn, "authorization") |> List.first
    {:ok, res} = Api.JWTHandle.decodeJWT(get_req_header(conn, "authorization") |> List.first)
    if token_user == to_string(res.user_id) do
      where = [user_id: params["userID"]]
      select = [:line, :bar, :donut, :user_id, :id]
      query = from Chart, where: ^where, select: ^select

      user = Repo.one(query)
      chart = Repo.get(Chart, user.id)
      if chart do
        changeset = Chart.changeset(chart, params)
        case Repo.update(changeset) do
          {:ok, chart} ->
            conn
            |> put_status(200)
            |>json(%{"Response" => "Updated", "line" => params["line"], "bar" => params["bar"], "donut" => params["donut"]})
          {:error, result} ->
            conn
            |> put_status(404)
            |> json(%{"errors" => "{'credentials': ['chart not found']}"})
        end
      end
    else
      conn
      |> put_status(401)
      |> json(%{"errors" => "{'credentials': ['unauthorized']}"})
    end
  end
end
