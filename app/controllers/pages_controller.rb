class PagesController < ApplicationController
  def index
    sql = "SELECT * FROM client_bootstrap ORDER BY id DESC LIMIT 1"
    records_array = ActiveRecord::Base.connection.execute(sql).to_a

    html_content = records_array[0]['value']

    render html: html_content.html_safe
  end
end
