# Bank API [![Coverage Status](https://coveralls.io/repos/github/guibes/bankapi/badge.svg?branch=master)](https://coveralls.io/github/guibes/bankapi?branch=master) [![GitHub issues](https://img.shields.io/github/issues/guibes/bankapi)](https://github.com/guibes/bankapi/issues) [![GitHub stars](https://img.shields.io/github/stars/guibes/bankapi)](https://github.com/guibes/bankapi/stargazers) [![GitHub forks](https://img.shields.io/github/forks/guibes/bankapi)](https://github.com/guibes/bankapi/network) [![GitHub license](https://img.shields.io/github/license/guibes/bankapi)](https://github.com/guibes/bankapi/blob/master/LICENSE)

## About Project

It's a simple API for a bank, this API the user can create a register, using CPF(is a unique brazilian ID) and PASSWORD, if the user create a complete account the API will return a unique code with 8 digits, this code can be used by the other users in register, this is called referral code. Case the user put incomplete data will take a status incomplete and will not return the code.

***If user need complete the register, will ask user and password. This user and password is the CPF and Password registered before.***

The API can list all referrals of one user too, but this need the ***Authentication***.

## Diagrams

### UML Sequence Diagram for Create User Operation

<img src="https://gist.githubusercontent.com/guibes/8bf97795ab4fe36e2b187c87842bc054/raw/3cd2a514341d743ce38bdd5a81fa163b744ae603/diagram_user.svg" />

This explain simple how the User Create user works, if the register status is complete will return a code and if is pending this code will not be returned.

### UML Sequence Diagram for Update User Operation

<img src="https://gist.githubusercontent.com/guibes/d473e496a53f9747cc5e35e69057fc4f/raw/a893dad3cf30d84c8ff48611ad1134bda4cff852/diagram_update_user.svg" />

This show the flow to update a existing user. Need the authentication to make this requests.

### UML Sequence Diagram for Get Referrals User Operation

<img src="https://gist.githubusercontent.com/guibes/0801ff3c999e27b4dca85101c32a2852/raw/681da34ed56d80e71e373aba202184241c9030e2/diagram_get_referrals.svg" />

Simple flow how the get referrals works. Need be authorized to make this request.

## End Points

This API only have two end points.

### Create User

This is in the same end point of update user. Don't need authentication to create, but for update yes. The endpoint is describe above:

```
POST  ${url_base}/api/user
```

This need receive a body param, like described below:

``` json
{
    "cpf": "12345678935", //11 digits cpf ID
    "password": "12345678912", //password min 8 digits
    "country": "Brasil", //Country name
    "city": "São Paulo", //City name
    "birth_date": "1990-01-01", //Birth Date of user
    "gender": null, //Gender is a optional param
    "referral_code": null, //Can set a code of another user here.
    "state": "São Paulo", //State/Province name
    "name": "User Name", //Full name of user
    "email": "user@provider.com" // Email of user
}
```

This is a complete register data, the API will return this:

(HTTP response code 201)

``` json
{
    "message": "User register complete",
    "user": {
        "birth_date": "1990-01-01",
        "city": "São Paulo",
        "country": "Brasil",
        "cpf": "12345678935",
        "email": "user@provider.com",
        "gender": null,
        "id": "481a2990-2f48-41bb-9b95-2eadc80c18bb", //User id
        "name": "User Name",
        "referral_code": null,
        "state": "Paraná",
        "status": "complete", //User register status
        "user_code": "GstLTGAs" //8 digit unique user code, used to referral
    }
}
```

If send part of data we have a return like that:

(HTTP response code 201)

``` json
{
    "message": "User register pending",
    "user": {
        "birth_date": null,
        "city": null,
        "country": null,
        "cpf": "12345678935",
        "email": null,
        "gender": null,
        "id": "e756f112-138f-4553-8cc2-f1131c500cb9",
        //User id
        "name": null,
        "referral_code": null,
        "state": null,
        "status": "pending" //Status now is pending
    }
}
```

Note the user stuatus now is ***pending*** and doesn't have a ***user_code***.

Users pending can not be referrals, so can't see the referrals in Get Referrals end point.


### Authentication

The Authentication is a ***[Basic HTTP Authentication](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication)***, responding like the documentation of MDN.

To make this authentication just need put CPF and Password in ***Authentication Header*** like below:

```
Basic <Base64 encoded CPF and Password>
```

#### Case Unauthorized

Case try make an operation unauthorized the API will return:

(HTTP response code 401)

``` json
{
    "message": {
        "error": "Insert user and password"
    }
}
```

#### Case User not Found

Case try make an operation with a wrong user the API will return:

(HTTP response code 401)

``` json
{
    "message": {
        "error": "User not found"
    }
}
```

#### Case Invalid Password

Case try make an operation with a invalid password:

(HTTP response code 401)

``` json
{
    "message": {
        "error": "invalid password"
    }
}
```

#### Case Forbidden

Case try make an operation with another user the API will return:

(HTTP response code 403)

``` json
{
    "message": {
        "error": "Do not have permission"
    }
}
```

### Update User (Needs Authentication)

Update user use the same end point of create, but now we need ***Authorize*** our user. So the responses is the same.

### Get User Referrals

This end point we can see all referrals of one user, but now we need ***Authorize*** our user.

```
GET  ${url_base}/api/user/{user_code}/referrals
```

If the authorization is ok and user have referrals, the API will respond this:

``` json
{
    "message": "Listing all referrals",
    "referrals": [
        {
            "id": "1f565a27-e02a-4025-be61-83a1ecf62b9f", //ID of the user who used the code
            "name": "Friend Name" //Name of user who used the code
        }
    ]
}
```

If the authorization is ok and user don't have referrals, the API will respond this:

``` json
{
    "message": {
        "error": "User has no referrals"
    }
}
```

## Gigalixir

The server is running in a Gigalixir instance, can be found in:

https://bankapidep.gigalixirapp.com/

This is build automated using github actions.

## Contribuiting

This is a open-source project so anyone can contribuite, just follow our rules and this instructions:

- Fork this project to your github account.
- Choose one issue.
- Create a branch with this issue name.
- Make the changes, remembering, the project need pass in the format case(use ```mix format``` tool), test case and the tests must have a good coverage (around 70~80%), use ```mix coveralls``` to see the coverage.
- Send a push to your branch like ```git push origin <your-branch>```.
- The Github actions will check if your code is fine.
- If is merged the Gigalixir will put running automated.

***Note: the merge is checked by admins***

## Run in your local enviroment

To start your Phoenix server:

- Install dependencies with `mix deps.get`.
- Create and migrate your database with `mix ecto.setup`.
- Install Node.js dependencies with `npm install` inside the `assets` directory.
- Start Phoenix endpoint with `mix phx.server`.

***Remember need a instance of Postgres running and if have a different credentials, need configure in ```config/dev.exs```***

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
