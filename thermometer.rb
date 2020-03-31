# frozen_string_literal: true

require_relative 'statistics'

# Thermometer
class Thermometer < SensorModule
  def initialize(name, baseline)
    super(name, baseline)
  end

  def ultra_precise?
    mean_diff <= 0.5 && deviation < 3
  end

  def very_precise?
    mean_diff <= 0.5 && deviation < 5
  end

  def classify
    return 'ultra precise' if ultra_precise?
    return 'very precise' if very_precise?

    'precise'
  end
end
