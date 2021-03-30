defmodule Bankapi.UserTest do
  use Bankapi.DataCase

  alias Bankapi.User

  @valid_attrs_complete %{
      cpf: "12345678934",
      password: "12345678912",
      country: "USA",
      city: "Vitorino",
      birth_date: "1993-06-02",
      state: "Paraná",
      name: "Teste Teste",
      email: "tutaaa@tsaa.com"
  }

  @valid_attrs_pending %{
      cpf: "12345678934",
      password: "12345678912"
  }

  @invalid_attrs %{
      cpf: "1234567893",
      password: "123456",
  }

  describe "changeset/1" do

    test "changeset with valid attributes complete" do
      changeset = User.changeset(@valid_attrs_complete)
      assert changeset.valid?
      assert changeset.changes.status == "complete"
    end

    test "changeset with valid attributes pending" do
      changeset = User.changeset(@valid_attrs_pending)
      assert changeset.valid?
      assert changeset.changes.status == "pending"
    end

    test "changeset with invalid attributes" do
      changeset = User.changeset(@invalid_attrs)
      refute changeset.valid?
    end
  end

  describe "update_changeset/2" do
    test "update changeset with valid attributes complete" do
      changeset = User.update_changeset(%User{}, @valid_attrs_complete)
      assert changeset.valid?
      assert changeset.changes.status == "complete"
    end

    test "update changeset with valid attributes pending" do
      changeset = User.update_changeset(%User{}, @valid_attrs_pending)
      assert changeset.valid?
      assert changeset.changes.status == "pending"
    end

    test "update changeset with invalid attributes" do
      changeset = User.update_changeset(%User{}, @invalid_attrs)
      refute changeset.valid?
    end

  end


end
