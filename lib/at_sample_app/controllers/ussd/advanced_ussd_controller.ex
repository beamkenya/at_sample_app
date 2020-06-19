defmodule AtSampleApp.Ussd.AdvancedUssdController do
  @moduledoc false
  use AtSampleAppWeb, :controller

  @invalid_message "My App\nOops, Invalid Option !"
  @about_message "This is a At Sample Ussd App, The App is simple"

  def at_ussd(conn, %{"phoneNumber" => phone, "text" => text} = _params) do
    IO.inspect(text)
    # \*+[a-z0-9_]+\*0
    # ! WIP
    [level: level, data: data, last: last] = process_request(text)

    case level do
      0 ->
        {:ok, response} =
          AtEx.USSD.build_response(app_title(), [
            "Create a new account",
            "Services",
            "About",
            "Exit"
          ])

        text(conn, response)

      1 ->
        try do
          case String.to_integer(last) do
            1 ->
              {:ok, response} =
                AtEx.USSD.build_response(app_title() <> "\nEnter Full Names", :cont)

              text(conn, response)

            2 ->
              {:ok, response} =
                AtEx.USSD.build_response("What we offer", [
                  {1, "KRA Pins Gen"},
                  {2, "HELB Registration"},
                  {3, "E-Citizen Services"},
                  {4, "Driving Licence Registration"},
                  {5, "Next Page"},
                  {0, "Back"}
                ])

              text(conn, response)

            3 ->
              {:ok, response} = AtEx.USSD.build_response(@about_message, :end)
              text(conn, response)

            4 ->
              text(conn, app_exit())

            _ ->
              text(conn, "END " <> @invalid_message)
          end
        rescue
          ArgumentError -> text(conn, "END " <> @invalid_message)
        end

      2 ->
        cond do
          String.match?(last, ~r/[a-zA-z]/) ->
            {:ok, response} =
              AtEx.USSD.build_response(app_title() <> "\nCreate secret PIN (4 digits)", :cont)

            text(conn, response)

          String.match?(last, ~r/[1-4]{1}/) ->
            service =
              cond do
                last === "1" -> "KRA Pins Gen - Ksh. 100"
                last === "2" -> "HELB Registration - Ksh. 150"
                last === "3" -> "E-Citizen Services - Ksh. 100"
                last === "4" -> "Driving Licence Registration - Ksh. 200"
              end

            {:ok, response} = AtEx.USSD.build_response(app_title() <> "\n" <> service, :end)

            text(conn, response)

          last === "5" ->
            {:ok, response} =
              AtEx.USSD.build_response("What we offer", [
                {6, "Browsing Services"},
                {7, "Printing Services"},
                {8, "Mem Loading :)"},
                {0, "Back"}
              ])

            text(conn, response)

          true ->
            text(conn, "END " <> @invalid_message)
        end

      3 ->
        cond do
          String.match?(last, ~r/[0-9]{4}/) ->
            {:ok, response} =
              AtEx.USSD.build_response(app_title() <> "\nRepeat secret PIN", :cont)

            text(conn, response)

          String.match?(last, ~r/[6-8]{1}/) ->
            service =
              cond do
                last === "6" -> "Browsing Services - Ksh. 1/Min"
                last === "7" -> "Printing Services - Ksh. 1/Page"
                last === "8" -> "Mem Loading :) - Ksh. 10/Song"
              end

            {:ok, response} = AtEx.USSD.build_response(app_title() <> "\n" <> service, :end)

            text(conn, response)

          true ->
            text(conn, "END " <> @invalid_message)
        end

      4 ->
        %{2 => name, 3 => pin, 4 => pin_confirmation} = data
        phone_no = "0" <> String.slice(phone, -9, 9)

        message =
          if pin === pin_confirmation do
            "Accoutn Details\nName: #{name}\nPhone No: #{phone_no}"
          else
            "Pin and conrimation pin not matching"
          end

        {:ok, response} = AtEx.USSD.build_response(app_title() <> "\n" <> message, :end)

        text(conn, response)

      _ ->
        {:ok, response} = AtEx.USSD.build_response(@invalid_message, :end)
        text(conn, response)
    end
  end

  @doc """
  This functions processes the text from Africalstalking to determine the level the ussd is at, the data included in the string and the last text entered by the user

  It takes in the `text` from the USSD params

  ## Example
      iex> AtSampleApp.Ussd.AdvancedUssdController.process_request("1*2*My Name*1")
      [level: 4, data: %{1 => "1", 2 => "2", 3 => "My Name", 4 => "1"}, last: "1"]

  """
  @spec process_request(String.t()) :: list()
  def process_request(text) do
    text = check_for_back(text)
    IO.inspect(text)

    case text !== "" do
      true ->
        if String.contains?(text, "*") do
          list = String.split(text, "*", trim: true)

          [
            level: length(list),
            data: 1..length(list) |> Stream.zip(list) |> Enum.into(%{}),
            last: List.last(list)
          ]
        else
          [level: 1, data: %{1 => text}, last: text]
        end

      false ->
        [level: 0, data: %{}, last: '']
    end
  end

  @doc """
  This functions processes the text to check if the navigation need to go back, the regex checkd for 0 as the back navigation key

  It takes in the `text` from the USSD params

  ## Example
      iex> AtSampleApp.Ussd.AdvancedUssdController.check_for_back(1*2*0*23*5gt*0*4)
      "1*23*4"

  """
  @spec check_for_back(String.t()) :: String.t()
  def check_for_back(text) do
    text
    |> String.replace(~r/\*+[a-z0-9_]+\*0/, "")
    |> String.replace(~r/[a-z0-9_]+\*0/, "")
  end

  defp app_title, do: "Welcome to My App"

  def app_exit do
    {:ok, response} = AtEx.USSD.build_response("Thanks for using My App", :end)
    response
  end
end
