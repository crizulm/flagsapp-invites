class InvitesController < ApplicationController

  def create
    sender_id = params[:sender_id]
    organization_id = params[:organization_id]
    email = params[:email]

    errors = check_create_params(sender_id, organization_id, email)
    if(errors.empty?)
      @invite = Invite.new(sender_id: sender_id, organization_id: organization_id,
                           email: email)

      if @invite.save
        InviteMailer.new_user_invite(@invite).deliver
        render json: @invite, status: :ok
      else
        errors = @invite.errors.full_messages
        render json: { error: errors }, status: :bad_request
      end
    else
      render json: { error: errors }, status: :bad_request
    end
  end

  def show
    token = params[:token]
    @invite = Invite.find_by(token: token)

    if !@invite.nil?
      render json: @invite, status: :ok
    else
      return render json: { error: ['The invitation not exist'] }, status: :bad_request
    end
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
      errors.append('The organization is NULL')
    end
    errors
  end

end
