Deface::Override.new(
  virtual_path: 'spree/admin/shared/sub_menu/_configuration',
  name: 'add_subscription_frequency_in_configurations',
  insert_bottom: "[data-hook='admin_configurations_sidebar_menu']",
  text: %q{
    <%= configurations_sidebar_menu_item(Spree.t(:subscription_frequencies), admin_subscription_frequencies_path(params[:locale])) %>
    }
)
