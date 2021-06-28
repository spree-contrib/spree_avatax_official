lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_avatax_official/version'

Gem::Specification.new do |s| # rubocop:disable Metrics/BlockLength
  s.platform              = Gem::Platform::RUBY
  s.name                  = 'spree_avatax_official'
  s.version               = SpreeAvataxOfficial.version
  s.summary               = 'The official certified Spree Avatax'
  s.description           = 'The new officially supported Avalara AvaTax extension for Spree Commerce using Avalara REST API v2'
  s.required_ruby_version = '>= 2.0.0'

  s.author   = 'Spark Solutions'
  s.email    = 'we@sparksolutions.co'
  s.homepage = 'https://sparksolutions.co'
  s.license  = 'BSD-3-Clause'

  s.metadata = {
    "bug_tracker_uri"   => "https://github.com/spree/spree_avatax_official/issues",
    "changelog_uri"     => "https://github.com/spree/spree_avatax_official/releases/tag/v#{s.version}",
    "documentation_uri" => "https://guides.spreecommerce.org/",
    "source_code_uri"   => "https://github.com/spree/spree_avatax_official/tree/v#{s.version}",
  }

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'avatax', '~> 19.3'

  spree_version = '>= 2.1.0', '< 5.0'

  s.add_dependency 'spree_backend', spree_version
  s.add_dependency 'spree_core',    spree_version
  s.add_dependency 'spree_extension'

  s.add_development_dependency 'dotenv-rails'
  s.add_development_dependency 'spree_dev_tools'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
