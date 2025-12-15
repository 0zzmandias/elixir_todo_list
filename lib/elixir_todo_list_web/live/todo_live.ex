defmodule ElixirTodoListWeb.TodoLive do
  use ElixirTodoListWeb, :live_view
  alias ElixirTodoList.{Repo, Task}
  import Ecto.Query

  def mount(_params, _session, socket) do
    # Carrega as tarefas do banco
    tasks = Repo.all(from t in Task, order_by: [desc: t.inserted_at])
    {:ok, assign(socket, tasks: tasks, form: to_form(Task.changeset(%Task{}, %{})))}
  end

  def handle_event("save", %{"task" => params}, socket) do
    # Salva no banco
    %Task{} |> Task.changeset(params) |> Repo.insert()

    # Recarrega a lista
    tasks = Repo.all(from t in Task, order_by: [desc: t.inserted_at])
    {:noreply, assign(socket, tasks: tasks, form: to_form(Task.changeset(%Task{}, %{})))}
  end

  # --- FASE 5: DELETE ---
  def handle_event("delete", %{"id" => id}, socket) do
    # 1. Busca a tarefa pelo ID
    # 2. Deleta do banco
    Task |> Repo.get(id) |> Repo.delete()

    # 3. Atualiza a lista na tela
    tasks = Repo.all(from t in Task, order_by: [desc: t.inserted_at])
    {:noreply, assign(socket, tasks: tasks)}
  end

  def render(assigns) do
    ~H"""
    <h1>Lista de Tarefas (Com Delete)</h1>

    <.form for={@form} phx-submit="save">
      <.input field={@form[:title]} placeholder="Nova tarefa..." />
      <button>Salvar</button>
    </.form>

    <hr />

    <ul>
      <%= for task <- @tasks do %>
        <li style="margin-bottom: 10px;">
          {task.title}

          <button
            phx-click="delete"
            phx-value-id={task.id}
            style="color: red; cursor: pointer; margin-left: 10px;"
          >
            [Excluir]
          </button>
        </li>
      <% end %>
    </ul>
    """
  end
end
