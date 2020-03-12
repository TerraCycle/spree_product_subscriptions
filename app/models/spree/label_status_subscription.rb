module Spree
  class LabelStatusSubscription < Spree::Subscription
    alias_attribute :frequency, :label_status

    with_options presence: true do
      validates :label_status
    end

    def process
      new_order = recreate_order
    end

    def add_variant_to_order(order)
      Spree::Cart::AddItem.call(
        order: order,
        variant: variant,
        quantity: 1
      )
      order.next
    end
  end
end
