defmodule BankapiWeb.UserControllerTest do
  use BankapiWeb.ConnCase
  import Plug.BasicAuth

  @valid_attrs_complete %{
    cpf: "12345678934",
    password: "12345678912",
    country: "USA",
    city: "Vitorino",
    birth_date: "2000-01-01",
    state: "Paraná",
    name: "Teste Teste",
    email: "tutaaa@tsaa.com"
  }

  @valid_attrs_complete_another_user %{
    cpf: "12345678935",
    password: "12345678912",
    country: "Brasil",
    city: "Florianópolis",
    birth_date: "2000-01-01",
    state: "Santa Catarina",
    name: "Teste Teste",
    email: "aaa@aaa.com"
  }

  @valid_attrs_incomplete %{
    cpf: "12345678935",
    password: "12345678912",
    country: "Brasil",
    city: "Florianópolis"
  }

  @invalid_attrs %{
    cpf: "1234567893",
    password: "123456",
    country: "Brasil",
    city: "Florianópolis",
    birth_date: "2000-01-01",
    state: "Santa Catarina",
    name: "Teste Teste",
    email: "aaaaaa.com"
  }

  describe "create_or_update/2" do
    test "POST /api/user Creating a new user", %{conn: conn} do
      %Plug.Conn{resp_body: resp_body} = post(conn, "/api/user", @valid_attrs_complete)

      {:ok, %{"user" => %{"id" => id, "user_code" => user_code}} = response} =
        Jason.decode(resp_body)

      assert %{
               "message" => "User register complete",
               "user" => %{
                 "birth_date" => "2000-01-01",
                 "city" => "Vitorino",
                 "country" => "USA",
                 "cpf" => "12345678934",
                 "email" => "tutaaa@tsaa.com",
                 "gender" => nil,
                 "id" => ^id,
                 "name" => "Teste Teste",
                 "referral_code" => nil,
                 "state" => "Paraná",
                 "status" => "complete",
                 "user_code" => ^user_code
               }
             } = response
    end

    test "POST /api/user Creating a new user with incomplete data", %{conn: conn} do
      %Plug.Conn{resp_body: resp_body} = post(conn, "/api/user", @valid_attrs_incomplete)
      {:ok, %{"user" => %{"id" => id}} = response} = Jason.decode(resp_body)

      assert %{
               "message" => "User register pending",
               "user" => %{
                 "birth_date" => nil,
                 "city" => "Florianópolis",
                 "country" => "Brasil",
                 "cpf" => "12345678935",
                 "email" => nil,
                 "gender" => nil,
                 "id" => ^id,
                 "name" => nil,
                 "referral_code" => nil,
                 "state" => nil,
                 "status" => "pending"
               }
             } = response
    end

    test "POST /api/user Creating a new user with invalid data", %{conn: conn} do
      %Plug.Conn{resp_body: resp_body} = post(conn, "/api/user", @invalid_attrs)
      {:ok, response} = Jason.decode(resp_body)

      assert %{
               "message" => %{
                 "cpf" => ["has invalid format", "should be at least 11 character(s)"],
                 "email" => ["has invalid format"],
                 "password" => ["should be at least 8 character(s)"]
               }
             } = response
    end

    test "POST /api/user Updating a user", %{conn: conn} do
      %Plug.Conn{} = post(conn, "/api/user", @valid_attrs_complete)

      new_params = %{
        cpf: "12345678934",
        password: "12345678912",
        country: "Brasil",
        city: "São Paulo",
        birth_date: "2000-01-01",
        state: "São Paulo",
        name: "Teste Teste",
        email: "tutaaa@tsaa.com"
      }

      conn =
        put_req_header(conn, "authorization", encode_basic_auth("12345678934", "12345678912"))

      %Plug.Conn{resp_body: resp_body} = post(conn, "/api/user", new_params)

      {:ok, %{"user" => %{"id" => id, "user_code" => user_code}} = response} =
        Jason.decode(resp_body)

      assert %{
               "message" => "User register complete",
               "user" => %{
                 "birth_date" => "2000-01-01",
                 "city" => "São Paulo",
                 "country" => "Brasil",
                 "cpf" => "12345678934",
                 "email" => "tutaaa@tsaa.com",
                 "gender" => nil,
                 "id" => ^id,
                 "name" => "Teste Teste",
                 "referral_code" => nil,
                 "state" => "São Paulo",
                 "status" => "complete",
                 "user_code" => ^user_code
               }
             } = response
    end

    test "POST /api/user Updating a user with incomplete data", %{conn: conn} do
      %Plug.Conn{} = post(conn, "/api/user", @valid_attrs_incomplete)

      new_params = %{
        cpf: "12345678935",
        password: "12345678912",
        country: "Brasil",
        city: "São Paulo",
        gender: "Prefiro não declarar",
        birth_date: "2000-01-01",
        state: "São Paulo",
        name: "Teste Teste",
        email: "tutaaa@tsaa.com"
      }

      conn =
        put_req_header(conn, "authorization", encode_basic_auth("12345678935", "12345678912"))

      %Plug.Conn{resp_body: resp_body} = post(conn, "/api/user", new_params)

      {:ok, %{"user" => %{"id" => id, "user_code" => user_code}} = response} =
        Jason.decode(resp_body)

      assert %{
               "message" => "User register complete",
               "user" => %{
                 "birth_date" => "2000-01-01",
                 "city" => "São Paulo",
                 "country" => "Brasil",
                 "cpf" => "12345678935",
                 "email" => "tutaaa@tsaa.com",
                 "gender" => "Prefiro não declarar",
                 "id" => ^id,
                 "name" => "Teste Teste",
                 "referral_code" => nil,
                 "state" => "São Paulo",
                 "status" => "complete",
                 "user_code" => ^user_code
               }
             } = response
    end

    test "POST /api/user Updating a user but with wrong cpf", %{conn: conn} do
      %Plug.Conn{} = post(conn, "/api/user", @valid_attrs_complete)

      new_params = %{
        cpf: "12345678934",
        password: "12345678912",
        country: "Brasil",
        city: "São Paulo",
        birth_date: "2000-01-01",
        state: "São Paulo",
        name: "Teste Teste",
        email: "tutaaa@tsaa.com"
      }

      conn = put_req_header(conn, "authorization", encode_basic_auth("1234567893", "12345678912"))

      %Plug.Conn{resp_body: resp_body} = post(conn, "/api/user", new_params)
      {:ok, response} = Jason.decode(resp_body)
      assert %{"message" => %{"error" => "User not found"}} = response
    end

    test "POST /api/user Updating a user but with another valid user/password", %{conn: conn} do
      %Plug.Conn{} = post(conn, "/api/user", @valid_attrs_complete)
      %Plug.Conn{} = post(conn, "/api/user", @valid_attrs_complete_another_user)

      new_params = %{
        cpf: "12345678934",
        password: "12345678912",
        country: "Brasil",
        city: "São Paulo",
        birth_date: "2000-01-01",
        state: "São Paulo",
        name: "Teste Teste",
        email: "tutaaa@tsaa.com"
      }

      conn =
        put_req_header(conn, "authorization", encode_basic_auth("12345678935", "12345678912"))

      %Plug.Conn{resp_body: resp_body} = post(conn, "/api/user", new_params)
      {:ok, response} = Jason.decode(resp_body)
      assert %{"message" => %{"error" => "Do not have permission"}} = response
    end
  end

  describe "show_referrals/2" do
    test "GET /api/user/:user_code/referrals Getting a referrals list", %{conn: conn} do
      %Plug.Conn{resp_body: resp_body} = post(conn, "/api/user", @valid_attrs_complete)
      {:ok, %{"user" => %{"user_code" => user_code}}} = Jason.decode(resp_body)

      another_user = %{
        cpf: "12345678935",
        password: "12345678912",
        country: "Brasil",
        city: "São Paulo",
        birth_date: "2000-01-01",
        state: "São Paulo",
        name: "Teste Teste",
        email: "aaa@tsaa.com",
        referral_code: user_code
      }

      post(conn, "/api/user", another_user)

      conn =
        put_req_header(conn, "authorization", encode_basic_auth("12345678934", "12345678912"))

      %Plug.Conn{resp_body: resp_body} = get(conn, "/api/user/" <> user_code <> "/referrals")
      {:ok, response} = Jason.decode(resp_body)

      assert %{
               "message" => "Listing all referrals",
               "referrals" => _
             } = response
    end

    test "GET /api/user/:user_code/referrals Getting a referrals list empty", %{conn: conn} do
      %Plug.Conn{resp_body: resp_body} = post(conn, "/api/user", @valid_attrs_complete)
      {:ok, %{"user" => %{"user_code" => user_code}}} = Jason.decode(resp_body)

      conn =
        put_req_header(conn, "authorization", encode_basic_auth("12345678934", "12345678912"))

      %Plug.Conn{resp_body: resp_body} = get(conn, "/api/user/" <> user_code <> "/referrals")
      {:ok, response} = Jason.decode(resp_body)

      assert %{"message" => %{"error" => "User has no referrals"}} = response
    end

    test "GET /api/user/:user_code/referrals Getting a referrals list with another username", %{
      conn: conn
    } do
      %Plug.Conn{resp_body: resp_body} = post(conn, "/api/user", @valid_attrs_complete)
      {:ok, %{"user" => %{"user_code" => user_code}}} = Jason.decode(resp_body)

      another_user = %{
        cpf: "12345678935",
        password: "12345678912",
        country: "Brasil",
        city: "São Paulo",
        birth_date: "2000-01-01",
        state: "São Paulo",
        name: "Teste Teste",
        email: "aaa@tsaa.com",
        referral_code: user_code
      }

      post(conn, "/api/user", another_user)

      conn =
        put_req_header(conn, "authorization", encode_basic_auth("12345678935", "12345678912"))

      %Plug.Conn{resp_body: resp_body} = get(conn, "/api/user/" <> user_code <> "/referrals")
      {:ok, response} = Jason.decode(resp_body)

      assert %{"message" => %{"error" => "Do not have permission"}} = response
    end
  end
end
