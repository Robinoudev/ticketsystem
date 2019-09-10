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
alias Ticketsystem.Tickets
alias Ticketsystem.Tickets.Ticket

# Remove existing data
Ticket |> Repo.delete_all()
User |> Repo.delete_all()
Company |> Repo.delete_all()

# Companies
company1 = Repo.insert!(%Company{name: "company1"})
company2 = Repo.insert!(%Company{name: "company2"})

# Users
user1 =
  Repo.insert!(%User{
    email: "superadmin@email.com",
    name: "name1",
    username: "username1",
    password_hash: Bcrypt.hash_pwd_salt("password"),
    company_id: company1.id,
    roles: [:superadmin]
  })

user2 =
  Repo.insert!(%User{
    email: "superadmin@email.com",
    name: "name2",
    username: "username2",
    password_hash: Bcrypt.hash_pwd_salt("password"),
    company_id: company2.id,
    roles: [:handler]
  })

# Issued Tickets
Tickets.insert_or_update_ticket(
  %{
    title: "First ticket",
    description: "Description"
  },
  user1
)
