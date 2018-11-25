class InvitesController < ApplicationController

  def create
    sender_id = params[:sender_id]
    organization_id = params[:organization_id]
    email = params[:email]

    errors = check_create_params(sender_id, organization_id, email)
    if errors.empty?
      create_invitation(sender_id, organization_id, email)
    else
      render json: { errors: errors }, status: :bad_request
    end
  end

  def show
    token = params[:token]
    @invite = Invite.find_by(token: token)

    show_invitation(@invite)
  end

  def destroy
    begin
      Invite.destroy(params[:id])
      render nothing: :true, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render nothing: :true, status: :ok
    end
  end

  private

  def check_create_params(sender_id, organization_id, email)
    errors = []
    if sender_id.nil?
      errors.append('The sender is NULL')
    end
    if organization_id.nil?
      errors.append('The organization is NULL')
    end
    if email.nil?
      errors.append('The email is NULL')
    end
    errors
  end

  def create_invitation(sender_id, organization_id, email)
    @invite = Invite.new(sender_id: sender_id, organization_id: organization_id,
                         email: email)

    if @invite.save
      InviteMailer.new_user_invite(@invite).deliver
      render json: { data: @invite }, status: :ok
    else
      errors = @invite.errors.full_messages
      render json: { errors: errors }, status: :bad_request
    end
  end

  def show_invitation(invite)
    if !@invite.nil?
      render json: { data: @invite }, status: :ok
    else
      render json: { errors: ['The invitation not exist'] }, status: :bad_request
    end
  end

end
