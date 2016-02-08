namespace :db do
  desc "fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    [Establishment, School, Student].each(&:delete_all)
    
    Establishment.populate 10 do |establishment|
      establishment.name = Faker::Company.name
      establishment.code = 10000..200000
      establishment.department = Faker::Address.city
      establishment.state = Faker::Address.state
      establishment.phone = Faker::PhoneNumber.phone_number
      establishment.email = Faker::Internet.email
      School.populate 1..5 do |school| 
        school.code = Faker::Number.number(9) 
        school.name = Faker::University.name
        school.address = Faker::Address.street_address
        school.neighborhood = Faker::Address.street_name
        school.zone = Faker::Address.zip_code
        school.contact_name = Faker::App.author
        school.contact_position = Faker::Name.title
        school.phone = Faker::PhoneNumber.phone_number
        school.email = Faker::Internet.email
        school.headquarter = [true, false]
        school.foundation_present = [true, false]
        school.establishment_id = establishment.id
        school.created_at = 2.years.ago..Time.now
        Student.populate 7..18 do |person|
          person.name    = Faker::Name.name
          person.gender = ['masculino', 'femenino']
          person.id_type = ['TI', 'RC', 'Otro', 'NUIP']
          person.address = Faker::Address.street_address
          person.last_course = 1..11
          person.outschool_years = 0..4
          person.identification = Faker::Number.number(9) 
          person.born = Faker::Time.between(18.years.ago, 3.years.ago)
          person.etnic = ["Mulato", "Negro", "Caucasico", "Embera"]
          person.villa = Faker::Address.street_address
          person.born_state = Faker::Address.state
          person.displaced = [true, false]
          person.residency_state = Faker::Address.state
          person.zone = Faker::Address.zip_code
          person.school_id = school.id
          person.created_at = 2.years.ago..Time.now
        end
      end
    end
    
  end
end