defmodule AtSampleApp.Ussd.AdvancedUssdController do
  @moduledoc false
  use AtSampleAppWeb, :controller

  @invalid_message "Oops, Invalid Option !"

  def at_ussd(conn, %{"phoneNumber" => _phone, "text" => text} = _params) do
    # \*+[a-z0-9_]+\*0
    # ! WIP
    [level: level, data: _data, last: _last] = process_request(text)
    text(conn, 'WIP')

    case level do
      1 ->
        text(conn, level)

      2 ->
        text(conn, level)

      _ ->
        text(conn, AtEx.USSD.build_response(@invalid_message, :end))
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

  defp app_title, do: "Welcome to My App"

  defp app_exit, do: "Thanks for using My App"
  defp welcome_message, do: "Welcome to My App, Thanks for using My App"

  defp get_user(phone) do
    Accounts.get_by(%{"phone" => phone})
  end
end
