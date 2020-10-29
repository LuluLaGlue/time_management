defmodule Api.DataTest do
  use Api.DataCase

  alias Api.Data

  describe "charts" do
    alias Api.Data.Chart

    @valid_attrs %{bar: true, donut: true, line: true, user_id: "some user_id"}
    @update_attrs %{bar: false, donut: false, line: false, user_id: "some updated user_id"}
    @invalid_attrs %{bar: nil, donut: nil, line: nil, user_id: nil}

    def chart_fixture(attrs \\ %{}) do
      {:ok, chart} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_chart()

      chart
    end

    test "list_charts/0 returns all charts" do
      chart = chart_fixture()
      assert Data.list_charts() == [chart]
    end

    test "get_chart!/1 returns the chart with given id" do
      chart = chart_fixture()
      assert Data.get_chart!(chart.id) == chart
    end

    test "create_chart/1 with valid data creates a chart" do
      assert {:ok, %Chart{} = chart} = Data.create_chart(@valid_attrs)
      assert chart.bar == true
      assert chart.donut == true
      assert chart.line == true
      assert chart.user_id == "some user_id"
    end

    test "create_chart/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_chart(@invalid_attrs)
    end

    test "update_chart/2 with valid data updates the chart" do
      chart = chart_fixture()
      assert {:ok, %Chart{} = chart} = Data.update_chart(chart, @update_attrs)
      assert chart.bar == false
      assert chart.donut == false
      assert chart.line == false
      assert chart.user_id == "some updated user_id"
    end

    test "update_chart/2 with invalid data returns error changeset" do
      chart = chart_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_chart(chart, @invalid_attrs)
      assert chart == Data.get_chart!(chart.id)
    end

    test "delete_chart/1 deletes the chart" do
      chart = chart_fixture()
      assert {:ok, %Chart{}} = Data.delete_chart(chart)
      assert_raise Ecto.NoResultsError, fn -> Data.get_chart!(chart.id) end
    end

    test "change_chart/1 returns a chart changeset" do
      chart = chart_fixture()
      assert %Ecto.Changeset{} = Data.change_chart(chart)
    end
  end
end
