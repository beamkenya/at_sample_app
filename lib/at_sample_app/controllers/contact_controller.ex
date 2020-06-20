defmodule AtSampleApp.ContactController do
  @moduledoc false
  use AtSampleAppWeb, :controller

  def contact(conn) do
    render(conn, "contact.html")
  end
end
