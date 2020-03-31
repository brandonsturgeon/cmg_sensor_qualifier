# frozen_string_literal: true

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

  def mean_diff
    (@baseline - @maths.mean(@measurements)).abs
  end

  def deviation
    @maths.deviation(@measurements)
  end
end
