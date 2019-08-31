# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ticketsystem.Repo.insert!(%Ticketsystem.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Ticketsystem.Accounts
alias Ticketsystem.Accounts.User
alias Ticketsystem.Companies.Company
alias Ticketsystem.Companies
alias Ticketsystem.Repo

# Remove existing data
User |> Repo.delete_all()
Company |> Repo.delete_all()

{:ok, company1} = Companies.insert_or_update_company(%{name: "company1"})
{:ok, company2} = Companies.insert_or_update_company(%{name: "company2"})

Accounts.create_user(%{
  email: "email1@email.com",
  name: "name1",
  username: "username1",
  password: "password",
  company_id: company1.id
})

Accounts.create_user(%{
  email: "email2@email.com",
  name: "name2",
  username: "username2",
  password: "password",
  company_id: company2.id
})
