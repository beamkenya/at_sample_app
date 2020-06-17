defmodule AtSampleApp.Ussd.SimpleUssdController do
  @moduledoc false
  use AtSampleAppWeb, :controller

  def ussd(conn, %{"phoneNumber" => phone, "text" => text} = _params) do
    case text do
      "" ->
        {:ok, response} =
          AtEx.USSD.build_response("Welcome to My Hotel", ["View Menu", "Phone Number", "Exit"])

        text(
          conn,
          response
        )

      "1" ->
        {:ok, response} =
          AtEx.USSD.build_response(["Chips & Sausage", "Burger & Chips", "Rice & beans"])

        text(conn, response)

      "2" ->
        {:ok, response} = AtEx.USSD.build_response("Phone No: " <> phone)
        text(conn, response)

      "3" ->
        {:ok, response} = AtEx.USSD.build_response("Thank you for visiting", :end)
        text(conn, response)

      "1*1" ->
        {:ok, response} =
          AtEx.USSD.build_response("Chips & Sausage", [
            {1, "Chips Masala - Ksh 180"},
            {2, "Chips Plain - Ksh 100"},
            {3, "Smokies - Ksh 30"}
          ])

        text(conn, response)

      "1*2" ->
        {:ok, response} =
          AtEx.USSD.build_response("Burger & Chips", [
            "Burger & Chips - Ksh 320",
            "Burger & Chips - Ksh 500"
          ])

        text(conn, response)

      "1*3" ->
        {:ok, response} = AtEx.USSD.build_response("Rice & beans are awesome")

        text(conn, response)

      "1*1*1" ->
        {:ok, response} = AtEx.USSD.build_response("Chips Masala - Ksh 180 \nawessome meal")
        text(conn, response)

      "1*1*2" ->
        {:ok, response} = AtEx.USSD.build_response("Chips Plain - Ksh 100 \nawessome ")
        text(conn, response)

      "1*1*3" ->
        {:ok, response} = AtEx.USSD.build_response("Smokies - Ksh 30 ")
        text(conn, response)

      _ ->
        {:ok, response} = AtEx.USSD.build_response("Oops ! Invalid option")
        text(conn, response)
    end
  end

  def ussd(conn, _params) do
    text(conn, "END AN Error Ocuured in response !")
  end
end
