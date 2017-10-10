require "./lib"
# require_relative "../pages/navi_links.rb"
require_tree "../lib"
require_tree "../pages"
require "csv"
require "pry"

class TestAdvanceSearch < Test::Unit::TestCase
  include CommonMethod

  class  << self
    def startup
      unless File.exist?("result/result_test_advance_search.csv")  
        CSV.open("result/result_test_advance_search.csv", "w") do |file|
          file << ["File name", "Run at", "Pass", "Fail", "Error"]
        end
      end
    end
  end

  def setup
    @driver = Selenium::WebDriver.for :chrome
    # @driver.manage().window().maximize()
    @driver.navigate.to("http://test.ymeet.me/")
    @page = HomePage.new(@driver)
    @client = Mysql2::Client.new(host: '192.168.1.2', port: '8533', username: 'root', password: '', database: 'ymm_staging') if @client.nil?
  end

  def teardown
    @driver.quit
  end

  def test_combine_search_condition
    begin
        @page.click_fb_login_btn
        login_fb(Data::EXIST_USER[:email], Data::EXIST_USER[:pass])
        @page = SearchPage.new(@driver)
        sleep 10
        # Go to advance search page
        @page.click_advance_search
        @page = AdvanceSearchPage.new(@driver)
        sleep 3
        @page.click_reset_btn

        if current_logged_in_users_info(Data::EXIST_USER[:email])["gender"] == 1
          user_license = get_user_license(Data::EXIST_USER[:email])
          if user_license.nil? || user_license["end_at"] < Time.now - 7.hours
            @page.click_advance_search_link
            sleep 1
            @page.click_read_more_link
            sleep 1
            @page = UpgradeInstructionPage.new(@driver)
            @page.click_upgrade_btn
            sleep 1
            @page = PaymentPage.new(@driver)
            @page.choose_viettel
            @page.enter_code_1("1720141")
            @page.enter_seri_no_1("1000001")
            @page.add_mobile_card
            @page.enter_code_2("1720142")
            @page.enter_seri_no_2("200002")
            @page.click_submit_btn
            sleep 7
            @page = PaymentThankyouPage.new(@driver)
            @page.click_continue_dating_btn
            sleep 1
            @page = AdvanceSearchPage.new(@driver)
            @page.click_reset_btn
            sleep 1
          end
        end

        @page.select_age_min(Data::SEARCH_CONDITIONS[:age_min])
        sleep 1
        @page.select_age_max(Data::SEARCH_CONDITIONS[:age_max])
        sleep 1

        # @page.select_constellation(Data::SEARCH_CONDITIONS[:constellation])
        # sleep 1
        @page.scroll_to("current_city")
        @page.select_height_min(Data::SEARCH_CONDITIONS[:height_min])
        sleep 1
        @page.select_height_max(Data::SEARCH_CONDITIONS[:height_max])
        sleep 1
        @page.scroll_to("ab")
        if Data::SEARCH_CONDITIONS[:body_types].any?
          Data::SEARCH_CONDITIONS[:body_types].each do |bt|
            @page.choose_body_type(bt)
          end
        end

        # @page.select_current_city(Data::SEARCH_CONDITIONS[:current_city])
        # sleep 1
        # @page.scroll_to("sport")
        # @page.select_home_town(Data::SEARCH_CONDITIONS[:home_town])
        # sleep 1

        sleep 2
        # @page.scroll_to("ab")
        if Data::SEARCH_CONDITIONS[:blood_types].any?
          Data::SEARCH_CONDITIONS[:blood_types].each do |blt|
            @page.choose_blood_type(blt)
          end
        end
        sleep 1

        @page.click_scroll_top
        sleep 1
        @page.click_basic_info_link
        sleep 1
        @page.click_education_job_link
        sleep 1
        if Data::SEARCH_CONDITIONS[:educations].any?
          Data::SEARCH_CONDITIONS[:educations].each do |ed|
            @page.choose_educations(ed)
          end
        end
        sleep 1
        @page.scroll_to("nongnghiep")
        if Data::SEARCH_CONDITIONS[:occupations].any?
          Data::SEARCH_CONDITIONS[:occupations].each do |oc|
            @page.choose_occupations(oc)
          end
        end

        @page.scroll_to_basic_info
        sleep 1
        @page.click_scroll_top
        sleep 1
        @page.click_education_job_link
        sleep 1
        @page.click_family_link
        sleep 1
        if Data::SEARCH_CONDITIONS[:relationship].any?
          Data::SEARCH_CONDITIONS[:relationship].each do |rs|
            @page.choose_relationship_statuses(rs)
          end
        end

        @page.scroll_to("other_house")
        if Data::SEARCH_CONDITIONS[:families].any?
          Data::SEARCH_CONDITIONS[:families].each do |f|
            @page.choose_families(f)
          end
        end
        sleep 1
        @page.click_family_link
        sleep 1
        @page.click_life_style_link
        sleep 1
        if Data::SEARCH_CONDITIONS[:intention_marriages].any?
          Data::SEARCH_CONDITIONS[:intention_marriages].each do |im|
            @page.choose_intention_marriages(im)
          end
        end
        sleep 1
        @page.scroll_to("sometime_smoke")
        if Data::SEARCH_CONDITIONS[:holidays].any?
          Data::SEARCH_CONDITIONS[:holidays].each do |h|
            @page.choose_holidays(h)
          end
        end
        sleep 1
        if Data::SEARCH_CONDITIONS[:drink_types].any?
          Data::SEARCH_CONDITIONS[:drink_types].each do |dt|
            @page.choose_drink_types(dt)  
          end
        end

        sleep 1
        if Data::SEARCH_CONDITIONS[:smoking_types].any? 
          Data::SEARCH_CONDITIONS[:smoking_types].each do |st|
            @page.choose_smoking_types(st)    
          end
        end
        sleep 1
        @page.scroll_to_basic_info
        sleep 1
        @page.click_life_style_link
        sleep 1

        @page.click_others_link
        @page.check_has_self_introduction if Data::SEARCH_CONDITIONS[:self_intro] == "Checked"
        @page.check_has_sub_photo if Data::SEARCH_CONDITIONS[:sub_photo] == "Checked"

        @page.click_search_btn
        @page = SearchPage.new(@driver)
        sleep 3 

        db_data = get_db_data(Data::EXIST_USER[:email], Data::SEARCH_CONDITIONS)
        puts @page.result_on_screen
        if db_data.any?
            @page.scroll_to_the_last_card
        end
        sleep 1
        if @page.get_last_card_id == db_data.count
            result = true
        else
            result = false
        end

        write_test_result_in_csv_file(result, "result_test_advance_search", "Test_combine_search_condition") 
    rescue Exception => e
        write_if_error_occur_in_csv_file("result_test_advance_search", "Test_combine_search_condition", e)
    end
    # puts @page.get_last_card_id
    # puts db_data.count
    assert(@page.get_last_card_id == db_data.count )  
  end

 
  def get_db_current_city(city_id)
    # (city_id.nil?) ? nil : (@client.query("SELECT name from cities where id = '#{city_id}'").to_a.first)
    @client.query("SELECT name from cities where id = '#{city_id}'").to_a.first
  end

  def get_occupation(occupation_id)
    # (occupation_id.nil?) ? nil : (@client.query("SELECT name FROM occupation_translations WHERE occupation_id = #{occupation_id} AND locale = 'vi'").to_a.first)
    @client.query("SELECT name FROM occupation_translations WHERE occupation_id = #{occupation_id} AND locale = 'vi'").to_a.first
  end

  def current_logged_in_users_info(email)
    @client.query("SELECT user_id, gender FROM personals WHERE user_id = (SELECT id from users where email = '#{email}') ").to_a.first  
  end

  def get_user_avatar(user_id)
    @client.query("SELECT * FROM avatars WHERE user_id = #{user_id}").to_a     
  end

  def get_user_photo(user_id)
    @client.query("SELECT * FROM photos WHERE user_id = #{user_id}").to_a
  end

  def get_db_data(email, options)
    cur_user = current_logged_in_users_info(email)
    sql = %Q(SELECT P.user_id, P.short_name, TIMESTAMPDIFF(YEAR, P.birthday, CURDATE()) AS age, P.current_city_id, P.occupation_id, P.job_position, P.height, P.intention_marriage, P.verification_status
                   FROM personals P 
                   JOIN users U ON P.user_id = U.id 
                   WHERE U.user_status = 1 
                   AND U.welcome_page_completion = 4
                   AND P.user_id <> 3759
                   AND P.user_id NOT IN (SELECT target_id FROM likes WHERE source_id = #{cur_user['user_id']})
                   AND P.user_id NOT IN (SELECT target_id FROM block_users WHERE source_id = #{cur_user['user_id']}  AND block_type = 1)
                   AND P.user_id NOT IN (SELECT source_id FROM block_users WHERE target_id = #{cur_user['user_id']}  AND block_type = 1)
                   AND P.user_id NOT IN (SELECT friend_user_id FROM facebook_friends WHERE user_id = #{cur_user['user_id']}) )
    if cur_user["gender"] == 1
      sql += "AND P.user_id NOT IN (SELECT female_id FROM matches WHERE male_id = #{cur_user['user_id']}) 
              AND P.gender = 2"
    else
      sql += "AND P.user_id NOT IN (SELECT male_id FROM matches WHERE female_id = #{cur_user['user_id']})
              AND P.gender = 1"
    end
        
    condition = []
    condition << "TIMESTAMPDIFF(YEAR, P.birthday, CURDATE()) >= #{options[:age_min].to_i}" if options[:age_min].to_i > 0
    condition << "TIMESTAMPDIFF(YEAR, P.birthday, CURDATE()) <= #{options[:age_max].to_i}" if options[:age_max].to_i > 0
    condition << "P.height >= #{options[:height_min].to_i}" if options[:height_min].to_i > 0
    condition << "P.height <= #{options[:height_max].to_i}" if options[:height_max].to_i > 0

    body_type_query = %Q(SELECT body_type_id FROM body_type_translations WHERE name )
    unless options[:body_types].to_s.empty? 
      unless options[:body_types].include?('Bất kỳ')
        if options[:body_types].count == 1
          body_type_query += "= '#{options[:body_types].first}' AND locale = 'vi'"
        else
          body_type_query += "IN ('#{options[:body_types].join("', '")}') AND locale = 'vi'"
        end
        condition << "P.body_type_id IN (" + body_type_query + ")"
      end
    end

    education_query = %Q(SELECT education_id FROM education_translations WHERE name )
    unless options[:educations].to_s.empty?
      unless  options[:educations].include?('Bất kỳ')
        if options[:educations].count == 1
          education_query += "= '#{options[:educations].first}' AND locale = 'vi'"
        else
          education_query += "IN ('#{options[:educations].join("', '")}') AND locale = 'vi'"
        end
        condition << "P.education_id IN (" + education_query + ")"
      end
    end

    occupation_query = %Q(SELECT occupation_id FROM occupation_translations WHERE name )
    unless options[:occupations].to_s.empty? 
      unless options[:occupations].include?('Bất kỳ')
        if options[:occupations].count == 1
          occupation_query += "= '#{options[:occupations].first}' AND locale = 'vi'"
        else
          occupation_query += "IN ('#{options[:occupations].join("','")}') AND locale = 'vi'"
        end
        condition << "P.occupation_id IN (" + occupation_query + ")"
      end
    end

    relationship_query = %Q(SELECT relationship_status_id FROM relationship_status_translations WHERE name )
    unless options[:relationship].to_s.empty? 
      unless options[:relationship].include?('Bất kỳ')
        if options[:relationship].count == 1
          relationship_query += "= '#{options[:relationship].first}' AND locale = 'vi'"
        else
          relationship_query += "IN ('#{options[:relationship].join("', '")}') AND locale = 'vi'"
        end
        condition << "P.relationship_status_id IN (" + relationship_query + ")"
      end
    end

    city_query = %Q(SELECT id FROM cities WHERE name )
    # hometown_query = ""
    # current_city_query = ""
    unless options[:home_town].to_s.empty? 
      unless options[:home_town].include?('Bất kỳ')
        if options[:home_town].count == 1
          home_town_query = city_query + "= '#{options[:home_town].first}'"
        else
          home_town_query = city_query + "IN ('#{options[:home_town].join("', '")}')"
        end
        condition << "P.home_town_id IN (" + home_town_query + ")"
      end
    end
    unless options[:current_city].to_s.empty? 
      unless options[:current_city].include?('Bất kỳ')
        if options[:current_city].count == 1
          current_city_query = city_query + "= '#{options[:current_city].first}' AND locale = 'vi'"
        else
          current_city_query = city_query + "IN ('#{options[:current_city].join("', '")}') AND locale = 'vi'"
        end
        condition << "P.current_city_id IN (" + current_city_query + ")"
      end
    end

    unless options[:constellations].to_s.empty?
      unless options[:constellations].include?('Bất kỳ')  
        constellations = []
        Data::CONSTELLATION_CONDITIONS.each do |con|
          options[:constellations].each do |v|
            if v == con[:label]
              constellations << con[:value]
            end
          end
        end
        condition << "constellation_type IN (" + constellations.join(",")  + ")" 
      end
    end

    unless options[:blood_types].to_s.empty?
      unless options[:blood_types].include?('Bất kỳ')  
        blood_types = []
        Data::BLOOD_TYPE_ON_SCREEN.each do |t|
          options[:blood_types].each do |v|
            if v == t[:label]
              blood_types << t[:value]
            end
          end
        end
        condition << "blood_type IN (" + blood_types.join(",")  + ")" 
      end
    end

    unless options[:families].to_s.empty?
      unless options[:families].include?('Bất kỳ')
        house_mate = []
        Data::HOUSE_MATES_ON_SCREEN.each do |hm|
          options[:families].each do |f|
            if f == hm[:label]
              house_mate << hm[:value]
            end
          end
        end
        condition << "house_mate IN (" + house_mate.join(",") + ")" 
      end
    end

    unless options[:intention_marriages].to_s.empty?
      unless options[:intention_marriages].include?('Bất kỳ')
        intention_marriages = []
        Data::INTENTION_MARRIAGE.each do |im|
          options[:intention_marriages].each do |i|
            if i == im[:label]
              intention_marriages << im[:value]
            end
          end
        end
        condition << "intention_marriage IN (" +  intention_marriages.join(",") + ")"
      end
    end

    unless options[:holidays].to_s.empty?
      unless options[:holidays].include?('Bất kỳ')
        holidays = []
        Data::HOLIDAYS_ON_SCREEN.each do |hl|
          options[:holidays].each do |h|
            if h == hl[:label]
              holidays << hl[:value]
            end
          end
        end
        condition << "holiday IN (" +  holidays.join(",") + ")" 
      end
    end

    unless options[:drink_types].to_s.empty?
      unless options[:drink_types].include?('Bất kỳ')  
        drink_types = []
        Data::DRINKINGS_ON_SCREEN.each do |dt|
          options[:drink_types].each do |d|
            if d == dt[:label]
              drink_types << dt[:value]
            end
          end
        end
        condition << "drinking IN (" +  drink_types.join(",") + ")" 
      end
    end

    unless options[:smoking_types].to_s.empty?
      unless options[:smoking_types].include?('Bất kỳ')
        smoking_types  = []
        Data::SMOKING_TYPE_ON_SCREEN.each do |st|
          options[:smoking_types].each do |s|
            if s == st[:label]
              smoking_types << st[:value]
            end
          end
        end
        condition << "smoking_type IN (" +  smoking_types.join(",") + ")" 
      end
    end
    sql += " AND " + condition.join(" AND ") if condition.any?
    sql += " AND (P.self_introduction is not null AND P.self_introduction <> '')" if options[:self_intro] == "Checked"
    sql += " AND P.user_id IN (SELECT user_id FROM photos)" if options[:sub_photo] == "Checked"
    # sql += " ORDER BY P.updated_at DESC, P.user_id DESC"
    @client.query(sql).to_a
  end

  def get_last_activity_time(user_id)
    sql = "SELECT MAX(created_at) as updated_at FROM activity_audits WHERE from_user_id = #{user_id} AND activity_code not in (27, 44, 45, 53)"
    @client.query(sql).to_a.first
  end

  def get_user_license(email)
    @client.query("SELECT * FROM user_licenses WHERE user_id = (SELECT id FROM users WHERE email = '#{email}') ORDER BY id DESC LIMIT 1").to_a.first
  end


end