# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/eruby'
require_relative 'rubocop/eruby/version'
require_relative 'rubocop/eruby/inject'

RuboCop::Eruby::Inject.defaults!

require_relative 'rubocop/cop/eruby_cops'
