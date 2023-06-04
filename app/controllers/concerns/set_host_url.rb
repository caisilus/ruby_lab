module SetHostUrl
  extend ActiveSupport::Concern

  included do
    before_action :set_host_url
  end

  private

  def set_host_url
    Current.host_url = request.protocol + request.host
  end
end
