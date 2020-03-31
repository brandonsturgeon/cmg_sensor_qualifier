# frozen_string_literal: true

require 'descriptive-statistics'

require_relative 'modules'
require_relative 'monoxide'
require_relative 'thermometer'
require_relative 'humidity'

# Entry Point
class SensorEvaluator
  def initialize(log_file)
    @log_file = log_file

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

      chunk1, chunk2 = logline.split(' ')

      is_measurement = @patterns[:timestamp].match(chunk1)
      if is_measurement
        value = chunk2

        puts "Adding #{value} to #{current_sensor}"
        sensors[current_sensor].add_measurement(value)

        next
      end

      # must be a new measurement at this point
      measurement = chunk1.to_sym
      sensor_name = chunk2
      current_sensor = sensor_name

      module_type = @sensor_map[measurement]
      puts "Creating new sensor with name #{sensor_name} using baseline of #{baseline[measurement]}"
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
