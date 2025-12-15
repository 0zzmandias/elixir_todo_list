defmodule ElixirTodoList.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :title, :string
    field :completed, :boolean, default: false
    timestamps()
  end

  def changeset(t, a), do: cast(t, a, [:title, :completed]) |> validate_required([:title])
end
