Then /^the freshbooks client id for "([^"]+)" is set correctly$/ do |user_email|
  registration = Registration.find_by_email!(user_email)
  last_client = FakeFreshbooks.last_client
  last_client.client_id.to_i.should == registration.freshbooks_client_id.to_i
end

Then /^a freshbooks invoice for "([^"]+)" is created with:$/ do |user_email, invoice_data|
  registration = Registration.find_by_email!(user_email)
  section      = registration.section
  last_invoice = FakeFreshbooks.last_invoice
  last_invoice.should be, "Expected an invoice on Freshbooks, but couldn't find one"
  invoice_doc = last_invoice.request_doc
  Hash[invoice_data.raw].each do |k, v|
    invoice_doc.at(k).text.should == v
  end

  invoice_doc.at("return_uri").text.should match section_path(section)
end

Then /^the invoice for "([^"]*)" has the following line items?:$/ do |user_email, line_items|
  registration = Registration.find_by_email!(user_email)
  last_invoice = FakeFreshbooks.last_invoice
  last_invoice.should be, "Expected an invoice on Freshbooks, but couldn't find one"
  invoice_doc = last_invoice.request_doc
  line_items.hashes.each do |line_item|
    line_item.each do |key, value|
      invoice_doc.at("lines line #{key}").text.should == value
    end
  end
end

Then /^the invoice for "([^"]*)" has a discount of "([^"]*)"$/ do |user_email, discount|
  registration = Registration.find_by_email!(user_email)
  last_invoice = FakeFreshbooks.last_invoice
  last_invoice.should be, "Expected an invoice on Freshbooks, but couldn't find one"
  invoice_doc = last_invoice.request_doc
  invoice_doc.at("discount").text.should == discount
end
