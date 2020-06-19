defmodule AtSampleApp.HomeController do
  @moduledoc false
  use AtSampleAppWeb, :controller

  def index(conn) do
    render(conn, "index.html")
  end
end
