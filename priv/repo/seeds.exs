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

Backend.Repo.insert!(%Backend.Companies.Company{
  id: 2
})
Backend.Repo.insert!(%Backend.Users.User{
  company_id: 1,
  name: "sample_user",
  role: "president"
})

Backend.Repo.insert!(%Backend.Users.User{
  company_id: 1,
  name: "sample_user_2",
  role: "director"
})

Backend.Repo.insert!(%Backend.Users.User{
  company_id: 2,
  name: "sample_user_3",
  role: "president"
})
Backend.Repo.insert!(%Backend.HealthDatas.HealthData{
  comment: "health data for sample_user",
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
