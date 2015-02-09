# app/models/csv_parser.rb:
require 'csv'
require 'fileutils'

class CSVParser

  attr_reader :csv_file, :association

  def initialize(params = {})
  	#get handle to uploaded csv
    @csv_file = params[:import_file]
    # if an association class has been passed in, this will be created in addition 
    # to the object itself
    @association = params[:association]
  end

  def rows
    # code that parses the CSV file and returns rows back
   
    details = []
    other_info_fields = []

    CSV.parse(File.open(@csv_file, 'rb')).each_with_index do |row, index|

      if index == 0
         #save header rows so these can be accessed
          row.last(row.size-5).each do |col_header|
            other_info_fields << col_header
          end
      else

      	new_row = {}
      	# these fields not generic, could be moved into a seperate subclass UserImporter for example
      	new_row[:email], new_row[:name], new_row[:born_on], new_row[:gender], new_row[:password]  = row[0..4]

      	# anything other than the required first 5 columns are saved into other info
      	# which will be passed in as a serialized hash intto an associated object
      	# eg 'membership'

      	if association.present?
	      	association_attributes = {}
	      	association_attributes[:other_info] = {}
			row.last(row.size-5).each_with_index do |column, col_num|
	          association_attributes[:other_info][other_info_fields[col_num].to_sym] = column
	        end

	        association_attributes[association_field] = association.id
	        new_row[:association_attributes] = association_attributes
    	end

        details << new_row
       
      end

    end

    return details

  end

  private

  def association_field
  	@association_field ||= "#{association.try(:class).to_s.downcase}_id"
  end
end