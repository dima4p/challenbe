require 'active_support/inflector'

guard :rspec, cmd: "bundle exec rspec",
    all_after_pass: false, all_on_start: false, failed_mode: :focus do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # Feel free to open issues for suggestions and improvements

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  # Rails files
  rails = dsl.rails(view_extensions: %w(erb haml slim jbuilder))
  dsl.watch_spec_files_for(rails.app_files)
  dsl.watch_spec_files_for(rails.views)

  watch(rails.controllers) do |m|
    [
      rspec.spec.("routing/#{m[1]}_routing"),
      rspec.spec.("controllers/#{m[1]}_controller"),
      rspec.spec.("acceptance/#{m[1]}")
    ]
  end

  # Rails config changes
  watch(rails.spec_helper)     { rspec.spec_dir }
  watch(rails.routes)          { "#{rspec.spec_dir}/routing" }
  watch(rails.app_controller)  { "#{rspec.spec_dir}/controllers" }

  # Capybara features specs
  watch(rails.view_dirs)     { |m| rspec.spec.("features/#{m[1]}") }

  # Turnip features and steps
  watch(%r{^spec/acceptance/(.+)\.feature$})
  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$}) do |m|
    Dir[File.join("**/#{m[1]}.feature")][0] || "spec/acceptance"
  end

  # Factory Girl
  watch(%r{^spec/factories/(.+)\.rb$}) do |m|
    [
      "spec/controllers/#{m[1]}_controller_spec.rb",
      "spec/models/#{m[1].singularize}_spec.rb",
      "spec/views/#{m[1]}"
    ]
  end

  # Ability
  watch(%r{^spec/models/ability/(.+)\.rb$}) {"spec/models/ability_spec.rb"}

  # forms
  watch(%r{^app/(.*)_form(.*)(\.erb|\.haml|\.slim)$}){|m| ["spec/#{m[1]}edit#{m[2]}#{m[3]}_spec.rb", "spec/#{m[1]}new#{m[2]}#{m[3]}_spec.rb"]}
end
