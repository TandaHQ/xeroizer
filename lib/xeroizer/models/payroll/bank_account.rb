module Xeroizer
  module Record
    module Payroll

      class BankAccountModel < PayrollBaseModel

      end

      class BankAccount < PayrollBase

        string      :statement_text
        string      :account_name
        string      :bsb, :api_name => 'BSB'
        string      :account_number
        boolean     :remainder
        decimal     :percentage
        decimal     :amount

        # uk
        string      :sort_code

        def to_api_json
          JSON.parse(super)
        end
      end
    end
  end
end
