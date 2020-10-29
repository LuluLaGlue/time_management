defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug CORSPlug, origin: ["*"]
    plug :accepts, ["json"]
  end

  scope "/api", ApiWeb do
    pipe_through :api

    # Users
    get "/users", UserController, :index
    post "/users", UserController, :create
    get "/users/:userID", UserController, :show
    put "/users/:userID", UserController, :update
    delete "/users/:userID", UserController, :delete
    post "/login", LoginController, :login
    post "/logout", LoginController, :logout

    # Worktimes
    get "/workingtimes/:userID", WorkingTimeController, :index
    get "/workingtimes/:userID/:workingtimeID", WorkingTimeController, :show
    post "/workingtimes/:userID", WorkingTimeController, :create
    put "/workingtimes/:id", WorkingTimeController, :change
    delete "/workingtimes/:id", WorkingTimeController, :delete

    # Clocking
    get "/clocks/:userID", ClockController, :read
    post "/clocks/:userID", ClockController, :create

    # Charts
    get "/charts/:userID", ChartController, :index
    get "/charts/:userID/:chartID", ChartController, :show
    post "/charts", ChartController, :create
    put "/charts/:userID", ChartController, :change
  end
end
