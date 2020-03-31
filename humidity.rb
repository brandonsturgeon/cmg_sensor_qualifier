# frozen_string_literal: true

require_relative 'statistics'

# Humidity
class Humidity < SensorModule
  def initialize(name, baseline)
    super(name, baseline)

    @thresholds = {
      classifications: [
        {
          name: 'keep',
          ranges: {
            mean: 0..1
          }
        }
      ],
      default: 'discard'
    }
  end
end
