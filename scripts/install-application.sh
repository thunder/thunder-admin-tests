#!/bin/bash -ex

cd "${HOME}"/build/test-dir/docroot

# Install thunder
"${HOME}"/build/test-dir/vendor/bin/drush site-install thunder \
    --account-pass=admin --db-url="sqlite://sites/default/files/.testbasesqlite" \
    install_configure_form.enable_update_status_module=NULL thunder_module_configure_form.install_modules_thunder_demo -y

# Install styleguide
"${HOME}"/build/test-dir/vendor/bin/drush -y en thunder_styleguide

# Final cache rebuild, to make sure every code change is respected
"${HOME}"/build/test-dir/vendor/bin/drush cr

# Pre-create all image styles for entity browser.´
"${HOME}"/build/test-dir/vendor/bin/drush image-derive-all
