# frozen_string_literal: true

require_relative 'statistics'

# Humidity
class Humidity < SensorModule
  def initialize(name, baseline)
    super(name, baseline)
  end

  def all_measurements_in_range?
    @measurements.map { |m| (@baseline - m).abs <= 1 }.all?
  end

  def classify
    all_measurements_in_range? ? 'keep' : 'discard'
  end
end
