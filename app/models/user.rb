# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  tokens                 :text
#  picture_file_name      :string
#  picture_content_type   :string
#  picture_file_size      :integer
#  picture_updated_at     :datetime
#  type                   :string           default("Person"), not null
#  name                   :string
#  nickname               :string
#  phone                  :string
#  status                 :integer
#  transport_id           :integer
#  latitude               :float
#  longitude              :float
#

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
