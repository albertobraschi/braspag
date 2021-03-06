require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Braspag::Gateway do
  before do
    @merchant_id = "{84BE7E7F-698A-6C74-F820-AE359C2A07C2}"
    @connection = Braspag::Connection.new(@merchant_id, :test)
    @gateway = Braspag::Gateway.new(@connection)
    respond_with "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:soap='http://www.w3.org/2003/05/soap-envelope' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'><soap:Body><AuthorizeResponse xmlns='https://www.pagador.com.br/webservice/pagador'><AuthorizeResult><amount>1</amount><authorisationNumber>418270</authorisationNumber><message>Transaction Successful</message><returnCode>0</returnCode><status>1</status><transactionId>128199</transactionId></AuthorizeResult></AuthorizeResponse></soap:Body></soap:Envelope>"
  end

  context "on authorize!" do
    before :each do
      respond_with "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:soap='http://www.w3.org/2003/05/soap-envelope' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'><soap:Body><AuthorizeResponse xmlns='https://www.pagador.com.br/webservice/pagador'><AuthorizeResult><amount>1</amount><authorisationNumber>418270</authorisationNumber><message>Transaction Successful</message><returnCode>0</returnCode><status>1</status><transactionId>128199</transactionId></AuthorizeResult></AuthorizeResponse></soap:Body></soap:Envelope>"
    end

    it "deve enviar dados para webservice de autorizacao" do
      expected = <<STRING
  <?xml version='1.0' ?>
  <env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope">
    <env:Header />
    <env:Body>
      <tns:Authorize xmlns:tns="https://www.pagador.com.br/webservice/pagador">
        <tns:merchantId>#{@merchant_id}</tns:merchantId>
        <tns:orderId>teste564</tns:orderId>
        <tns:customerName>comprador de teste</tns:customerName>
        <tns:amount>1,00</tns:amount>
      </tns:Authorize>
    </env:Body>
  </env:Envelope>
STRING
      request_should_contain(expected)
      @gateway.authorize! :orderId => "teste564", :customerName => "comprador de teste", :amount => "1,00"
    end

    it "deve devolver o resultado em um mapa" do
      map = {"amount" =>"1", "authorisationNumber" => "418270", "message" => "Transaction Successful", "returnCode" => "0", "status" => "1", "transactionId" => "128199"}
      @gateway.authorize!(:orderId => "teste564", :customerName => "comprador de teste", :amount => "1,00").should == map
    end
  end

  context "on capture!" do
    before :each do
      respond_with "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:soap='http://www.w3.org/2003/05/soap-envelope' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'><soap:Body><CaptureResponse xmlns='https://www.pagador.com.br/webservice/pagador'><CaptureResult><amount>1</amount><authorisationNumber>418270</authorisationNumber><message>Transaction Successful</message><returnCode>0</returnCode><status>1</status><transactionId>128199</transactionId></CaptureResult></CaptureResponse></soap:Body></soap:Envelope>"
    end

    it "deve enviar dados para webservice de captura" do
      expected = <<STRING
  <?xml version='1.0' ?>
  <env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope">
    <env:Header />
    <env:Body>
      <tns:Capture xmlns:tns="https://www.pagador.com.br/webservice/pagador">
        <tns:merchantId>#{@merchant_id}</tns:merchantId>
        <tns:orderId>teste564</tns:orderId>
      </tns:Capture>
    </env:Body>
  </env:Envelope>
STRING
      request_should_contain(expected)
      @gateway.capture! :orderId => "teste564"
    end

    it "deve devolver o resultado em um mapa" do
      map = {"amount" =>"1", "authorisationNumber" => "418270", "message" => "Transaction Successful", "returnCode" => "0", "status" => "1", "transactionId" => "128199"}
      @gateway.capture!(:orderId => "teste564").should == map
    end
  end
end
