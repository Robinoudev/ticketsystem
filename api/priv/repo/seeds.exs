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

alias Ticketsystem.Accounts.User
alias Ticketsystem.Companies.Company
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
superadmin =
  Repo.insert!(%User{
    email: "superadmin@email.com",
    name: "superadmin",
    username: "superadmin",
    password_hash: Bcrypt.hash_pwd_salt("password"),
    company_id: company1.id,
    roles: [:superadmin]
  })

admin =
  Repo.insert!(%User{
    email: "admin@email.com",
    name: "admin",
    username: "admin",
    password_hash: Bcrypt.hash_pwd_salt("password"),
    company_id: company2.id,
    roles: [:admin]
  })

handler =
  Repo.insert!(%User{
    email: "handler@email.com",
    name: "handler",
    username: "handler",
    password_hash: Bcrypt.hash_pwd_salt("password"),
    company_id: company2.id,
    roles: [:handler]
  })

issuer1 =
  Repo.insert!(%User{
    email: "issuer@email.com",
    name: "issuer",
    username: "issuer",
    password_hash: Bcrypt.hash_pwd_salt("password"),
    company_id: company2.id,
    roles: [:issuer]
  })

issuer2 =
  Repo.insert!(%User{
    email: "issuer2@email.com",
    name: "issuer2",
    username: "issuer2",
    password_hash: Bcrypt.hash_pwd_salt("password"),
    company_id: company1.id,
    roles: [:issuer]
  })

# Issued Tickets
Tickets.insert_or_update_ticket(
  %{
    title: "First ticket",
    description: "Description"
  },
  issuer1
)

Tickets.insert_or_update_ticket(
  %{
    title: "Second ticket",
    description: "Description"
  },
  issuer2
)
