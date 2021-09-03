module Xeroizer
  module Record
    module Payroll

      class PaymentMethodModel < PayrollBaseModel

        set_permissions :read, :write

        def api_url(options = {})
          "employees/#{options.delete(:employee_id)}/paymentMethods"
        end
      end

      class PaymentMethod < PayrollBase
        guid            :employee_id
        string          :payment_method
        has_many        :bank_accounts

        def to_api_json
          JSON.parse(super)
        end

        def api_url
          "employees/#{employee_id}/paymentMethods"
        end
      end
    end
  end
end
