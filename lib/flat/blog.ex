defmodule Flat.Blog do
  alias Flat.Blog.Post

  defmodule NotFoundError do
    defexception [:message, plug_status: 404]
  end

  for app <- [:earmark, :yaml_front_matter] do
    Application.ensure_all_started(app)
  end

  posts_paths = "posts/**/*.md" |> Path.wildcard() |> Enum.sort()

  posts =
    for post_path <- posts_paths do
      @external_resource Path.relative_to_cwd(post_path)
      Post.parse!(post_path)
    end

  @posts Enum.sort_by(posts, & &1.date, {:desc, Date})
  @tags posts |> Enum.flat_map(& &1.tags) |> Enum.uniq() |> Enum.sort()

  @spec list_posts :: [Flat.Blog.Post.t()]
  def list_posts, do: @posts

  @spec list_posts_by_tag(tag :: String.t()) :: [Flat.Blog.Post.t()]
  def list_posts_by_tag(tag) do
    Enum.filter(list_posts(), &(tag in &1.tags))
  end

  @spec list_tags :: [String.t()]
  def list_tags, do: @tags

  @spec get_post_by_id(id :: String.t()) :: {:ok, Flat.Blog.Post.t()} | {:error, String.t()}
  def get_post_by_id(id) do
    case Enum.find(@posts, nil, fn post -> post.id == id end) do
      nil -> {:error, "not found"}
      found -> {:ok, found}
    end
  end
end
