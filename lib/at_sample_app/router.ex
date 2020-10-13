defmodule AtSampleApp.Router do
  use AtSampleAppWeb, :router

  get "/" do
    AtSampleApp.HomeController.index(conn)
  end

  get "/contact" do
    AtSampleApp.ContactController.contact(conn)
  end

  post "/ussd/simple" do
    AtSampleApp.Ussd.SimpleUssdController.ussd(conn, conn.params)
  end

  post "/ussd/advanced" do
    AtSampleApp.Ussd.AdvancedUssdController.at_ussd(conn, conn.params)
  end

  post "/mpesa" do
    IO.inspect(conn)
  end

  match _ do
    send_resp(conn, 404, "Oh no! What you seek cannot be found.")
  end
end
