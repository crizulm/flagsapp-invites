class InviteMailer < ApplicationMailer
  def new_user_invite(invite)
    @invite = invite
    mail(to: invite.email, subject: 'You are invited to join - Flagsapp')
  end
end
