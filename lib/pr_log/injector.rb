module PrLog
  # Injects text into a file
  class Injector
    pattr_initialize :destination_file

    def insert_after(line, text)
      unless replace!(/#{line}/, '\0' + text)
        raise(InsertPointNotFound,
              "Insert point not found in #{destination_file}.")
      end
    end

    private

    def replace!(regexp, text)
      content = File.binread(destination_file)

      return false unless content.gsub!(regexp, text)

      File.open(destination_file, 'wb') do |file|
        file.write(content)
      end
    end
  end
end
