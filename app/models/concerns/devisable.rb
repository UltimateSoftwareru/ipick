module Devisable
  extend ActiveSupport::Concern

  included do
    devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :trackable, :validatable,
            :confirmable, :omniauthable
    include DeviseTokenAuth::Concerns::User

    def build_auth_url(base_url, args)
      args[:uid]    = self.uid
      args[:expiry] = self.tokens[args[:client_id]]['expiry']
      args[:resorse_name] = self.class.name.underscore

      DeviseTokenAuth::Url.generate(base_url, args)
    end
  end
end
