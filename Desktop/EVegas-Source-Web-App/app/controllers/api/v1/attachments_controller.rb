class Api::V1::AttachmentsController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [:download] # Requires access token for all actions
  before_action :set_object, only: [:download]
  before_action :authenticate_user!, only: [:upload]
  include AttachmentModule

  def initialize()
    super(ATTACHMENT_ATTRIBUTE)
  end
  
  def upload
    # Check params require, params option, value params
    result = check_attachment_upload()
    if (result.result == false)
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    attachment = get_attachment_from_request(params[:file])
    list_result = []

    ActiveRecord::Base::transaction do
        _ok = create_attachment_file(attachment)
        raise ActiveRecord::Rollback, result.set_error_data(:bad_request, I18n.t('messages.error_500_info')) unless _ok
        list_result.push(attachment) if _ok
        break if !_ok
    end

    if (result.result == true)
      render_success_json(SuccessData.new(result.status, list_result), ATTACHMENT_ATTRIBUTE.create_except_params)
    else
      render_error_json(ErrorData.new(result.status, result.exception))
    end
  end

  def download
    version = params[:version]

    if @object.file.present?
      if is_blank(version)
        send_file URI.decode(@object.file.url)
      else
        case version
        when "thumb"
          send_file URI.decode(@object.file.thumb.url)
        when "medium"
          send_file URI.decode(@object.file.medium.url)
        else
          send_file URI.decode(@object.file.url)
        end
      end
    else
      send_file URI.decode("#{Rails.root}/public" + @object.file.default_url), filename: @object.name, type: @object.file.content_type, disposition: 'Your file has been downloaded'
    end
  end

end