module SpreeProductSubscriptions
  module LineItemDecorator
    def self.prepended(base)
      base.attr_accessor :subscription_frequency_id, :subscription_label_status_id, :subscribe

      base.after_create :create_subscription!, if: :subscribable?
      base.after_update :update_subscription_quantity, if: :can_update_subscription_quantity?
      base.after_update :update_subscription_attributes, if: :can_update_subscription_attributes?
      base.after_destroy :destroy_associated_subscription!, if: :subscription?
    end

    def subscription_attributes_present?
      subscription_label_status_id.present? || subscription_frequency_id.present?
    end

    def updatable_subscription_attributes
      {
        subscription_label_status_id: subscription_label_status_id || subscription.subscription_label_status_id,
        subscription_frequency_id: subscription_frequency_id || subscription.subscription_frequency_id,
      }
    end

    def subscribable?
      subscribe.present? && subscribe != "0"
    end

    def subscription?
      !!subscription
    end

    def subscription
      order.subscriptions.find_by(variant: variant)
    end

    private

    def create_subscription!
      order.subscriptions.create! subscription_attributes
    end

    def subscription_attributes
      {
        subscription_label_status_id: subscription_label_status_id,
        subscription_frequency_id: subscription_frequency_id,
        price: variant.price,
        variant: variant,
        quantity: quantity
      }
    end

    def update_subscription_quantity
      subscription.update(quantity: quantity)
    end

    def update_subscription_attributes
      subscription.update(updatable_subscription_attributes)
    end

    def destroy_associated_subscription!
      subscription.destroy!
    end

    def can_update_subscription_attributes?
      subscription? && subscription_attributes_present?
    end

    def can_update_subscription_quantity?
      subscription? && quantity_changed?
    end
  end
end

::Spree::LineItem.prepend(::SpreeProductSubscriptions::LineItemDecorator)
