defmodule Elastic.Document.ClusterBulkTest do
  use Elastic.ClusterIntegrationTestCase

  @tag integration: true
  test "bulk creates answers with ids" do
    Elastic.Bulk.create([
      {index(), "answer", 1, %{text: "this is an answer"}},
      {index(), "answer", 2, %{text: "and this is one too"}}
    ], :c1)

    answer = Answer.get(1, "answer", :c1)
    assert answer == %Answer{id: "1", text: "this is an answer"}
    assert Answer.get(2, "answer", :c1)
  end

  @tag integration: true
  test "bulk indexes answers without ids" do
    {:ok, 200, _} =
      Elastic.Bulk.index([
        {index(), "answer", nil, %{text: "hello world"}},
        {index(), "answer", nil, %{text: "world hello"}}
      ], :c1)

    Elastic.Index.refresh("answer", :c1)

    answers =
      Answer.search(%{
        query: %{
          match: %{text: "world"}
        }
      }, "answer", :c1)

    assert Enum.count(answers) == 2
  end

  @tag integration: true
  test "bulk creates answers with IDs" do
    {:ok, 200, _} =
      Elastic.Bulk.create([
        {index(), "answer", 1, %{text: "hello world"}},
        {index(), "answer", 2, %{text: "world hello"}}
      ], :c1)

    Elastic.Index.refresh("answer", :c1)

    answers =
      Answer.search(%{
        query: %{
          match: %{text: "world"}
        }
      }, "answer", :c1)

    assert Enum.count(answers) == 2
  end

  @tag integration: true
  test "bulk updates answers with ids" do
    Answer.index(1, %{text: "this is an answer"}, "answer", :c1)

    {:ok, 200, _} =
      Elastic.Bulk.update([
        {index(), "answer", 1, %{comments: 5}}
      ], :c1)

    answer = Answer.get(1, "answer", :c1)
    assert answer == %Answer{id: "1", text: "this is an answer", comments: 5}
  end

  def index do
    Elastic.Index.name("answer")
  end
end
