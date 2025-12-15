defmodule ElixirTodoListWeb.TodoLive do
  use ElixirTodoListWeb, :live_view
  def mount(_P, _S, socket), do: {:ok, socket}
  def render(assigns), do: ~H"<h1>Fase 1: Hello World</h1>"
end
