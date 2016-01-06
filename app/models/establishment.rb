class Establishment < ActiveRecord::Base
  
  has_many :schools
  
  def self.search(search)
    if search
       where('lower(name) LIKE ?', "%#{search.downcase}%")
    else
       all
    end
  end
  
  # export CSV
  def self.to_csv(options = {})
    (CSV.generate(options) do |csv|
      csv << column_names
      all.each do |establishment|
        csv << establishment.attributes.values_at(*column_names)
      end
    end).encode('WINDOWS-1252', :undef => :replace, :replace => '')
  end
  
  # import CSV
  def self.import(file)
    allowed_attributes = ["id","code", "name", "department", "state", "phone", "email"]
    CSV.foreach(file.path, headers: true, :encoding => 'WINDOWS-1252') do |row|
      establishment = find_by_code(row["code"]) || new
      establishment.attributes = row.to_hash.select { |k,v| allowed_attributes.include? k }
      establishment.save!
    end
  end
end
