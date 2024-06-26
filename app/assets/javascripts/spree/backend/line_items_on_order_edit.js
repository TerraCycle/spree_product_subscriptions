// This file contains the code for interacting with line items in the manual cart
$(document).ready(function() {
  'use strict'

  // handle variant selection, show stock level
  $('#add_line_item_variant_id').change(function() {
    var variantId = $(this).val()

    var variant = _.find(window.variants, function(variant) {
      return variant.id == variantId
    })

    $('#stock_details').html(variantLineItemTemplate({ variant: variant }))
    $('#stock_details').show()
    $('button.add_variant').click(addVariant)

    // function added for susbcription orders
    disableSubscriptionFieldsOnOneTimeOrder(variantId)
  })
})

function addVariant () {
  $('#stock_details').hide()
  var variantId = $('select.variant_autocomplete').val()
  var quantity = $('input#variant_quantity').val()

  // fields added for making subscription order
  var subscribe = $("input.subscribe[data-variant-id='" + variantId + "']:checked").val()
  var frequency = $("select#frequency[data-variant-id='" + variantId + "']").val()

  adjustLineItems(order_number, variantId, quantity, subscribe, frequency)
  return 1
}

// function modified for subscription order fields
adjustLineItems = function(order_number, variant_id, quantity, subscribe, frequency) {
  var url = Spree.routes.orders_api + "/" + order_number + '/line_items'

  $.ajax({
    type: "POST",
    url: Spree.url(url),
    data: {
      line_item: {
        variant_id: variant_id,
        quantity: quantity,
        options: { subscribe: subscribe,
          subscription_frequency_id: frequency
        }
      },
      token: Spree.api_key
    }
  }).done(function() {
    window.Spree.advanceOrder()
    window.location.reload()
  }).fail(function(msg) {
    if (typeof msg.responseJSON.message != 'undefined') {
      alert(msg.responseJSON.message)
    } else {
      alert(msg.responseJSON.exception)
    }
  })
}

// function added for subscription fields
disableSubscriptionFieldsOnOneTimeOrder = function(variant_id) {
  var frequency = $("select#frequency[data-variant-id='" + variant_id + "']")
  $("input.subscribe[data-variant-id='" + variant_id + "']").on("change", function() {
    if (!parseInt($(this).val())) {
      frequency.attr("disabled", "disabled")
    } else {
      frequency.removeAttr("disabled")
    }
  })
}
