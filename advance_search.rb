require "./lib"

class AdvanceSearchPage < Page::Base


  pannel_heading = [
    {link: "basic_info",     label: "Thông tin cơ bản"},
    {link: "education_job",  label: "Học vấn - Nghề nghiệp"},
    {link: "family",         label: "Gia đình"},
    {link: "life_style",     label: "Quan điểm - Phong cách sống"},
    {link: "others",         label: "Khác"},
    {link: "advance_search", label: "Tìm kiếm nâng cao"},
    {link: "read_more",      label: "Tìm hiểu thêm"}
  ]

  pannel_heading.each do |header|
    define_method "click_#{header[:link]}_link" do 
      e(link: "#{header[:label]}").click
    end

    define_method "scroll_to_#{header[:link]}" do
      e(link: "#{header[:label]}").location_once_scrolled_into_view
      sleep 1
    end
  end

  id_accessor %w( age_min age_max fourthStep)

  def select_age_min(min_a)
    age_min.click
    Selenium::WebDriver::Support::Select.new(age_min).select_by(:text, "#{min_a}")
    age_min.click
  end

  def select_age_max(max_a)
    age_max.click
    Selenium::WebDriver::Support::Select.new(age_max).select_by(:text, "#{max_a}")
    age_max.click   
  end

  def click_search_btn
    fourthStep.click
  end

  css_selectors = {
    constellation: "div.Select-control",
    current_city:  "div.Select-placeholder",
    home_town:     "#react-select-4--value > div.Select-placeholder",
    height_min:    "div.row.js-validate-height > div.col-xs-6 > select.js-validate-to.form__input--b",
    height_max:    "div.row.js-validate-height > div.col-xs-6 > select.js-validate-from.form__input--b",
  }
  css_accessor css_selectors

  def select_height_min(min_h)
    height_min.click
    Selenium::WebDriver::Support::Select.new(height_min).select_by(:text, "#{min_h}")
    height_min.click  
  end

  def select_height_max(max_h)
    height_max.click
    Selenium::WebDriver::Support::Select.new(height_max).select_by(:text, "#{max_h}")
    height_max.click  
  end

  # def select_constellation(constella)
  #   binding.pry
  #   constellation.click
  #   Selenium::WebDriver::Support::Select.new(constellation).select_by(:text, "#{constella}")
  #   constellation.click
  # end

  # def select_home_town(hometown)
  #   home_town.click
  #   Selenium::WebDriver::Support::Select.new(home_town).select_by(:text, "#{hometown}")
  #   home_town.click
  # end

  # def select_current_city(curr_city)
  #   current_city.click
  #   Selenium::WebDriver::Support::Select.new(current_city).select_by(:text, "#{curr_city}")
  #   current_city.click
  # end

  def reset_btn
    e(xpath: "//button[@type='reset']")
  end

  def click_reset_btn
    reset_btn.click
  end

  def click_scroll_top
    e(css: "a.scroll-top").click
  end

  body_types ={
    random_body: "//div[@id='body_type_ids']/div/label",
    thin:        "//div[@id='body_type_ids']/div[2]/label",
    medium:      "//div[@id='body_type_ids']/div[3]/label",
    sport:       "//div[@id='body_type_ids']/div[4]/label",
    strong:      "//div[@id='body_type_ids']/div[5]/label",
    fat:         "//div[@id='body_type_ids']/div[6]/label",
    big:         "//div[@id='body_type_ids']/div[7]/label",
    tall:        "//div[@id='body_type_ids']/div[8]/label"
  } 
  xpath_accessor body_types

  def choose_body_type(body_type)
    Data::BODY_TYPES.each do |k, v|
      if body_type == v
        eval(k.to_s).click
      end
    end
  end

  blood_types = {
    random_blood: "//div[@id='blood_types']/div/label",
    a:            "//div[@id='blood_types']/div[2]/label",
    b:            "//div[@id='blood_types']/div[3]/label",
    o:            "//div[@id='blood_types']/div[4]/label",
    ab:           "//div[@id='blood_types']/div[5]/label",
  }
  xpath_accessor blood_types

  def choose_blood_type(blood_type)
    Data::BLOOD_TYPE.each do |k, v|
      if blood_type == v
        eval(k.to_s).click
      end  
    end
  end

  educations = {
    batky:     "//div[@id='education_ids']/div/label",        
    thpt:      "//div[@id='education_ids']/div[2]/label",      
    totnghiep: "//div[@id='education_ids']/div[3]/label",
    hocnghe:   "//div[@id='education_ids']/div[4]/label",      
    trungcap:  "//div[@id='education_ids']/div[5]/label",         
    caodang:   "//div[@id='education_ids']/div[6]/label",  
    daihoc:    "//div[@id='education_ids']/div[7]/label",
    thacsi:    "//div[@id='education_ids']/div[8]/label",
    tiensi:    "//div[@id='education_ids']/div[9]/label"
  }          
  xpath_accessor educations

  def choose_educations(education)
    Data::EDUCATIONS.each do |k, v|  
      if education == v
        eval(k.to_s).click
      end
    end
  end


  jobs = {
    random_job:  "//div[@id='occupation_ids']/div/label",
    nghethuat:   "//div[@id='occupation_ids']/div[2]/label",
    kinhdoanh:   "//div[@id='occupation_ids']/div[3]/label",
    kythuat:     "//div[@id='occupation_ids']/div[4]/label", 
    luatphap:    "//div[@id='occupation_ids']/div[5]/label", 
    yduoc:       "//div[@id='occupation_ids']/div[6]/label", 
    giaoduc:     "//div[@id='occupation_ids']/div[7]/label", 
    baochi:      "//div[@id='occupation_ids']/div[8]/label", 
    giaitri:     "//div[@id='occupation_ids']/div[9]/label", 
    truyenthong: "//div[@id='occupation_ids']/div[10]/label", 
    amthuc:      "//div[@id='occupation_ids']/div[11]/label", 
    hanhchinh:   "//div[@id='occupation_ids']/div[12]/label", 
    thethao:     "//div[@id='occupation_ids']/div[13]/label", 
    congan:      "//div[@id='occupation_ids']/div[14]/label", 
    quandoi:     "//div[@id='occupation_ids']/div[15]/label", 
    xaydung:     "//div[@id='occupation_ids']/div[16]/label", 
    taichinh:    "//div[@id='occupation_ids']/div[17]/label", 
    nganhang:    "//div[@id='occupation_ids']/div[18]/label", 
    cntt:        "//div[@id='occupation_ids']/div[19]/label", 
    nongnghiep:  "//div[@id='occupation_ids']/div[20]/label", 
    vantai:      "//div[@id='occupation_ids']/div[21]/label", 
    dulich:      "//div[@id='occupation_ids']/div[22]/label", 
    sinhvien:    "//div[@id='occupation_ids']/div[23]/label", 
    chuadilam:   "//div[@id='occupation_ids']/div[24]/label", 
    khac:        "//div[@id='occupation_ids']/div[25]/label"
  }
  xpath_accessor jobs

  def choose_occupations(occupation)
    Data::OCCUPATIONS.each do |k, v|  
      if occupation == v
        eval(k.to_s).click
      end
    end
  end

  relationship_status = {
    random_relationship: "//div[@id='marital_status_ids']/div/label",
    single:              "//div[@id='marital_status_ids']/div[2]/label",
    divorced:            "//div[@id='marital_status_ids']/div[3]/label",
    widower_relict:      "//div[@id='marital_status_ids']/div[4]/label"
    # random_relationship: "//div[@id='relationship_statuses']/div/label",
    # single:              "//div[@id='relationship_statuses']/div[2]/label",
    # divorced:            "//div[@id='relationship_statuses']/div[3]/label",
    # widower_relict:      "//div[@id='relationship_statuses']/div[4]/label"
  }

  xpath_accessor relationship_status

  def choose_relationship_statuses(relationship)
    Data::RELATIONSHIP_STATUSES.each do |k, v|  
      if relationship == v
        eval(k.to_s).click
      end
    end
  end

  house_mate_type = {
    random_house: "//div[@id='house_mate_types']/div/label",
    alone:        "//div[@id='house_mate_types']/div[2]/label",
    with_friend:  "//div[@id='house_mate_types']/div[3]/label",
    with_pet:     "//div[@id='house_mate_types']/div[4]/label",
    with_family:  "//div[@id='house_mate_types']/div[5]/label", 
    other_house:  "//div[@id='house_mate_types']/div[6]/label"
  }
  xpath_accessor house_mate_type

  def choose_families(house_mate)
    Data::HOUSE_MATES.each do |k, v|  
      if house_mate == v
        eval(k.to_s).click
      end
    end
  end

  def click_life_style_link
    e(link: "Quan điểm - Phong cách sống").click
  end

  intention_marriages = {
    random_marry:       "//div[@id='intention_marriages']/div/label",
    marry_soon:         "//div[@id='intention_marriages']/div[2]/label",
    from_three_yesr:    "//div[@id='intention_marriages']/div[3]/label",
    meet_soul_mate:     "//div[@id='intention_marriages']/div[4]/label",
    dont_want_to_marry: "//div[@id='intention_marriages']/div[5]/label",
    dont_know:          "//div[@id='intention_marriages']/div[6]/label"
  }
  xpath_accessor intention_marriages

  def choose_intention_marriages(intention_marriage)
    Data::INTENTION_MARRIAGE_SEARCH_CONDITIONS.each do |k, v|  
      if intention_marriage == v
        eval(k.to_s).click
      end
    end
  end

  hodiday_types = {
    random_holiday: "//div[@id='holiday_types']/div/label",
    sat_n_sun:      "//div[@id='holiday_types']/div[2]/label",
    in_week:        "//div[@id='holiday_types']/div[3]/label",
    not_fix:        "//div[@id='holiday_types']/div[4]/label",
    other_holiday:  "//div[@id='holiday_types']/div[5]/label"
  }
  xpath_accessor hodiday_types

  def choose_holidays(holiday)
    Data::HOLIDAYS.each do |k, v|  
      if holiday == v
        eval(k.to_s).click
      end
    end
  end

  drink_types = {
    random_drink:   "//div[@id='drink_types']/div/label",
    drink:          "//div[@id='drink_types']/div[2]/label",
    no_drink:       "//div[@id='drink_types']/div[3]/label",
    sometime_drink: "//div[@id='drink_types']/div[4]/label"
  }
  xpath_accessor drink_types

  def choose_drink_types(drink_type)
    Data::DRINKINGS.each do |k, v|  
      if drink_type == v
        eval(k.to_s).click
      end
    end
  end

  smoking_types = {
    random_smoking: "//div[@id='smoking_types']/div/label",
    smoke:          "//div[@id='smoking_types']/div[2]/label",
    no_smoke:       "//div[@id='smoking_types']/div[3]/label",
    sometime_smoke: "//div[@id='smoking_types']/div[4]/label"
  }
  xpath_accessor smoking_types

  def choose_smoking_types(smoking_type)
    Data::SMOKING_TYPES.each do |k, v|  
      if smoking_type == v
        eval(k.to_s).click
      end
    end
  end

  others = {
    has_self_introduction: "//div[@id='root']/div/div/div[2]/div/form/div[5]/div/div/div/div/div/label",
    has_sub_photo:         "//div[@id='root']/div/div/div[2]/div/form/div[5]/div/div/div/div/div[2]/label"
    # has_self_introduction: "input#has_self_introduction",
    # has_sub_photo:         "input#has_sub_images"
  }

  xpath_accessor others
  #css_accessor others

  %w(has_self_introduction has_sub_photo).each do |condition|
    define_method "check_#{condition}" do
      eval(condition).click
    end
  end

  def scroll_to(element)
    eval(element).location_once_scrolled_into_view
    sleep 1
  end

  
end
