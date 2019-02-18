#makes sure image resizing doesnt interfere with tests
if Rails.env.test?
    CarrierWave.configure do |config|
        config.enable_processing = false
    end
end
