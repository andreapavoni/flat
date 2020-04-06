defmodule FlatWeb.BlogController do
  use FlatWeb, :controller

  def list(conn, _) do
    posts = Flat.Blog.list_posts()
    render(conn, "list.html", posts: posts)
  end

  def list_by_tag(conn, %{"tag" => tag}) do
    posts = Flat.Blog.list_posts_by_tag(tag)
    render(conn, "list.html", posts: posts)
  end

  def show(conn, %{"id" => id}) do
    with {:ok, post} <- Flat.Blog.get_post_by_id(id) do
      render(conn, "show.html", post: post)
    end
  end
end
