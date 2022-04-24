Doorkeeper.configure do
  # Change the ORM that doorkeeper will use (requires ORM extensions installed).
  # Check the list of supported ORMs here: https://github.com/doorkeeper-gem/doorkeeper#orms
  orm :active_record

  allow_blank_redirect_uri true

  default_scopes  :public
  optional_scopes :member

  # enforce_configured_scopes

  # This block will be called to check whether the resource owner is authenticated or not.
  resource_owner_authenticator do
    current_member || warden.authenticate!(scope: :member)
  end

  resource_owner_from_credentials do |_routes|
    Member.authenticate(params[:email], params[:password])
  end

  use_refresh_token

  skip_authorization do
    true
  end

  # By default, all access tokens expires in 2 hours. You can change this in the configuration:
  # If you set the option to nil the access token will never expire (not recommended)
  #
  # reference:
  #   https://github-wiki-see.page/m/doorkeeper-gem/doorkeeper/wiki/Customizing-Token-Expiration
  #
  access_token_expires_in nil

  api_only

  # Custom Response
  # Doorkeeper::OAuth::TokenResponse.send :prepend, CookieTokenResponse

  # access_token_methods lambda { |request|
  #   request.cookies['customer_access_token']
  # }

  grant_flows %w[authorization_code client_credentials password]
end