# add top-level class documentation
class UsersController < ApplicationController
  def find_or_create_user(fb_user)
    user = User.find_by(facebook_id: fb_user.id)
    return [:ok, user] if user

    user = User.new
    user.facebook_id = fb_user.id
    user.name = fb_user.name
    user.facebook_data = fb_user.raw_attributes.to_json
    user.save

    [:created, user]
  end

  def login
    access_token = params['accessToken']
    fb_user = FbGraph2::User.me(access_token).fetch(fields: 'id,
      name,
      age_range,
      gender,
      locale,location')

    status, user = find_or_create_user(fb_user)
    user.update(token: access_token)
    sign_in(:user, user)

    render json: user, status: status
  end
end
