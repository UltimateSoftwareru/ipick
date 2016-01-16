class AddressSaver < BaseSaver
  private

  def options
    params.require(:data)[:relation]
  end

  def permitted
    %i(name phone address latitude longitude)
  end

  def deserialize(options)
    options = ActiveModelSerializers::Deserialization.jsonapi_parse(options, only: permitted)
    options[:user_id] = parent.user_id
    options
  end
end
