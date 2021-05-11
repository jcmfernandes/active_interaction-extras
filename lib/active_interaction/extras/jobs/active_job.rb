require 'active_job'

module ActiveInteraction::Extras::Jobs::ActiveJob
  extend ActiveSupport::Concern

  include ActiveInteraction::Extras::Jobs::Core

  class_methods do
    def configured_job_class
      ConfiguredJob
    end
  end

  module Perform
    extend ActiveSupport::Concern

    def perform(*args)
      if self.class.respond_to?(:module_parent)
        self.class.module_parent.run!(*args)
      else
        self.class.parent.run!(*args)
      end
    end
  end

  class ConfiguredJob < ::ActiveJob::ConfiguredJob
    alias_method :run!, :perform_later
    alias_method :run, :perform_later
  end
end
