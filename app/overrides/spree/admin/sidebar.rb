Deface::Override.new(
  virtual_path: 'spree/admin/users/_sidebar',
  name: 'add avalara information link',
  insert_bottom: '[data-hook="admin_user_tab_options"]',
) do
  <<~HTML
    <li>
      <%= link_to_with_icon 'money',
        Spree.t('spree_avatax_official.information_url'),
        avalara_information_admin_user_path(@user),
        class: "nav-link" %>
    </li>
  HTML
end
