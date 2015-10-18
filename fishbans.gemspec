Gem::Specification.new do |s|
  s.authors = ['Eli Foster']
  s.name = 'fishbans'
  s.summary = 'A Ruby gem for accessing the Fishbans Minecraft API.'
  s.version = '1.0.1'
  s.license = 'CC-BY-NC-ND-4.0'
  s.description = 'Accessing the Fishbans Minecraft API through HTTPClient. ' \
                  'Has methods for all Fishban APIs.'
  s.email = 'elifosterwy@gmail.com'
  s.homepage = 'https://github.com/elifoster/fishbans-rb'
  s.metadata = {
    'issue_tracker' => 'https://github.com/elifoster/fishbans-rb/issues'
  }
  s.files = [
    'CHANGELOG.md',
    'lib/fishbans.rb',
  ]
  s.add_runtime_dependency('httpclient')
end
