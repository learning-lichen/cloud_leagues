admin = User.create({
  login: 'Dimes', 
  email: 'maxwellthew00t@gmail.com',
  password: 'm3snow',
  password_confirmation: 'm3snow'
}, as: :admin)


admin.create_account_information({
  reddit_name: 'Velium',
  character_name: 'Dimes',
  character_code: '985',
  role: 2,
  race: 2,
  league: Tournament::PLATINUM,
  time_zone: 'Eastern Time (US & Canada)'
}, as: :admin)

Map.create({
  name: 'Metropolis',
  image_url: '/assets/metropolis.jpg'
}, as: :admin)
