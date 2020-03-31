require_relative 'statistics'

# Sensor module definitions
class SensorModule
  def initialize(name, baseline)
    @name = name
    @baseline = baseline
    @maths = MeasurementStatistics.new

    @measurements = []
  end

  def add_measurement(measurement)
    @measurements.push(measurement.to_f)
  end

  def classify
    @thresholds[:classifications].each do |classification|
      name = classification[:name]
      puts "Testing if sensor meets qualifications for #{name}"

      param_qualifications = []

      ranges = classification[:ranges]

      ranges.each do |value, range|
        puts "Checking if sensor's #{value} is within #{range}"

        calculated_value = @maths.send(value, @measurements)
        puts "Calculated sensor's #{value} at #{calculated_value}"

        puts "Getting diff between baseline (#{@baseline}) and calculated #{value} (#{calculated_value})"
        diff = (@baseline - calculated_value).abs
        puts "Calculated diff from baseline to be #{diff}"
        puts "Testing if #{diff} is in #{range}"

        if range.include? diff
          puts "#{diff} is within range, sensor qualifies for #{value}"
          param_qualifications.push(true)
        else
          puts "#{diff} is not within range, sensor fails #{value} check"
          param_qualifications.push(false)
        end
      end

      if param_qualifications.all?
        return name
      end
    end

    @thresholds[:default]
  end
end
