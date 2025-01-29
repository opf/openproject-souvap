require "active_support/dependencies"
require "open_project/plugins"

module OpenProject::OpenDesk
  class Engine < ::Rails::Engine
    engine_name :openproject_open_desk

    include OpenProject::Plugins::ActsAsOpEngine

    patch_with_namespace :Redmine, :MenuManager, :TopMenuHelper
    patch_with_namespace :OpenProject, :Plugins, :AuthPlugin
    patch_with_namespace :Authorization, :EnterpriseService

    patches [:CustomStylesHelper]


    register(
      "openproject-open_desk",
      author_url: "https://openproject.org"
    ) do
      menu :open_desk_menu,
           :central_navigation,
           nil,
           partial: "open_desk/menu/top_menu_node"
    end

    add_api_path :linked_applications do
      "#{root}/linked_applications"
    end

    add_api_endpoint "API::V3::Root" do
      mount ::API::V3::LinkedApplications::LinkedApplicationsAPI
    end

    initializer "open_desk.settings" do
      ::Settings::Definition.add "souvap_navigation_url",
                                 default: nil,
                                 format: :string

      ::Settings::Definition.add "souvap_navigation_secret",
                                 default: nil,
                                 format: :string
    end
  end
end
