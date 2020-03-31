# frozen_string_literal: true

require 'descriptive-statistics'

require_relative './utils/statistics'

require_relative './modules/sensor_module'
require_relative './modules/monoxide'
require_relative './modules/thermometer'
require_relative './modules/humidity'

# Entry Point
class SensorEvaluator
  def initialize(log_file)
    @log_file = log_file

    # TODO: Have the sensor modules tell this class
    # what their mapping is, instead of defining it here
    @sensor_map = {
      humidity: Humidity,
      thermometer: Thermometer,
      monoxide: Monoxide
    }

    @patterns = {
      timestamp: /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}/
    }
  end

  def extract_baseline(reference)
    values = reference.split(' ')
    temperature = values[1].to_f
    humidity = values[2].to_f
    monoxide = values[3].to_f

    { thermometer: temperature, humidity: humidity, monoxide: monoxide }
  end

  def evaluate
    baseline = {}

    sensors = {}
    current_sensor = nil

    @log_file.split("\n").each do |logline|
      if logline.start_with? 'reference'
        baseline = extract_baseline(logline)

        next
      end

      # TODO: Allow this to handle N chunks
      # (See next TODO)
      chunk1, chunk2 = logline.split(' ')

      # TODO: Send the whole dang line over
      # to the sensor module so it can handle it however it sees fit
      # (It doesn't make sense to be so definitive
      # about the data format at this point, it's limiting)
      #
      # For example, one benefit would be that we could get rid of
      # the regex checks alltogether and just send everything
      # between each sensor chunk to the module
      is_measurement = @patterns[:timestamp].match(chunk1)
      if is_measurement
        value = chunk2

        sensors[current_sensor].add_measurement(value)

        next
      end

      # TODO: Verify that this is actually a
      # new sensor at this point and not an unexpected line
      measurement = chunk1.to_sym
      sensor_name = chunk2

      current_sensor = sensor_name

      module_type = @sensor_map[measurement]
      new_module = module_type.new(sensor_name, baseline[measurement])

      sensors[sensor_name] = new_module
    end

    classifications = {}
    sensors.each do |name, sensor|
      classifications[name] = sensor.classify
    end

    puts classifications
  end
end

log_data = File.read('input.log')
SensorEvaluator.new(log_data).evaluate
