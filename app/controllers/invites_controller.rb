class InvitesController < ApplicationController

  def create
    sender_id = params[:sender_id]
    organization_id = params[:organization_id]
    email = params[:email]
    return render json: { error: 'The sender is NULL' }, status: :bad_request if sender_id.nil?
    return render json: { error: 'The organization is NULL' }, status: :bad_request if organization_id.nil?
    return render json: { error: 'The email is NULL' }, status: :bad_request if email.nil?

    @invite = Invite.new(sender_id: sender_id, organization_id: organization_id,
                         email: email)

    if @invite.save
      InviteMailer.new_user_invite(@invite).deliver
      render json: @invite, status: :ok
    else
      return render json: { error: @invite.errors.full_messages }, status: :bad_request
    end
  end

  def show
    token = params[:token]
    @invite = Invite.find_by(token: token)

    if !@invite.nil?
      render json: @invite, status: :ok
    else
      return render json: { error: 'The invitation not exist' }, status: :bad_request
    end
  end

  def destroy
    token = params[:token]
    begin
      Invite.destroy_all(token: token)
      render nothing: :true, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render nothing: :true, status: :ok
    end
  end

end
