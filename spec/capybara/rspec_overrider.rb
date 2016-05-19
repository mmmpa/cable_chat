module RSpec
  module Core
    class ExampleGroup
      def ready_ss(ex, strict_height = nil)
        @ss_man = ScreenShotMan.new(ex.full_description.split(' '))
        @ss_man.clean!
        @strict_height = strict_height
      end

      def take_ss(name, sleeping = 0)
        sleep sleeping

        height = begin
          page.evaluate_script('document.querySelector("body").clientHeight')
        rescue
          1000
        end

        page.driver.resize(1240, @strict_height || height)
        page.save_screenshot(@ss_man.filename!(name))
      end
    end
  end
end
