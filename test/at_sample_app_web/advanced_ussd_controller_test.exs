defmodule AtSampleAppWeb.AdvancedUssdControllerTest do
  @moduledoc false

  use ExUnit.Case
  use Plug.Test
  alias AtSampleApp.Router

  doctest AtSampleApp.Ussd.AdvancedUssdController

  @opts Router.init([])

  @ussd_url "/ussd/advanced"

  describe "at_ussd/2" do
    test "ussd for initial ussd request" do
      conn =
        conn(:post, @ussd_url, %{"phoneNumber" => "254724540000", "text" => ""})
        |> Router.call(@opts)

      {status, _headers, body} = Plug.Test.sent_resp(conn)

      assert body =~
               "CON Welcome to My App\n1. Create a new account\n2. Services\n3. About\n4. Exit"

      assert status === 200
    end

    test "ussd for response when user selects option 2, Services" do
      conn =
        conn(:post, @ussd_url, %{"phoneNumber" => "254724540000", "text" => "2"})
        |> Router.call(@opts)

      {_status, _headers, body} = Plug.Test.sent_resp(conn)

      assert body =~
               "CON What we offer\n1. KRA Pins Gen\n2. HELB Registration\n3. E-Citizen Services\n4. Driving Licence Registration\n5. Next Page\n0. Back"
    end

    test "ussd for response when user selects option 2*5, Next Page" do
      conn =
        conn(:post, @ussd_url, %{"phoneNumber" => "254724540000", "text" => "2*5"})
        |> Router.call(@opts)

      {_status, _headers, body} = Plug.Test.sent_resp(conn)

      assert body =~
               "CON What we offer\n6. Browsing Services\n7. Printing Services\n8. Mem Loading :)\n0. Back"
    end

    test "ussd for response when user selects option 2*5*0, Back Option" do
      conn =
        conn(:post, @ussd_url, %{"phoneNumber" => "254724540000", "text" => "2*5*0"})
        |> Router.call(@opts)

      {_status, _headers, body} = Plug.Test.sent_resp(conn)

      assert body =~
               "CON What we offer\n1. KRA Pins Gen\n2. HELB Registration\n3. E-Citizen Services\n4. Driving Licence Registration\n5. Next Page\n0. Back"
    end

    test "ussd for response when user selects option 7, Invalid Option" do
      conn =
        conn(:post, @ussd_url, %{"phoneNumber" => "254724540000", "text" => "7"})
        |> Router.call(@opts)

      {_status, _headers, body} = Plug.Test.sent_resp(conn)

      assert body =~
               "END My App\nOops, Invalid Option !"
    end

    test "ussd for response when user register, 1*ManuEl*1234*1234" do
      conn =
        conn(:post, @ussd_url, %{"phoneNumber" => "254724540000", "text" => "1*ManuEl*1234*1234"})
        |> Router.call(@opts)

      {_status, _headers, body} = Plug.Test.sent_resp(conn)

      assert body =~
               "END Welcome to My App\nAccoutn Details\nName: ManuEl\nPhone No: 0724540000"
    end

    test "ussd for response when user register, with PIN not matching 1*ManuEl*1234*1934" do
      conn =
        conn(:post, @ussd_url, %{"phoneNumber" => "254724540000", "text" => "1*ManuEl*134*1234"})
        |> Router.call(@opts)

      {_status, _headers, body} = Plug.Test.sent_resp(conn)

      assert body =~
               "END Welcome to My App\nPin and conrimation pin not matching"
    end
  end
end
