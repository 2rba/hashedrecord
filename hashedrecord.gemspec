# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'hashedrecord'
  s.version     = '1.0.0'
  s.summary     = 'In memory collection filtering'
  s.description = 'Hashed access to records with ActiveRecord like interface'
  s.authors     = ['Serg Tyatin']
  s.email       = 'hashedrecord@2rba.com'
  s.files       = ['lib/hashedrecord.rb']
  s.homepage    = 'https://github.com/2rba/hashedrecord'
  s.license     = 'MIT'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'byebug'
end
