defmodule ApiWeb.LoginView do
  use ApiWeb, :view
  alias ApiWeb.LoginView

  def render("index.json", %{login: login}) do
    %{data: render_many(login, LoginView, "login.json")}
  end

  def render("show.json", %{login: login}) do
    %{data: render_one(login, LoginView, "login.json")}
  end

  def render("login.json", %{login: login}) do
    %{id: login.id,
      email: login.email,
      password: login.password}
  end
end
