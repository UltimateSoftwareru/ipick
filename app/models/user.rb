class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  establish_connection "iwant_users_#{Rails.env}".to_sym

  def token_validation_response
    ActiveModel::SerializableResource.new(self).serializable_hash
      .as_json(except: [
        :tokens, :created_at, :updated_at])
  end

  def build_auth_url(base_url, args)
    args[:uid]    = self.uid
    args[:expiry] = self.tokens[args[:client_id]]['expiry']
    args[:type] = self.type.underscore

    DeviseTokenAuth::Url.generate(base_url, args)
  end
end
