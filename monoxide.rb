# frozen_string_literal: true

require_relative 'statistics'

# Monoxide
class Monoxide < SensorModule
  def initialize(name, baseline)
    super(name, baseline)

    @thresholds = {
      classifications: [
        {
          name: 'keep',
          ranges: {
            mean: 0..3
          }
        }
      ],
      default: 'discard'
    }
  end
end
