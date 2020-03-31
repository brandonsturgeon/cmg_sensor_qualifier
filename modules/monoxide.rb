# frozen_string_literal: true

class Monoxide < SensorModule
  def initialize(name, baseline)
    super(name, baseline)
  end

  def all_measurements_in_range?
    @measurements.map { |m| (@baseline - m).abs <= 3 }.all?
  end

  def classify
    all_measurements_in_range? ? 'keep' : 'discard'
  end
end
