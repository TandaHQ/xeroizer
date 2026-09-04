require 'test_helper'

class PayItemsTest < Test::Unit::TestCase
  include TestHelper
  
  def setup
    @client = Xeroizer::PublicApplication.new(CONSUMER_KEY, CONSUMER_SECRET).payroll
    mock_api('PayItems')
  end

  test "get all" do
    pay_items = @client.PayItem.first
    assert_equal 5, pay_items.earnings_rates.size
    assert_equal 5, pay_items.deduction_types.size
    assert_equal 2, pay_items.reimbursement_types.size
    assert_equal 10, pay_items.leave_types.size

    doc = Nokogiri::XML pay_items.to_xml
    assert_equal 5, doc.xpath("/PayItems/EarningsRates/EarningsRate").size
    assert_equal 5, doc.xpath("/PayItems/DeductionTypes/DeductionType").size
    assert_equal 2, doc.xpath("/PayItems/ReimbursementTypes/ReimbursementType").size
    assert_equal 10, doc.xpath("/PayItems/LeaveTypes/LeaveType").size
  end

  test "reads IsQualifyingEarnings from Xero earnings rates and sends it back" do
    pay_items = @client.PayItem.first
    ordinary = pay_items.earnings_rates.find { |er| er.name == "Ordinary Hours" }
    overtime = pay_items.earnings_rates.find { |er| er.name == "Overtime Hours (exempt from super)" }
    assert_equal true, ordinary.attributes[:is_qualifying_earnings]
    assert_equal false, overtime.attributes[:is_qualifying_earnings]

    doc = Nokogiri::XML pay_items.to_xml
    flags = doc.xpath("/PayItems/EarningsRates/EarningsRate/IsQualifyingEarnings").map(&:text)
    assert_equal pay_items.earnings_rates.size, flags.size
    assert_includes flags, "false"
  end

  test "reads IsQualifyingEarnings from Xero leave types and sends it back" do
    pay_items = @client.PayItem.first
    assert pay_items.leave_types.all? { |lt| [true, false].include?(lt.attributes[:is_qualifying_earnings]) }

    doc = Nokogiri::XML pay_items.to_xml
    assert_equal pay_items.leave_types.size, doc.xpath("/PayItems/LeaveTypes/LeaveType/IsQualifyingEarnings").size
  end
end
