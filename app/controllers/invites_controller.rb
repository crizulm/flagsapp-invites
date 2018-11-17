class InvitesController < ApplicationController

  def create
    @invite = Invite.new
    @invite.sender_id = params[:sender_id]
    @invite.organization_id = params[:organization_id]
    @invite.email = params[:email]

    if @invite.save
      InviteMailer.new_user_invite(@invite).deliver
      render json: @invite, status: :ok
    else
      render nothing: :true, status: :bad_request
    end
  end

  def show
    @invite = Invite.find_by(token: params[:token])

    if !@invite.nil?
      render json: @invite, status: :ok
    else
      render nothing: :true, status: :bad_request
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

end
