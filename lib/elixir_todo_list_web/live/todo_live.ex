defmodule ElixirTodoListWeb.TodoLive do
  use ElixirTodoListWeb, :live_view

  def mount(_P, _S, socket),
    do: {:ok, assign(socket, tasks: [%{title: "Tarefa 1"}, %{title: "Tarefa 2"}])}

  def render(assigns) do
    ~H"""
    <ul>
      <%= for t <- @tasks do %>
        <li>{t.title}</li>
      <% end %>
    </ul>
    """
  end
end
