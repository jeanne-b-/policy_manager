module PolicyManager
  class PortabilityRequest < ApplicationRecord
    belongs_to :owner, polymorphic: true
    mount_uploader :attachement, AttachementUploader

    after_create :generate_json

    def generate_json
      file_path = File.join(Rails.root, 'tmp', 'generate_data_dump')
      FileUtils.mkdir_p(file_path) unless File.exists?(file_path)
      file_name = File.join(file_path, "#{self.id.to_s}.json")
      file = File.new(file_name, 'w')

      user_data = Registery.new.data_dump_for(owner)

      begin
        file.flush
        file.write(user_data)
        self.update(attachement: file)
      ensure
        File.delete(file)
      end
    end
  end
end
