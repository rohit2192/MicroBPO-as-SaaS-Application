class ComposeSmsController < ApplicationController
  before_filter :authorization
  require 'uri'
  require 'net/http'
  def new
	@contact_groups = ContactGroup.where("is_active = ?", true)
	@sms_templates = SmsTemplate.all
  end

  def load_contact
	@contacts = Contact.where("contact_group_id = ?", params[:id])
	render json: @contacts
  end

  def create
	uri = URI('http://manage.sarvsms.com/api/send_promotional_sms.php?username=u272&msg_token=TF3YxU&message='+params[:message].gsub(" ", '%20')+'&mobile='+params[:contact_number_list].join(","))

	Net::HTTP.get(uri)
	#Net::HTTP.start(uri.host, uri.port) do |http|
	  #request = Net::HTTP::Get.new uri.request_uri

	  #response = http.request request # Net::HTTPResponse object
	#end

	@contact_groups = ContactGroup.where("is_active = ?", true)
	flash[:notice] = "Message was sent successfully."
	redirect_to controller: "compose_sms", action: "new" #, notice: "Mesaage was sent successfully."
  end
end
