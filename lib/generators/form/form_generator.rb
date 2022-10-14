class FormGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  argument :attributes,
           type: :array,
           default: [],
           banner: "field:type field:type"

  def copy_form_files
    template "form.erb", "app/forms/#{file_name}_form.rb"
    template "form_spec.erb", "spec/forms/#{file_name}_form_spec.rb"
    template "form_controller.erb",
             "app/controllers/#{plural_name}_controller.rb"
    template "new_form.html.erb", "app/views/#{plural_name}/new.html.erb"

    insert_into_file "config/routes.rb",
                     before:
                       "namespace :support_interface, path: \"/support\" do\n" do
      "  get \"#{plural_name}\", to: \"#{plural_name}#new\"\n" \
        "  post \"#{plural_name}\", to: \"#{plural_name}#create\"\n"
    end
    generate :migration,
             "Add#{class_name}ToEligibilityCheck #{
               attributes
                 .map { |attribute| [attribute.name, attribute.type].join(":") }
                 .join(" ")
             }"
  end
end
