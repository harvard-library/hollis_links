namespace :hl do
  # Batch import expects argument: SRC=$directory_name
  # Will take argument: EMAIL=$admin@email.com
  desc "Import all xlsx/csv files in provided directory"
  task :batch_import => :environment do
    path = File.absolute_path(ENV['SRC'])
    failures = []
    ActiveRecord::Base.transaction do
      files = Dir.glob(File.join(path, '*.csv')) + Dir.glob(File.join(path, '*xlsx'))
      files.each do |file|
        puts "Processing '#{file}'"
        if file.match(/\.xlsx$/)
          excel = Roo::Excelx.new(file)
          ll = LinkList.import_xlsx(excel)
        else
          csv = CSV.read(file)
          ll = LinkList.import_csv(csv)
        end
        ll.fetch_metadata
        ll.last_touched_by = ENV['EMAIL'] if ENV['EMAIL']

        begin
          old = LinkList.find_by(ll.attributes.slice('ext_id', 'ext_id_type'))
          old.last_touched_by = ENV['EMAIL'] if (old && ENV['EMAIL'])

          unless old
            ll.save!
          else
            old.update! ll.attributes.except('id')
          end
        rescue
          puts "Failure processing: '#{file}'"
          failures << file
        end
      end

      if failures.length > 0
        puts "Failures:"
        puts failures.map {|el| "\t#{el}"}.join("\n")
        ActiveRecord::Rollback
      end
    end
  end

  desc "Create an initial admin user for the app."
  task :bootstrap => :environment do
    raise "Already users in the DB, illegal attempt to re-bootstrap" if User.count > 0
    password = SecureRandom::base64.sub(/=+$/, '')
    User.create!(:email => "admin@#{ENV['ROOT_URL']}", :password => password)
    puts <<-DISPLAY
      Admin account created!
      ======================
      Email:    admin@#{ENV['ROOT_URL']}
      Password: #{password}
    DISPLAY
  end
  
  desc "Create an local admin user for the app."
  task :localadmin => :environment do
    if User.count == 0
    User.create!(:email => "admin@listview.com", :password => 'admin1234')
	    puts <<-DISPLAY
	      Admin account created!
	      ======================
	      Email:    admin@listview.com
	      Password: admin1234
	    DISPLAY
	else
		puts "Already users in the DB, will not re-create a local admin" 
    end
  end
end
