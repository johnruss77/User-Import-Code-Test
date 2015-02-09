# app/models/importer.rb
class Importer
  include ActiveModel::Validations
  include ActiveModel::Conversion

  VALID_IMPORT_TYPES = ['User']
  VALID_EXISTENCE_CHECKS = [:email]
  VALID_ASSOCIATION_TYPES = ['memberships']

  #checks to make sure only valid types are passed into the parser
  validates :import_type, inclusion: { in: VALID_IMPORT_TYPES }
  validates :association_type, inclusion: { in: VALID_ASSOCIATION_TYPES }
  validates :existence_check, inclusion: { in: VALID_EXISTENCE_CHECKS }

  attr_reader :parser, :import_type, :association, :association_type , :existence_check

  def initialize(attributes={})
    @parser = attributes[:parser]
    @import_type = attributes[:import_type]
    @association = attributes[:association]
    @association_type = attributes[:association_type]
    @existence_check  = attributes[:existence_check]
  end

  def import
    if valid?
      rows.each do |row|
       #a field can be passed in as a parameter which can be used to check
       #if that particular object alreadt exists in db - if it does saves the 
       # existing one, otherwise creates a brand new entry in db

          if existence_check.present?
          #existence_check = :email
          obj = import_klass.where({existence_check => row[existence_check]}).first
          if obj
            obj.attributes.merge(row.except(:association_attributes))
            obj.save!
          else
            obj = import_klass.create(row.except(:association_attributes))
          end
        else  
          obj = import_klass.create(row.except(:association_attributes))
        end

        obj.send(association_type).create(row[:association_attributes]) if row[:association_attributes].present? && !obj.new_record?
      end
    end
    rows
  end
  
  # used purely for testing the import routine from console
  def self.test_import 
    import_file = 'files/user_import.csv'
    import_type = 'User'

    @importer = Importer.new(
      parser: CSVParser.new({:import_file => import_file, :association => Project.first}),
      import_type: import_type,
      association_type: 'memberships',
      existence_check: :email
    )

    return @importer

  end

  private

  def rows
    parser.rows
  end

  def import_klass
    import_type.to_s.constantize
  end
end