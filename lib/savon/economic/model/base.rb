class Savon::Economic::Model::Base
  extend Operations

  #this is a cached copy of the https://www.e-conomic.com/secure/api1/EconomicWebservice.asmx?WSDL
  client wsdl: 'wsdls/economic.wsdl'

  class_operations :connect, :disconnect
  @@connected = false

  def self.config
    Settings.crm_config
  end

  def self.connect
    connections = config.select{|k,v| [:agreement_number, :user_name, :password].include? k}
    super connections do |resp|
      global(:headers, { 'cookie' => resp.http.headers['set-cookie']})
    end
    @@connected = true
  end

  def self.disconnect
    super
    @@connected = false
  end

  def self.request(operation, *args)
    @@connected || (operation == :connect) || connect
    begin
      super
    rescue Savon::SOAPFault => ex
      connect && super if ex.is_auth_not_logged?
    end
  end

  class_attribute :id_number, instance_writer:false
  self.id_number = :number



  class_operations  :create_from_data, :get_data, :get_all, :get_data_array, :delete, :update_from_data

  def self.find id
    id.is_a?(Array) ? by_ids(id) : get_data(entity_handle:{id_number => id})
  end

  def data
    self.class.find external_id
  end

  def import!
    save from_economic get_data
  end

  def from_economic hash
    self.class.from_economic hash
  end

  def self.all
    by_handles get_all
  end

  def self.ids_to_handles ids
    { self_handle => ids.map{|id|{id_number => id}}}
  end

  def self.by_ids ids
    by_handles ids_to_handles ids
  end

  def self.by_handles handles
    get_data_array(entity_handles: handles)[(snake_name+'_data').to_sym]
  end

  def self.self_handle
    (snake_name+'_handle').to_sym
  end

  def self.delete id
    super self_handle => {id_number => id}
  end

  def delete!
    check_external_id! 'delete'
    self.class.delete external_id
  end

  def self.create data
    create_from_data(data:data)[id_number]
  end

  def create! force = false
    throw Exception.new "Can not create #{self.class.name} (id=#{id}) with external_id" if external_id? && !force
    self.external_id = self.class.create for_economic
    save
    external_id
  end

  def self.update data
    update_from_data data:data
  end

  def update!
    check_external_id! 'update'
    self.class.update for_economic
  end

  def export
    external_id? ? update! : create!
  end

  def self.id_handle id
    {handle:{id_number => id}, id_number => id}
  end

  def external_id?
    external_id.to_i > 0
  end

  def check_external_id! action = ''
    throw Exception.new "Can not #{action} #{self.class.name} (id=#{id}) without external_id" unless external_id?
  end
end