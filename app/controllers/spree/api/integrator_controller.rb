module Spree
  module Api
    class IntegratorController < Spree::Api::BaseController
      prepend_view_path File.expand_path("../../../../app/views", File.dirname(__FILE__))

      before_filter :authorize_read!

      helper_method :variant_attributes,
                    :order_attributes

      respond_to :json

      def index
        @since = params[:since] || 1.day.ago
        @orders = orders @since
      end

      private
      def orders(since)
        Spree::Order.complete
                    .ransack(:updated_at_gteq => since).result
                    .page(params[:orders_page])
                    .per(params[:orders_per_page])
                    .order('updated_at ASC')
      end


      def variant_attributes
        [:id, :name, :product_id, :external_ref, :sku, :price, :weight, :height, :width, :depth, :is_master, :cost_price, :permalink]
      end

      def order_attributes
        [:id, :number, :item_total, :total, :state, :adjustment_total, :user_id, :created_at, :updated_at, :completed_at, :payment_total, :shipment_state, :payment_state, :email, :special_instructions, :total_weight, :locked_at]
      end

      def stock_transfer_attributes
        [:id, :reference_number, :created_at, :updated_at]
      end

      def authorize_read!
        unless current_api_user && current_api_user.has_spree_role?("admin")
          raise CanCan::AccessDenied
        end
      end
    end
  end
end
