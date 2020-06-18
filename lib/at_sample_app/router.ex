defmodule AtSampleApp.Router do
  use AtSampleAppWeb, :router

  get "/contact" do
    AtSampleApp.ContactController.contact(conn)
  end

  match _ do
    send_resp(conn, 404, "Oh no! What you seek cannot be found.")
  end
end
