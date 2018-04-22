class PagesController < ApplicationController
  def index
    sql = generate_sql
    records_array = ActiveRecord::Base.connection.execute(sql).to_a

    html_content = records_array.present? ? records_array[0]['value'] : 'No html content'

    render html: html_content.html_safe
  end

  private

  def generate_sql
    if params[:revision]
      revision = ActiveRecord::Base.connection.quote(params[:revision])
      "SELECT value FROM client_bootstrap WHERE key = #{revision}"
    else
      "SELECT value FROM client_bootstrap WHERE is_active = true ORDER BY id DESC LIMIT 1"
    end
  end
end
