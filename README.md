# Projeto Elixir Todo List

**Nome do Aluno:** Helton Alves Sá - 2019014022
**Link do Tutorial:** [Tutorial Notion - Prof. Sergio Costa](https://profsergiocosta.notion.site/Como-Criar-um-App-Todo-List-com-Elixir-e-LiveView-do-Zero-2a8cce97509380eba53fc82bbeb08435)

## Descrição Breve

Este projeto consiste numa aplicação de lista de tarefas (To-Do List) desenvolvida como atividade prática para a disciplina. A aplicação permite criar, visualizar, excluir e marcar tarefas como concluídas em tempo real.

O sistema foi construído sobre a plataforma **Elixir** utilizando o framework **Phoenix LiveView** (versão 1.7.14) para interatividade sem necessidade de JavaScript complexo. A persistência de dados é gerida pelo **Ecto** com banco de dados **SQLite3**. A interface visual foi estilizada com **Tailwind CSS** e componentes do **DaisyUI**, garantindo um design moderno, responsivo e adaptável (tema light).

## Instruções de Execução

Para rodar este projeto localmente, certifique-se de ter Elixir e Erlang instalados na sua máquina.

1.  **Instale as dependências do projeto:**
    ```bash
    mix deps.get
    ```

2.  **Configure e migre o banco de dados:**
    ```bash
    mix ecto.setup
    ```

3.  **Inicie o servidor Phoenix:**
    ```bash
    mix phx.server
    ```

4.  **Aceda à aplicação:**
    Abra o seu navegador e visite [`http://localhost:4000`](http://localhost:4000).
