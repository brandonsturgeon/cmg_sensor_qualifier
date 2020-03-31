# frozen_string_literal: true

require_relative 'statistics'

# Thermometer
class Thermometer < SensorModule
  def initialize(name, baseline)
    super(name, baseline)

    @thresholds = {
      classifications: [
        {
          name: 'ultra precise',
          ranges: {
            mean: 0..0.5,
            deviation: 0...3
          }
        },
        {
          name: 'very precise',
          ranges: {
            mean: 0..0.5,
            deviation: 0...5
          }
        }
      ],
      default: 'precise'
    }
  end
end
