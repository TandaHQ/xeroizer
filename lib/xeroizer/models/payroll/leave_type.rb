module Xeroizer
  module Record
    module Payroll

      class LeaveTypeModel < PayrollBaseModel
        set_permissions :read, :write, :update
      end

      class LeaveType < PayrollBase

        string        :name
        string        :type_of_units
        boolean       :is_paid_leave # if paid leave this will need :leave_category_code
        boolean       :show_on_payslip

        guid          :leave_type_id
        decimal       :normal_entitlement
        decimal       :leave_loading_rate
        string        :leave_category_code, api_name: 'LeaveCategoryCode' # https://developer.xero.com/documentation/api/payrollau/payitems#elements-for-leavetypes
        boolean       :SGC_exempt, api_name: 'SGCExempt' # list of what is exempt here: https://developer.xero.com/documentation/api/payrollau/types-and-codes#leavecategory

        datetime_utc  :updated_date_utc, :api_name => 'UpdatedDateUTC'

        validates_presence_of :name, :type_of_units, :is_paid_leave, :show_on_payslip, :SGC_exempt

      end

    end
  end
end
