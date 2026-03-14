# frozen_string_literal: true

require 'legion/extensions/cognitive_flexibility_training/version'
require 'legion/extensions/cognitive_flexibility_training/helpers/constants'
require 'legion/extensions/cognitive_flexibility_training/helpers/training_task'
require 'legion/extensions/cognitive_flexibility_training/helpers/switch_trial'
require 'legion/extensions/cognitive_flexibility_training/helpers/flexibility_engine'
require 'legion/extensions/cognitive_flexibility_training/runners/cognitive_flexibility_training'

module Legion
  module Extensions
    module CognitiveFlexibilityTraining
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
