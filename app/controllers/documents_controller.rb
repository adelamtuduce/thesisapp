# == Schema Information
#
# Table name: documents
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  created_at        :datetime
#  updated_at        :datetime
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  download_url      :string(255)
#  enroll_request_id :integer
#

class DocumentsController < ApplicationController
	before_filter :authenticate_user!
	skip_before_filter :verify_authenticity_token
	def new
		@document = Document.new
	end
	def create
		@document = Document.new(document_params)
  	@document.save

    if  params['document']['diploma_project_id']
      @document.diploma_project_id =  params['document']['diploma_project_id']
    end
  	@document.download_url = @document.file.url
  	@document.save

    redirect_to :back
	end

	private

  def document_params
    params.require(:document).permit(
      :file,
      :user_id,
      :enroll_request_id)
  end
end
