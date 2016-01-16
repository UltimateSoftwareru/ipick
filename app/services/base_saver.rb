class BaseSaver
  include Concord.new(:params, :parent, :relation)

  def parse
    return if !parent || !options
    if options.is_a? Array
      parent.transaction do
        parent.public_send(relation).delete_all
        options.map do |option|
          parent.public_send(relation).create(deserialize(option))
        end
      end
    else
      if parent.public_send(relation).nil?
        parent.public_send("create_#{relation}", deserialize(options))
      else
        parent.public_send(relation).update(deserialize(options))
      end
    end
    parent.save!
  end

  private

  def deserialize(options)
    ActiveModelSerializers::Deserialization.jsonapi_parse(options, only: permitted)
  end
end
