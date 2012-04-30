# Template functions
# ------------------------------------------------------------

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

# Mmmmmmmmm
# ------------------------------------------------------------
gem 'thin', :group => 'development'

# dry the controller
gem 'responders'

# forms DSL
gem 'simple_form', :git => 'git://github.com/plataformatec/simple_form.git'
gem 'nested_form', :git => 'https://github.com/ryanb/nested_form.git'
gem 'country-select'

# interface
gem 'sugar'
gem 'slim-rails'
gem 'bourbon'
gem 'bootstrap-sass'
gem 'bootswatch-rails'

# available bootswatches
# Amelia Cerulean Cyborg Journal Readable Simplex Slate Spacelab Spruce Superhero United
bootswatch_question = 'Select a bootswatch theme - http://bootswatch.com/#gallery'
bootswatch_themes = %w(amelia cerulean cyborg journal readable simplex slate spacelab spruce superhero united)
bootswatch_themes.collect! { |name| [name, name] }
bootswatch_choice = multiple_choice(bootswatch_question, bootswatch_themes)

# Bundle and Configure
# ------------------------------------------------------------
run 'bundle install'

# forms
# missing installing nested form js into asset pipeline?
generate 'nested_form:install'
generate 'simple_form:install --bootstrap'

generate 'responders:install'

# remove default homepage
File.unlink "public/index.html"

# configure bootswatch theme choice
gsub_file 'app/assets/stylesheets/application.css.scss', /THEME_NAME/, bootswatch_choice
