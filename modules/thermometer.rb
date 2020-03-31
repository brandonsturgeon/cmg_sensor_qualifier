# frozen_string_literal: true

# TODO: Find a way to extract the mean_diff and deviation
# thresholds into something more modular and more easily configurable.
# Also should remove the recalculation of mean_diff and deviation for performance reasons

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
