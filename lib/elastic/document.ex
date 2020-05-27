defmodule Elastic.Document do
  @moduledoc false

  alias Elastic.HTTP
  alias Elastic.Index

  def index(index, type, id, data, cluster \\ nil) do
    document_path(index, type, id) |> HTTP.put(body: data, cluster: cluster)
  end

  def update(index, type, id, data, cluster \\ nil) do
    data = %{doc: data}

    update_path(index, type, id)
    |> HTTP.post(body: data, cluster: cluster)
  end

  def get(index, type, id, cluster \\ nil) do
    document_path(index, type, id) |> HTTP.get(cluster: cluster)
  end

  def delete(index, type, id, cluster \\ nil) do
    document_path(index, type, id) |> HTTP.delete(cluster: cluster)
  end

  defp document_path(index, type, id) do
    "#{index_name(index)}/#{type}/#{id}"
  end

  def update_path(index, type, id) do
    document_path(index, type, id) <> "/_update"
  end

  defp index_name(index) do
    Index.name(index)
  end
end
