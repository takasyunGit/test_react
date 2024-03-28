module Paginate
  extend ActiveSupport::Concern

  class_methods do
    # key_id        このidを持つレコードを起点にレコードを取得する。
    # sort_order   "asc"または"desc"
    # per_page      1ページあたりの取得レコード数
    # order_column  ソートするカラム
    def paginate_order(key_id, sort_order, per_page, order_column)
      unless self.has_attribute?(order_column)
        raise ActiveRecord::StatementInvalid.new("no such column #{order_column} for #{self}")
      end

      order_column = order_column&.to_s
      klass_name = self.to_s.underscore + "s"
      key_record = self.where("#{klass_name}.id": key_id).first
      asc_desc = sort_order&.to_s&.downcase == "desc" ? ">" : "<"
      column_type = self.columns_hash[order_column].type
      case
      when column_type == :datetime
        key_record_value = "\"#{key_record.try(order_column)&.strftime('%Y-%m-%d %H:%M:%S')}\""
      else
        key_record_value = key_record.try(order_column)
      end

      # 対象ページのレコードを抽出
      if key_record
        records = self.where(
          <<~SQL.gsub(/\n/," ")
              (#{key_record_value} #{asc_desc} #{klass_name}.#{order_column})
            OR
              (#{key_record_value} = #{klass_name}.#{order_column} and #{key_record.id} < #{klass_name}.id)
          SQL
        )
      else
        records = self
      end
      records = records.order("#{klass_name}.#{order_column} #{sort_order&.to_s}").order("#{klass_name}.id asc").limit(per_page)

      # 各ページの最終レコードのみ抽出
      from_table = self.select(
        <<~SQL.gsub(/\n/," ")
          CASE (ROW_NUMBER() OVER(ORDER BY #{klass_name}.#{order_column} #{sort_order&.to_s}, #{klass_name}.id asc) % #{per_page})
          WHEN 0 THEN 1
          ELSE 0
          END page_boundary
        SQL
      )
      paginate_key_ids = self.unscoped
        .select("x.id, ROW_NUMBER() OVER(order by x.#{order_column} #{sort_order&.to_s}, x.id asc) + 1 page_number")
        .from(from_table, "x")
        .where("x.page_boundary = 1")
        .order("page_number asc")

      paginate_key_hash = {1 => nil}
      paginate_key_ids.map do |r|
        paginate_key_hash.store(r.page_number, r.id)
      end

      return {"records": records, "paginate": paginate_key_hash}
    end
  end
end