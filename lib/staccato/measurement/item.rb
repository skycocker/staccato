module Staccato
  module Measurement
    # Measurement class for items in a transaction or other action
    # useful when you don't use enhanced e-commerce
    class Item
      # lookup key for use in Hit#add_measurement
      # @return [Symbol]
      def self.lookup_key
        :item
      end

      # Item measurement options fields
      FIELDS = {
        name: 'in', # text
        price: 'ip', # currency (looks like a double?)
        quantity: 'iq', # integer
        code: 'ic', # text
        category: 'iv' # text
      }.freeze

      include Measurable
    end
  end
end
