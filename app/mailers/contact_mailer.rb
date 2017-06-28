class ContactMailer < ApplicationMailer
	default from: "nao-responda@pizzaprime.com.br"

	def contact_email(contact)
		@contato = contact
		mail(to: 'contato@pizzaprime.com.br', subject: 'Contato: Pizza Prime')
	end

end
