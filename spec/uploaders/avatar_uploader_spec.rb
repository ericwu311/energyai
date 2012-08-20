require 'carrierwave/test/matchers'

describe AvatarUploader do
  include CarrierWave::Test::Matchers

  before do
    AvatarUploader.enable_processing = true
    @uploader = AvatarUploader.new(@building, :avatar)
    @uploader.store!(File.open('./spec/flaminmjay.jpg'))
  end

  after do
    AvatarUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the thumb version' do
    it "should scale down a landscape image to be exactly 160 by 120 pixels" do
      @uploader.thumb.should have_dimensions(160, 120)
    end
  end

  it "should make the image readable only to the owner and not executable" do
    @uploader.should have_permissions(0666)
  end
end