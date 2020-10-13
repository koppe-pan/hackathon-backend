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
  slack_company_id: "sample_company_id",
  token: "some_token"
})

Backend.Repo.insert!(%Backend.Companies.Company{
  slack_company_id: "sample_company_id_2",
  token: "some_token_2"
})

Backend.Repo.insert!(%Backend.Users.User{
  company_id: 1,
  name: "sample_user",
  slack_user_id: "sample_id"
})

Backend.Repo.insert!(%Backend.Users.User{
  company_id: 1,
  name: "sample_user_2",
  slack_user_id: "sample_id_2"
})

Backend.Repo.insert!(%Backend.Users.User{
  company_id: 2,
  name: "sample_user_3",
  slack_user_id: "sample_id_3"
})

Backend.Repo.insert!(%Backend.HealthDatas.HealthData{
  comment: "health data for sample_user",
  date: ~D[2000-01-01],
  step: 10,
  user_id: 1
})

Backend.Repo.insert!(%Backend.HealthDatas.HealthData{
  comment: "health data for sample_user_2",
  date: ~D[2000-01-01],
  step: 5,
  user_id: 2
})

Backend.Repo.insert!(%Backend.HealthDatas.HealthData{
  comment: "health data for sample_user_3",
  date: ~D[2000-01-01],
  step: 100,
  user_id: 3
})

Backend.Repo.insert!(%Backend.Coupons.Coupon{
  cost: 1000,
  description: "sample coupon",
  life_time: ~N[2000-01-01 23:00:07]
})
