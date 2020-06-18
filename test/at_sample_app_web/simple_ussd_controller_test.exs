defmodule AtSampleAppWeb.SimpleUssdControllerTest do
  @moduledoc false
  use ExUnit.Case
  use Plug.Test
  alias AtSampleApp.Router

  @opts Router.init([])

  @ussd_url "/ussd/simple"

  test "ussd POST /ussd/simple for initial ussd request" do
    conn =
      conn(:post, @ussd_url, %{"phoneNumber" => "254724540000", "text" => ""})
      |> Router.call(@opts)

    {status, _headers, body} = Plug.Test.sent_resp(conn)
    assert body =~ "CON Welcome to My Hotel\n1. View Menu\n2. Phone Number\n3. Exit"
    assert status === 200
  end

  test "ussd POST /ussd/simple for resposnse when user slects option 1" do
    conn =
      conn(:post, @ussd_url, %{"phoneNumber" => "254724540000", "text" => "1"})
      |> Router.call(@opts)

    {_status, _headers, body} = Plug.Test.sent_resp(conn)
    assert body =~ "CON 1. Chips & Sausage\n2. Burger & Chips\n3. Rice & beans"
  end

  test "ussd POST /ussd/simple for resposnse when user slects option 1*1" do
    conn =
      conn(:post, @ussd_url, %{"phoneNumber" => "254724540000", "text" => "1*1"})
      |> Router.call(@opts)

    {_status, _headers, body} = Plug.Test.sent_resp(conn)
    assert body =~ "CON Chips & Sausage\n1. Chips Masala - Ksh 180\n2. Chips Plain - Ksh 100\n3. Smokies - Ksh 30"
  end

  test "ussd POST /ussd/simple for resposnse when user slects option 1*2" do
    conn =
      conn(:post, @ussd_url, %{"phoneNumber" => "254724540000", "text" => "1*2"})
      |> Router.call(@opts)

    {_status, _headers, body} = Plug.Test.sent_resp(conn)
    assert body =~ "CON Burger & Chips\n1. Burger & Chips - Ksh 320\n2. Burger & Chips - Ksh 500"
  end

  test "ussd POST /ussd/simple for resposnse when user slects option 1*3" do
    conn =
      conn(:post, @ussd_url, %{"phoneNumber" => "254724540000", "text" => "1*3"})
      |> Router.call(@opts)

    {_status, _headers, body} = Plug.Test.sent_resp(conn)
    assert body =~ "END Rice & beans are awesome"
  end
  
  test "ussd POST /ussd/simple for resposnse when user slects option 2" do
    conn =
      conn(:post, @ussd_url, %{"phoneNumber" => "254724540000", "text" => "2"})
      |> Router.call(@opts)

    {_status, _headers, body} = Plug.Test.sent_resp(conn)
    assert body =~ "END Phone No: 254724540000"
  end
  
  
  test "ussd POST /ussd/simple for resposnse when user slects option 3, ending session" do
    conn =
      conn(:post, @ussd_url, %{"phoneNumber" => "254724540000", "text" => "3"})
      |> Router.call(@opts)

    {_status, _headers, body} = Plug.Test.sent_resp(conn)
    assert body =~ "END Thank you for visiting"
  end

  test "ussd POST /ussd/simple with no body request request" do
    conn =
      conn(:post, @ussd_url, %{})
      |> Router.call(@opts)

    {_status, _headers, body} = Plug.Test.sent_resp(conn)
    assert body =~ "END AN Error Ocuured in response !"
  end
end
