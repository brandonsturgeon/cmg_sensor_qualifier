# frozen_string_literal: true

# Gets statistics for measurements
class MeasurementStatistics
  def _statistics(data)
    DescriptiveStatistics::Stats.new(data)
  end

  def mean(data)
    _statistics(data).mean
  end

  def deviation(data)
    _statistics(data).standard_deviation
  end
end
