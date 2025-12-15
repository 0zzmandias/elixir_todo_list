defmodule ElixirTodoListWeb.TodoLive do
  use ElixirTodoListWeb, :live_view
  alias ElixirTodoList.{Repo, Task}
  import Ecto.Query

  def mount(_params, _session, socket) do
    tasks = Repo.all(from t in Task, order_by: [desc: t.inserted_at])

    socket =
      socket
      |> assign(:tasks, tasks)
      |> assign(:form, to_form(Task.changeset(%Task{}, %{})))

    {:ok, socket}
  end

  # FASE 6: Validação em tempo real (necessário para limpar o input depois)
  def handle_event("validate", %{"task" => params}, socket) do
    changeset = Task.changeset(%Task{}, params)
    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"task" => params}, socket) do
    case %Task{} |> Task.changeset(params) |> Repo.insert() do
      {:ok, _task} ->
        tasks = Repo.all(from t in Task, order_by: [desc: t.inserted_at])

        # Cria um changeset VAZIO para limpar o campo
        changeset = Task.changeset(%Task{}, %{})

        {:noreply, assign(socket, tasks: tasks, form: to_form(changeset))}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    Task |> Repo.get(id) |> Repo.delete()
    tasks = Repo.all(from t in Task, order_by: [desc: t.inserted_at])
    {:noreply, assign(socket, tasks: tasks)}
  end

  # FASE 6: Toggle (Concluir tarefa)
  def handle_event("toggle", %{"id" => id}, socket) do
    task = Repo.get(Task, id)
    Repo.update(Task.changeset(task, %{completed: !task.completed}))

    tasks = Repo.all(from t in Task, order_by: [desc: t.inserted_at])
    {:noreply, assign(socket, tasks: tasks)}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-100 flex justify-center items-start pt-16 px-4 font-sans">
      <div class="w-full max-w-lg bg-white rounded-xl shadow-2xl overflow-hidden border border-gray-200">
        <div class="p-8">
          <h2 class="text-3xl font-bold text-center text-gray-800 mb-8">Lista de Tarefas</h2>

          <.form for={@form} phx-submit="save" phx-change="validate" class="flex gap-3 mb-8">
            <div class="flex-grow">
              <input
                type="text"
                name={@form[:title].name}
                id={@form[:title].id}
                value={@form[:title].value}
                placeholder="O que vamos fazer hoje?"
                class="w-full h-12 px-4 rounded-lg border-2 border-gray-300 focus:border-blue-500 focus:outline-none text-black bg-white placeholder-gray-400 transition-colors"
                autocomplete="off"
              />
            </div>

            <button class="h-12 px-6 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-lg shadow transition-transform active:scale-95 flex items-center justify-center">
              Adicionar
            </button>
          </.form>

          <ul class="flex flex-col gap-3">
            <%= for task <- @tasks do %>
              <li class="flex items-center justify-between p-4 bg-gray-50 border border-gray-200 rounded-lg hover:bg-gray-100 transition-all group">
                <div
                  class="flex items-center gap-4 cursor-pointer flex-grow"
                  phx-click="toggle"
                  phx-value-id={task.id}
                >
                  <div class={"w-6 h-6 rounded border-2 flex items-center justify-center transition-colors " <>
                    (if task.completed, do: "bg-blue-500 border-blue-500", else: "border-gray-400 bg-white")}>
                    <%= if task.completed do %>
                      <svg
                        class="w-4 h-4 text-white"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="3"
                          d="M5 13l4 4L19 7"
                        >
                        </path>
                      </svg>
                    <% end %>
                  </div>

                  <span class={"text-lg " <> (if task.completed, do: "line-through text-gray-400", else: "text-gray-900 font-medium")}>
                    {task.title}
                  </span>
                </div>

                <button
                  phx-click="delete"
                  phx-value-id={task.id}
                  class="text-gray-400 hover:text-red-600 p-2 rounded-full hover:bg-red-50 transition-colors"
                  title="Excluir"
                >
                  <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                    >
                    </path>
                  </svg>
                </button>
              </li>
            <% end %>
          </ul>

          <%= if Enum.empty?(@tasks) do %>
            <div class="text-center py-10 mt-4 border-2 border-dashed border-gray-200 rounded-lg">
              <p class="text-gray-500">Sua lista está vazia.</p>
              <p class="text-gray-400 text-sm mt-1">Adicione uma tarefa acima para começar!</p>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
