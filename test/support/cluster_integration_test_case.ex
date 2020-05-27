defmodule Elastic.ClusterIntegrationTestCase do
  use ExUnit.CaseTemplate

  setup tags do
    Elastic.Index.delete("answer", :c1)
    Elastic.Index.delete("existence", :c1)
    Elastic.Index.refresh("answer", :c1)

    Elastic.Index.create("answer", %{}, :c1)
    Elastic.Index.create("existence", %{}, :c1)

    {:ok, tags}
  end
end
