require 'active_support/dependencies'
require 'open_project/plugins'

module OpenProject::Souvap
  class Engine < ::Rails::Engine
    engine_name :openproject_Souvap

    include OpenProject::Plugins::ActsAsOpEngine

    patch_with_namespace :Redmine, :MenuManager, :TopMenuHelper

    assets %w(
      souvap/logo.svg
    )

    register(
      'openproject-souvap',
      :author_url => 'https://openproject.org',
    ) do
      menu :top_menu,
           :central_navigation,
           nil,
           partial: 'souvap/menu/top_menu_node'
    end

    add_api_path :linked_applications do
      "#{root}/linked_applications"
    end

    add_api_endpoint 'API::V3::Root' do
      mount ::API::V3::LinkedApplications::LinkedApplicationsAPI
    end

    initializer 'souvap.settings' do
      ::Settings::Definition.add 'souvap_navigation_url',
                                 default: nil,
                                 format: :string

      ::Settings::Definition.add 'souvap_navigation_secret',
                                 default: nil,
                                 format: :string
    end
  end
end
