defmodule ApiWeb.WorkingTimeController do
  use ApiWeb, :controller

  alias Api.Time
  alias Api.Time.WorkingTime
  alias Api.Repo
  alias Api.Accounts.User
  import Ecto.Query

  action_fallback ApiWeb.FallbackController

  def index(conn, %{"userID" => id}) do
    token_user = get_req_header(conn, "token")
    token_api = [System.get_env("token")]
    if token_user == token_api do
    # if System.get_env("token") != nil do
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
          workingtimes = Time.list_workingtimes(%{"userID" => id})
          render(conn, "index.json", workingtimes: workingtimes)
        end
      else
        clock = Repo.all(WorkingTime)
        |> Enum.map(&%{start: &1.start, end: &1.end, id: &1.id, user: &1.user})

        if clock == [] do
          conn
          |> put_status(404)
          |> json(%{"error" => "{'credentials': ['working time not found']}"})
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
  end

  def create(conn, params) do
    token_user = get_req_header(conn, "token")
    token_api = [System.get_env("token")]
    if token_user == token_api do
    # if System.get_env("token") != nil do
      if params["userID"] != nil and params["start"] != nil and params["end"] != nil do
        user = Repo.get(User, params["userID"])

        if user do
          changeset =
            WorkingTime.changeset(%WorkingTime{}, %{"start" => params["start"], "end" => params["end"], "user" => params["userID"]})

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
        |> put_status(401)
        |> json(%{"errors" => "{'params': ['missing parameter']}"})
      end
    else
      conn
      |> put_status(404)
      |> json(%{"error" => "{'credentials': ['unauthorized'}]"})
    end
  end

  def show(conn, %{"userID" => id, "workingtimeID" => working_time_id}) do
    token_user = get_req_header(conn, "token")
    token_api = [System.get_env("token")]
    if token_user == token_api do
      # if System.get_env("token") != nil do
        where = [user: id, id: working_time_id]
        select = [:start, :end, :id, :user]
        query = from WorkingTime, where: ^where, select: ^select

        workingtime = Repo.one(query)

        if workingtime == nil do
          conn
          |> put_status(404)
          |> json(%{"errors" => "{'credentials': ['working times not found']}"})
        else
          working_time = Time.get_working_time!(%{"userID" => id, "workingtimeID" => working_time_id})
          render(conn, "show.json", working_time: working_time)
        end
    else
      conn
      |> put_status(404)
      |> json(%{"error" => "{'credentials': ['unauthorized'}]"})
    end
  end

  def change(conn, params) do
    token_user = get_req_header(conn, "token")
    token_api = [System.get_env("token")]
    if token_user == token_api do
    # if System.get_env("token") != nil do
      workingtime = Repo.get(WorkingTime, params["id"])
      if workingtime do
        changeset = WorkingTime.changeset(workingtime, params)
        case Repo.update(changeset) do
          {:ok, workingtime} ->
            conn
            |> put_status(200)
            |>json(%{"Response" => "Updated", "start" => params["start"], "end" => params["end"], "id" => params["id"]})
          {:error, result} ->
            conn
            |> put_status(404)
            |> json(%{"errors" => "{'credentials': ['workingtime not found']}"})
        end
      end
    else
      conn
      |> put_status(404)
      |> json(%{"error" => "{'credentials': ['unauthorized'}]"})
    end
  end

  def delete(conn, %{"id" => id}) do
    token_user = get_req_header(conn, "token")
    token_api = [System.get_env("token")]
    if token_user == token_api do
    # if System.get_env("token") != nil do
      where = [id: id]
      select = [:start, :end, :id]
      query = from WorkingTime, where: ^where, select: ^select

      workingtime = Repo.one(query)

      if workingtime == nil do
        conn
        |> put_status(404)
        |> json(%{"errors" => "{'credentials': ['working times not found']}"})
      else
        workspace = from(x in WorkingTime, where: x.id == ^id) |> Repo.delete_all

        conn
        |> put_status(200)
        |> json(%{"response" => "Deleted"})
      end
    else
      conn
      |> put_status(404)
      |> json(%{"error" => "{'credentials': ['unauthorized'}]"})
    end

  end
end
