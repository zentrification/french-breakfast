##########################################################################################
# Template functions
##########################################################################################

def ask_wizard(question)
  ask "\033[1m\033[30m\033[46m" + "prompt".rjust(10) + "\033[0m\033[36m" + "  #{question}\033[0m"
end

def multiple_choice(question, choices)
  say_custom('question', question)
  values = {}
  choices.each_with_index do |choice,i|
    values[(i + 1).to_s] = choice[1]
    say_custom (i + 1).to_s + ')', choice[0]
  end
  answer = ask_wizard("Enter your selection:") while !values.keys.include?(answer)
  values[answer]
end

def say_custom(tag, text); say "\033[1m\033[36m" + tag.to_s.rjust(10) + "\033[0m" + "  #{text}" end


##########################################################################################
# Init repo
##########################################################################################
run 'rm public/index.html'

git :init
git :add => "."
git :commit => "-a -m 'rails new'"


##########################################################################################
# Gems
##########################################################################################

# pimp webserver
gem 'puma'

# nice settings.yml configuration
gem 'rails_config'

# controllers
gem 'responders'

# decorators
gem 'draper' if yes?('Use decorators (draper) ?')

# development mode only
gem_group :development do
  gem 'pry'
  gem 'rack-mini-profiler'
end

# forms
gem 'simple_form', :git => 'git://github.com/plataformatec/simple_form.git'
gem 'nested_form', :git => 'https://github.com/ryanb/nested_form.git'

# js
gem 'jquery-datatables-rails' if yes?('Use datatables.js ?')
gem 'humane-rails'            if yes?('Use humane.js ?')
gem 'select2-rails'           if yes?('Use select2.js ?')
# hrm
# sugar's broken for now, throwing silly rails errors
# TODO: re-enable sugar
# gem 'sugar'                   if yes?('Use sugar.js ?')

# views
gem 'slim-rails'


##########################################################################################
# Bootswatch theming
##########################################################################################
if yes?('Use bootswatch ?')

  gem 'bootstrap-sass'
  gem 'bootswatch-rails'

  bootswatch_question = 'Select a bootswatch theme - http://bootswatch.com/#gallery'
  bootswatch_themes = %w(amelia cerulean cyborg journal readable simplex slate spacelab spruce superhero united).collect { |name| [name, name] }
  bootswatch_choice = multiple_choice(bootswatch_question, bootswatch_themes)

  run 'rm app/assets/stylesheets/application.css'

  create_file 'app/assets/stylesheets/application.css.scss' do
<<-BLOCK_STRING
// http://bootswatch.com/#{bootswatch_choice}/
@import "bootswatch/#{bootswatch_choice}/variables";
@import "bootstrap";
@import "bootstrap-responsive";
@import "bootswatch/#{bootswatch_choice}/bootswatch";

// Bootstrap body padding for fixed navbar
body { padding-top: 60px; }
BLOCK_STRING
  end
end

##########################################################################################
# Bundle and Configure
##########################################################################################
run 'bundle install'

# run generators
generate 'nested_form:install'
generate 'responders:install'
generate 'simple_form:install --bootstrap'

git :add => "."
git :commit => "-a -m 'ran french-breakfast application template'"
