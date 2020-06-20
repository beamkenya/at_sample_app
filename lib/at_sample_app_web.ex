defmodule AtSampleAppWeb do
  @moduledoc false

  def controller do
    quote do
      import Plug.Conn

      @template_dir "lib/at_sample_app/templates"

      defp render(%{status: status} = conn, template, assigns \\ []) do
        body =
          @template_dir
          |> Path.join(template)
          |> String.replace_suffix(".html", ".html.eex")
          |> EEx.eval_file(assigns)

        send_resp(conn, status || 200, body)
      end

      defp text(%{status: status} = conn, body, assigns \\ []) do
        send_resp(conn, status || 200, body)
      end
    end
  end

  def router do
    quote do
      use Plug.Router

      plug(Plug.Parsers,
        parsers: [:json, :urlencoded],
        pass: ["text/*", "application/*"],
        json_decoder: Jason
      )

      plug(:match)
      plug(:dispatch)
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
