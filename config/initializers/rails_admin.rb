RailsAdmin.config do |config|
  config.asset_source = :sprockets
  config.main_app_name = ["AppGyver demo"]

  config.authenticate_with do
    authenticate_or_request_with_http_basic("Admin authorization") do |username, password|
      username == ENV["RAILS_ADMIN_LOGIN"] && password == ENV["RAILS_ADMIN_PASSWORD"]
    end
  end

  config.actions do
    # root actions
    dashboard # mandatory
    # collection actions
    index # mandatory
    new
    export
    history_index
    bulk_delete
    # member actions
    show
    edit
    delete
    history_show
    show_in_app
  end
end
