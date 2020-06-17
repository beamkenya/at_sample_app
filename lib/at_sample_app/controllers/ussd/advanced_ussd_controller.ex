defmodule AtSampleApp.Ussd.AdvancedUssdController do
  @moduledoc false
  use AtSampleAppWeb, :controller

  def at_ussd(conn, %{"phoneNumber" => _phone, "text" => _text} = _params) do
    # ! WIP
    text(conn, 'WIP')
  end
end
