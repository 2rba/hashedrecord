# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'hashedrecord'
  s.version     = '1.1.1'
  s.summary     = 'In memory collection filtering'
  s.description = 'Hashed access to in-memory records with ActiveRecord like interface'
  s.authors     = ['Serg Tyatin']
  s.email       = 'hashedrecord@2rba.com'
  s.files       = Dir['lib/**/*']
  s.homepage    = 'https://github.com/2rba/hashedrecord'
  s.license     = 'MIT'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'byebug'
end
