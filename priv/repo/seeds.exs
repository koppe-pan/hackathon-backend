# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Backend.Repo.insert!(%Backend.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
Backend.Repo.insert!(%Backend.Companies.Company{
  id: 1
})

Backend.Repo.insert!(%Backend.Users.User{
  company_id: 1,
  name: "sample_user",
  role: "president"
})
