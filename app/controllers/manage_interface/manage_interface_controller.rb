# frozen_string_literal: true
module ManageInterface
  class ManageInterfaceController < ApplicationController
    layout "support_layout"

    before_action :authenticate_staff!
  end
end
