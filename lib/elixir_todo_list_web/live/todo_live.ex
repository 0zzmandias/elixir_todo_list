defmodule ElixirTodoListWeb.TodoLive do
  use ElixirTodoListWeb, :live_view
  alias ElixirTodoList.{Repo, Task}
  import Ecto.Query

  def mount(_P, _S, socket) do
    tasks = Repo.all(from t in Task, order_by: [desc: t.inserted_at])
    {:ok, assign(socket, tasks: tasks, form: to_form(Task.changeset(%Task{}, %{})))}
  end

  def handle_event("save", %{"task" => p}, socket) do
    %Task{} |> Task.changeset(p) |> Repo.insert()
    {:noreply, assign(socket, tasks: Repo.all(from t in Task, order_by: [desc: t.inserted_at]))}
  end

  def render(assigns) do
    ~H"""
    <.form for={@form} phx-submit="save">
      <.input field={@form[:title]} /><button>Salvar</button>
    </.form>
    <ul>
      <%= for t <- @tasks do %>
        <li>{t.title}</li>
      <% end %>
    </ul>
    """
  end
end
