namespace :data do
  desc 'Cleanup all data.'
  task :reset => :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
  end

  desc 'Reset all counters.'
  task :reset_counters => :environment do
    { 'Course' => 'groups', 'Group' => 'holes' }.each do |k, v|
      k.classify.constantize.all.each do |m|
        k.classify.constantize.reset_counters m.id, v.to_sym
      end
    end
  end

  desc 'Migrate the data of courses from YamiGolf.'
  task :migrate => :environment do
    bench = Benchmark.measure do
      DB = Sequel.connect(adapter: 'mysql2', host: 'localhost', user: 'root', password: '', database: 'augusta_staging')
      DB[:course_provinces].each do |province|
        Province.create!(name: province[:province_name])
      end
      DB[:course_cities].each do |city|
        City.create!(province_id: city[:province_id], name: city[:city_name])
      end
      DB[:course_courses].each do |course|
        club = DB[:course_clubs].filter(id: course[:club_id]).first
        Course.create!(uuid: course[:uuid],
          city_id: course[:city_id],
          latitude: course[:latitude],
          longitude: course[:longitude],
          description: course[:detail_info],
          name: club[:club_name])
      end
      DB[:course_sub_courses].each do |sub_course|
        course = DB[:course_courses].filter(id: sub_course[:course_id]).first
        Group.create!(uuid: sub_course[:uuid],
          course_id: Course.find_uuid(course[:uuid]).id,
          name: sub_course[:sub_course_name])
      end
      DB[:course_holes].each do |hole|
        sub_course = DB[:course_sub_courses].filter(id: hole[:sub_course_id]).first
        fairway = DB[:course_fairways].filter(hole_id: hole[:id]).first
        hole = Hole.create!(uuid: fairway[:uuid],
          group_id: Group.find_uuid(sub_course[:uuid]).id,
          name: hole[:hold_no],
          par: fairway[:pole_number])
        [:red, :white, :blue, :black, :gold].each do |tee_box_color|
          TeeBox.create!(hole: hole,
            color: tee_box_color,
            distance_from_hole: 999)
        end
      end
    end
    p "finished in #{bench.real} second(s)"
  end

  desc 'Import data at Mar 30, 2015.'
  task :import_150330 => :environment do
    bench = Benchmark.measure do
      csv_text = File.read(File.join(Rails.root, 'db', 'data', '150330.csv'))
      csv = CSV.parse(csv_text, headers: false)
      csv.each do |row|
        unless Venue.where("name like '#{row[2]}'").any?
          province = Province.where(name: row[0]).first_or_create
          city = City.where(province_id: province.id).where(name: row[1]).first_or_create
          Venue.create!(city: city, name: row[2], address: row[3])
        else
          puts "duplicated venue: #{row[2]}"
        end
      end
    end
    p "finished in #{bench.real} second(s)"
  end

  desc 'Import data at Jun 9, 2015.'
  task :import_150609 => :environment do
    bench = Benchmark.measure do
      DB = Sequel.connect(adapter: 'mysql2', host: 'localhost', user: 'root', password: '', database: 'augusta_hanban')
      count = 0
      DB[:tee_boxes].filter('distance_from_hole <> 999').each do |tee_box|
        if origin_tee_box = TeeBox.where(hole_id: tee_box[:hole_id], color_cd: tee_box[:color_cd]).first
          origin_tee_box.update!(distance_from_hole: tee_box[:distance_from_hole]) if origin_tee_box.distance_from_hole == 999
        end
      end
    end
    p "finished in #{bench.real} second(s)"
  end

  namespace :populate do
    desc 'Populate some user\'s matches and scorecards data.'
    task :matches_and_scorecards => :environment do
      bench = Benchmark.measure do
        User.all.each do |user|
          15.times do
            venue = Venue.all.joins(:courses).where(courses: { holes_count: [9, 18] }).sample
            (courses = []) << venue.courses.where(holes_count: [9, 18]).sample
            courses << venue.courses.where(holes_count: 9).where.not(id: courses.first.id).first unless courses.first.holes_count == 18
            courses.compact!
            courses << venue.courses.where(holes_count: 9).first unless courses.map(&:holes_count).reduce(:+) == 18
            Match.create_practice(owner: user, courses: courses, tee_boxes: ['red', 'red'])
          end if user.matches.blank?
        end
      end
      p "finished in #{bench.real} second(s)"
    end
  end
end