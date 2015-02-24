require 'Selenium-Webdriver'

class Tumblr
  attr_accessor :wait,:browser,:media_id

  def initialize(media,primary,secondary = nil)
    set_env
    browser.find_element(id: find_id(media)).click
    handle_media_options(media)
    write_message(primary,secondary = nil)
    print_terminal_message
  end

  def set_env()
    @browser = Selenium::WebDriver.for :firefox
    @browser.manage.window.maximize
    @wait = {:five => Selenium::WebDriver::Wait.new(:timeout => 5),
             :ten => Selenium::WebDriver::Wait.new(:timeout => 10)}
    @wait[:ten].until{browser.navigate.to "http://tumblr.com/login"}
    browser.find_element(id: "signup_email").send_keys("tumblrtesting1991@hotmail.com")
    browser.find_element(id: "signup_password").send_keys("tumblrlogin")
    browser.find_element(id: "signup_form").submit
  end

  def find_id(media)
    case media
    when "text"
      return "new_post_label_text"
    when "photo"
      return "new_post_label_photo"
    when "video"
      return "new_post_label_video"
    when "quote"
      return "new_post_label_quote"
    when "audio"
      return "new_post_label_audio"
    when "link"
      return "new_post_label_link"
    else
      return "Please provide a valid media source"
    end
  end

  def handle_media_options(media)
    if media == "photo" || media == "video"
      browser.find_element(class: "media-url-button").click
    end
  end

  def print_terminal_message()
    if browser.find_element(class: "create_post_button").click
      puts "Your post was successfuly uploaded"
    else
      puts "Your post was not uploaded"
    end
  end

  def write_message(primary,secondary = nil)
    @wait[:ten].until{browser.find_element(class: "editor-plaintext").send_keys(primary)}
    if secondary != nil
      @wait[:ten].until{browser.find_element(class: "editor-richtext").send_keys(secondary)}
    end
  end
end

Tumblr.new("quote","Quote title","This is a quote")
#Tumblr.new("photo","https://pbs.twimg.com/profile_images/1847862599/Grad_LFC_Crest_twitter_400x400.jpg")


