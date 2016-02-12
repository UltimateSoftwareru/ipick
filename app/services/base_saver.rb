class BaseSaver
  include Concord.new(:params, :parent, :relation)

  def parse
    return if !parent || !options
    if options.is_a? Array
      parent.transaction do
        parent.public_send(relation).delete_all
        options.map do |option|
          option = deserialize(option)
          if option[:id]
            address = Address.find_by(id: option[:id])
            address.update(option.except(:id))
            parent.public_send(relation) << address
          else
            parent.public_send(relation).create(option)
          end
        end
      end
    else
      option = deserialize(options)
      if parent.public_send(relation).nil?
        if option[:id]
          parent.update("#{relation}_id" => option[:id])
        else
          parent.public_send("create_#{relation}", option)
        end
      else
        parent.public_send(relation).update(option)
      end
    end
    parent.save!
  end

  private

  def options
    raise "Define in subclass"
  end

  def permitted
    raise "Define in subclass"
  end

  def deserialize(options)
    ActiveModelSerializers::Deserialization.jsonapi_parse(options, only: permitted)
  end
end
