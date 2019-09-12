source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails-controller-testing'
gem 'rubocop', '~> 0.63.0', require: false
gem 'rubocop-rspec', require: false
gem 'spree_auth_devise'
gem 'spree_backend'
gem 'spree_core'
gem 'sass-rails'

gemspec
