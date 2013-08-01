class ContactMessagesController < ApplicationController
  before_action :set_contact_message, only: [:show, :edit, :update, :destroy]

  # GET /contact_messages
  # GET /contact_messages.json
  def index
    @contact_messages = ContactMessage.all
  end

  # GET /contact_messages/1
  # GET /contact_messages/1.json
  def show
  end

  # GET /contact_messages/new
  def new
    @contact_message = ContactMessage.new
  end

  # GET /contact_messages/1/edit
  def edit
  end

  # POST /contact_messages
  # POST /contact_messages.json
  def create
    @contact_message = ContactMessage.new(contact_message_params)

    if @contact_message.save
      redirect_to @contact_message, notice: 'Contact message was successfully created.' 
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /contact_messages/1
  # PATCH/PUT /contact_messages/1.json
  def update
    if @contact_message.update(contact_message_params)
      redirect_to @contact_message, notice: 'Contact message was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /contact_messages/1
  # DELETE /contact_messages/1.json
  def destroy
    @contact_message.destroy
    redirect_to contact_messages_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact_message
      @contact_message = ContactMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_message_params
      params.require(:contact_message).permit(:name, :email, :message)
    end
end
