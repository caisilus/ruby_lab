class Current < ActiveSupport::CurrentAttributes
  attribute :user, :host_url, :authorize_url
end
