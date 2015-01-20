# spec/support/gooddata_rest.rb

RSpec.configure do |config|
  config.before(:each, :gooddata_rest_mock => true) do
    WebMock.disable_net_connect!
  end

  config.after(:each, :gooddata_rest_mock => true) do
    WebMock.allow_net_connect!
  end

  config.before(:each, :webmock_logging => true) do
    WebMock.after_request do |request_signature, response|
      puts "WEBMOCK REQUEST: #{request_signature}"
      puts "WEBMOCK RESPONSE: #{response.to_yaml}"
    end
  end
end

module GooddataRestSupport

  def initialize(*args, &block)
    super
    @job_log = Logging.logger['JobLog']
    @job_log.level = :debug
    @job_log.add_appenders(Logging.appenders.stdout)


    @stub_username = 'someone@example.com'
    @stub_password = 'monkeys'
    @stub_pid = 'd2xg1ood0pnvw57yckqbaj3nhvn1vhqs'
    @stub_obj = '4794'

    @stub_login_cookie = ['GDCAuthSST=DaSQdTLS6HUQ7yQG; path=/gdc/account; expires=Thu, 29-Jan-2015 18:12:24 GMT; secure; HttpOnly',
                           'GDCAuthTT=; path=/gdc; expires=Sun, 14-Dec-2014 18:12:24 GMT; secure; HttpOnly']
    @stub_token_cookie = 'GDCAuthTT=hD_YiifCAixQwr5PzDE4U2V4P7BBYanfqDJaQv3Rkyn39pkRpDX14Qsb4la0Q-rCniNZggoD7k7CZbpPhvOHnqJrMbb45UC0tp_CccAp7eqgmwyoE7QcfRQlWrmaMho18qRpeVSwjD7U8VVeHez5xOx1yKL-iUILKLQYOOTEgW97InYiOjE0MjExNzMzNDQsInUiOiIxMzc3NSIsImwiOiIwIiwiayI6ImEyNWExZWEzLTQwNWItNDY0ZS04NmY4LTEyOTllZTE0YjY0MyJ9;'
  end


  def stub_post_gdc_account_login
    stub_request(:post, "https://secure.gooddata.com/gdc/account/login")
      .with(:body => "{\"postUserLogin\":{\"login\":\"#{@stub_username}\",\"password\":\"#{@stub_password}\",\"remember\":1}}",
            :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'})
      .to_return(:status => 200, :body => "", :headers => { :set_cookie => @stub_login_cookie})
  end

  def stub_get_gdc_account_token
    stub_request(:get, "https://secure.gooddata.com/gdc/account/token")
      .with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Cookie'=> @stub_login_cookie.join(','), 'User-Agent'=>'Ruby'})
      .to_return(:status => 200, :body => "", :headers => { :set_cookie => @stub_token_cookie})
  end

  def stub_get_gdc_md_pid_query_reports
    stub_request(:get, "https://secure.gooddata.com/gdc/md/#{@stub_pid}/query/reports")
      .with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Cookie'=> @stub_token_cookie, 'User-Agent'=>'Ruby'})
      .to_return(:status => 200, :body => stub_response_reports, :headers => {})
  end

  def stub_post_gdc_xtab2_executor3(obj = @stub_obj)
    stub_request(:post, "https://secure.gooddata.com/gdc/xtab2/executor3")
      .with(:body => "{\"report_req\":{\"report\":\"/gdc/md/#{@stub_pid}/obj/#{obj}\"}}",
            :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/json', 'Cookie'=> @stub_token_cookie, 'User-Agent'=>'Ruby'})
      .to_return(:status => 200, :body => stub_response_executor3, :headers => {})
  end

  def stub_post_gdc_exporter_executor
    stub_request(:post, "https://secure.gooddata.com/gdc/exporter/executor")
      .with(:body => "{\"result_req\":{\"format\":\"csv\",\"result\":#{JSON.parse(stub_response_executor3).to_json}}}",
            :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/json', 'Cookie'=> @stub_token_cookie, 'User-Agent'=>'Ruby'})
      .to_return(:status => 200, :body => stub_download_uri_body_executed, :headers => {})
  end

  def stub_post_gdc_app_projects_pid_execute_raw(obj = @stub_obj)
    stub_request(:post, "https://secure.gooddata.com/gdc/app/projects/#{@stub_pid}/execute/raw")
       .with(:body => "{\"report_req\":{\"report\":\"/gdc/md/#{@stub_pid}/obj/#{obj}\"}}",
            :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/json', 'Cookie'=> @stub_token_cookie, 'User-Agent'=>'Ruby'})
       .to_return(:status => 200, :body => stub_download_uri_body_raw, :headers => {})
  end


  def stub_download_uri_id_executed
    'a06465d8ffe2e59410f1128c13a1552600000250'
  end

  def stub_download_uri_id_raw
    'OK15851446?q=eAFFjMEOgjAQRH%2BF7JlDiyUgV42JZ4%2BGkC0spklLsV0PhPDvtl48vpk3swOjtjSYCTp480BqHttK%0A1QLPQpGQdUvzSc0Namp0JQSUwIYtJfvhHRXRWLsVgVYfOHWOOJgxQvfsS0BOoD9Mmfc%2Fpm0l89OC%0ALh9dkOnlw1bcrymcTFwtbjcf3E%2BUcPTHF2B9NUE%3D%0A&c=9c51a373f710b2bdb55ac11e46a7b3dc'
  end

  def stub_download_uri_body_executed
    "{\"uri\":\"/gdc/exporter/result/#{@stub_pid}/#{stub_download_uri_id_executed}\"}"
  end

  def stub_download_uri_body_raw
    "{\"uri\":\"/gdc/projects/#{@stub_pid}/execute/raw/#{stub_download_uri_id_raw}\"}"
  end

  def stub_download_uri_executed
    stub_request(:get, "https://secure.gooddata.com/gdc/exporter/result/#{@stub_pid}/#{stub_download_uri_id_executed}")
       .with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Cookie'=> @stub_token_cookie, 'User-Agent'=>'Ruby'})
       .to_return(:status => 200, :body => Base64.decode64(stub_download_data_executed), :headers => { 'Content-Type' => 'text/csv;charset=utf8', 'Content-Encoding' => 'gzip'})
  end

  def stub_download_uri_raw
    stub_request(:get, "https://secure.gooddata.com/gdc/projects/#{@stub_pid}/execute/raw/#{stub_download_uri_id_raw}")
       .with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Cookie'=> @stub_token_cookie, 'User-Agent'=>'Ruby'})
       .to_return(:status => 200, :body => Base64.decode64(stub_download_data_raw), :headers => { 'Content-Type' => 'text/csv;charset=utf8', 'Content-Encoding' => 'gzip'})
  end


  def stub_response_reports(obj = @stub_obj)
    <<-EOT.unindent
     {
      "query": {
        "entries": [
          {
            "link": "/gdc/md/#{@stub_pid}/obj/#{obj}",
            "locked": 0,
            "author": "/gdc/account/profile/6e7b02ecce3236a4e92a218d8246f439",
            "tags": "",
            "created": "2015-01-13 19:22:13",
            "deprecated": "0",
            "identifier": "by7rafTHbjYD",
            "summary": "",
            "title": "Some silly report",
            "category": "report",
            "updated": "2015-01-13 19:22:13",
            "unlisted": 1,
            "contributor": "/gdc/account/profile/6e7b02ecce3236a4e92a218d8246f439"
          },
          {
            "link": "/gdc/md/#{@stub_pid}/obj/4794",
            "locked": 0,
            "author": "/gdc/account/profile/6e7b02ecce3236a4e92a218d8246f439",
            "tags": "",
            "created": "2015-01-13 19:33:39",
            "identifier": "aefrdtb2b807",
            "deprecated": "0",
            "summary": "",
            "title": "Supa Craza!",
            "category": "report",
            "updated": "2015-01-13 19:33:39",
            "unlisted": 1,
            "contributor": "/gdc/account/profile/6e7b02ecce3236a4e92a218d8246f439"
          }
        ],
        "meta": {
          "summary": "Metadata Query Resources for project '#{@stub_pid}'",
          "title": "List of reports",
          "category": "query"
        }
      }
    }
    EOT
  end


  def stub_response_executor3
    <<-EOF.unindent
    {
      "execResult": {
        "reportView": {
          "reportName": "Supa Craza!",
          "columnWidths": [

          ],
          "filters": [

          ],
          "rows": [
            {
              "drillDownStepAttributeDF": "/gdc/md/#{@stub_pid}/obj/74",
              "sort": "pk",
              "displayFormId": "/gdc/md/#{@stub_pid}/obj/98",
              "attributeTitle": "Month/Year (Transaction Date)",
              "summary": "Month and Year",
              "baseElementURI": "/gdc/md/#{@stub_pid}/obj/97/elements?id=",
              "title": "Month/Year (Transaction Date)",
              "attributeId": "/gdc/md/#{@stub_pid}/obj/97",
              "totals": [
                [

                ]
              ]
            }
          ],
          "sort": {
            "columns": [

            ],
            "rows": [

            ]
          },
          "oneNumber": {
            "labels": {
            }
          },
          "format": "grid",
          "columns": [
            {
              "displayFormId": "/gdc/md/#{@stub_pid}/obj/211",
              "attributeTitle": "Category ID",
              "summary": "",
              "baseElementURI": "/gdc/md/#{@stub_pid}/obj/210/elements?id=",
              "title": "Category ID",
              "attributeId": "/gdc/md/#{@stub_pid}/obj/210",
              "totals": [
                [

                ]
              ]
            },
            "metricGroup"
          ],
          "unlisted": 1,
          "metrics": [
            {
              "format": "#,##0.00",
              "summary": "",
              "title": "Amount [Sum]",
              "metricId": "/gdc/md/#{@stub_pid}/obj/4807"
            }
          ]
        },
        "reportDefinition": "/gdc/md/#{@stub_pid}/obj/4809",
        "dataResult": "/gdc/md/#{@stub_pid}/dataResult/5123351021603617792"
      }
    }
    EOF
  end

  def stub_download_data_executed_plaintext
    Zlib::GzipReader.new(StringIO.new(Base64.decode64(stub_download_data_executed))).read
  end

  def stub_download_data_executed
    <<-EOF.unindent
    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
    EOF
  end

  def stub_download_data_raw_plaintext
    Zlib::GzipReader.new(StringIO.new(Base64.decode64(stub_download_data_raw))).read
  end

  def stub_download_data_raw
    <<-EOF.unindent
    H4sIAAAAAAAAAKV925IcR5Ldu8z0D214WclsrJRxy8sLzIAmQVI72IEIamgz
    Mj0UGwV0GbqreusCCvv1isiMiPRbZEZJD2vLIaurMuPiftz9+PFX74+Hy+N/
    +8due7r7L7+dtofz9uGyPx7ufthedv/11V9e3fv//+V4+n73yw/+f715Pl4P
    l7v/9fH6/L9f/ef/9OqH3cOdbprB/6efTseH3Wm/O7/+eH3ZnZ63p6+7i//3
    fbfRDfnsj4fL7nTZ7g/Pu8Pl9fvjt/3u7sP19PC4Pe/O/r9razfGhT/6t+O3
    /EdPu4fL6XjYP5z9n/yxf9rd/bD7tn/Y3b15eQl/NWzs+Dcfdy/+b1Tj/9XH
    3Sl84ny3PXy6+5+X/dP+Ep7w78dfPtzdn3af9uEJTbNpmvnHlv7w5+P1vLu7
    f9ptD/vDl/FJXfzjvz1c0pP+sA//9e5v18tr/4+H3Sl8sFFxHeKvqLC4x8+f
    d7vXf7s8jp8x3aYbwkfe+92IHyk8iN+e7d3b7cPX6/jq3caN3/1u90f6w3f7
    w/bwsN8+3b3fHrZfduNSj7/k/+7w9e7dblxqZTatBr+p/b/7+fi8e/2v+8vD
    4+5w9/Fy/fw5fFBtOrpKcEt+2z353Tj7sxO2wi9LP376v18P6YnG4/Vy9Bsf
    Ttjrd0/7L49h/QfjNqqdd25cw9+2X3d4Bft20/fkK9/4w/ptWpH77fPLtCeq
    SXsyHbnpx/n3qY3TZLV/3m2fLo/jWr/bXw678/n1h9Pxstsfxn/nT/bL07iS
    Yemcf8mhC9/w5uWUD87Bb8q0Wz+c9oev/jrQfxP2y5/vATxh+Mv7x+1pf/n+
    ejxd00fDKfrdX8DwuK6N6w8WiZwf3WxMN63QU3qjn/afL+f8CesX0dGLRfbl
    7XV8uU0/kNPKl1B1/aY3ZA3B6X972m2/ft6eL9PhHux8UcDDfTieLw/b06fw
    s/400jsMD9n98fnlOq2HdW5jGrKG+RH/ej08PI7Hu90MCuyRks3P+c7bPL9I
    d2/3X+4+Ppx2u/EYd5t2OsXbQ7ochQt5/3S8frobr+XHy/HkL9x4LdVArmXc
    so+X7emP68N4GFodLUN86YVrH+3eh8fjYTeuwcbqOpNH/rJTG2PJbRYO//vt
    +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
    aIr+5O6XEGMw9QyOVeOMyP8LsYQ78yHwAAA=
    EOF
  end


end
