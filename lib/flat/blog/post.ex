defmodule Flat.Blog.Post do
  @enforce_keys [:id, :author, :title, :body, :description, :tags, :date]
  defstruct [:id, :author, :title, :body, :description, :tags, :date]

  @type t :: %__MODULE__{}

  @spec parse!(filename :: String.t()) :: t()
  def parse!(filename) do
    # Get the last two path segments from the filename
    [year, month_day_id] = filename |> Path.split() |> Enum.take(-2)

    # Then extract the month, day and id from the filename itself
    [month, day, id_with_md] = String.split(month_day_id, "-", parts: 3)

    # Remove .md extension from id
    id = Path.rootname(id_with_md)

    # Build a Date struct from the path information
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")

    # Get all attributes from YAML front-matter
    {:ok, attrs, body} = YamlFrontMatter.parse_file(filename)

    %__MODULE__{
      id: id,
      date: date,
      author: Map.get(attrs, "author"),
      title: Map.get(attrs, "title"),
      body: Earmark.as_html!(body),
      description: Map.get(attrs, "description"),
      tags: Map.get(attrs, "tags", [])
    }
    |> IO.inspect()
  end
end
